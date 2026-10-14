#!/usr/bin/env python3
"""
Azure Hybrid IaaS FinOps Calculator & Decision Engine
Evaluates mathematical break-even points, TCO, and licensing savings across:
- Azure ExpressRoute (Metered vs. Unlimited)
- Azure Firewall (Basic vs. Standard vs. Premium)
- SQL Server on Azure VMs (Constrained vCPUs / CCC, AHB, RIs)
- Storage (Premium SSD v1 vs. Premium SSD v2)

Supports Dual-Currency (USD $ and EUR €) and representative regions:
- Spain Central (Madrid) - spaincentral
- West Europe (Netherlands) - westeurope
- East US (Virginia) - eastus
"""

import argparse
import json
import sys
from typing import Dict, Any

# Standard reference rate for cloud financial modeling (1 USD = 0.92 EUR)
DEFAULT_EUR_PER_USD = 0.92

# Regional latency / tier adjustments (Zone 1 baseline)
REGION_PROFILES = {
    "spaincentral": {"name": "Spain Central (Madrid)", "zone": 1, "currency_pref": "EUR"},
    "westeurope": {"name": "West Europe (Netherlands)", "zone": 1, "currency_pref": "EUR"},
    "eastus": {"name": "East US (Virginia)", "zone": 1, "currency_pref": "USD"},
}

# ---------------------------------------------------------
# 1. ExpressRoute Model
# ---------------------------------------------------------
EXPRESSROUTE_PORT_FEES = {
    50: {"metered": 55.0, "unlimited": 300.0},
    100: {"metered": 105.0, "unlimited": 530.0},
    200: {"metered": 150.0, "unlimited": 900.0},
    500: {"metered": 275.0, "unlimited": 2100.0},
    1000: {"metered": 436.0, "unlimited": 6450.0},
    10000: {"metered": 2180.0, "unlimited": 51600.0},
}


def calculate_expressroute(
    bandwidth_mbps: int,
    monthly_egress_gb: float,
    egress_rate_usd: float = 0.025,
    eur_rate: float = DEFAULT_EUR_PER_USD,
    region: str = "spaincentral",
) -> Dict[str, Any]:
    if bandwidth_mbps not in EXPRESSROUTE_PORT_FEES:
        closest = min(EXPRESSROUTE_PORT_FEES.keys(), key=lambda x: abs(x - bandwidth_mbps))
        fees = EXPRESSROUTE_PORT_FEES[closest]
    else:
        fees = EXPRESSROUTE_PORT_FEES[bandwidth_mbps]

    p_metered = fees["metered"]
    p_unlimited = fees["unlimited"]

    cost_metered_usd = p_metered + (monthly_egress_gb * egress_rate_usd)
    cost_unlimited_usd = p_unlimited

    # E_break_even = (P_unlimited - P_metered) / C_egress
    breakeven_gb = (p_unlimited - p_metered) / egress_rate_usd if egress_rate_usd > 0 else float("inf")

    # Max theoretical egress: (bandwidth_mbps * 1e6 / 8 / 1e9) * 2,628,000
    max_egress_gb = (bandwidth_mbps * 1_000_000 / 8 / 1_000_000_000) * 2_628_000
    breakeven_saturation_pct = (breakeven_gb / max_egress_gb * 100.0) if max_egress_gb > 0 else 0.0

    recommendation = "Metered" if cost_metered_usd < cost_unlimited_usd else "Unlimited"
    savings_usd = abs(cost_unlimited_usd - cost_metered_usd)

    return {
        "region": REGION_PROFILES.get(region, {}).get("name", region),
        "bandwidth_mbps": bandwidth_mbps,
        "monthly_egress_gb": monthly_egress_gb,
        "egress_rate_usd_per_gb": egress_rate_usd,
        "egress_rate_eur_per_gb": round(egress_rate_usd * eur_rate, 4),
        "cost_metered_usd": round(cost_metered_usd, 2),
        "cost_metered_eur": round(cost_metered_usd * eur_rate, 2),
        "cost_unlimited_usd": round(cost_unlimited_usd, 2),
        "cost_unlimited_eur": round(cost_unlimited_usd * eur_rate, 2),
        "breakeven_egress_gb": round(breakeven_gb, 2),
        "breakeven_egress_tb": round(breakeven_gb / 1024.0, 2),
        "breakeven_saturation_pct": round(breakeven_saturation_pct, 2),
        "recommendation": recommendation,
        "monthly_savings_usd": round(savings_usd, 2),
        "monthly_savings_eur": round(savings_usd * eur_rate, 2),
    }


# ---------------------------------------------------------
# 2. Azure Firewall Model
# ---------------------------------------------------------
FIREWALL_HOURLY_RATES = {
    "Basic": 0.395,
    "Standard": 1.250,
    "Premium": 1.750,
}

FIREWALL_PROCESSING_RATES = {
    "Basic": 0.065,
    "Standard": 0.016,
    "Premium": 0.016,
}


def calculate_firewall(
    monthly_gb: float,
    hours_per_month: float = 730.0,
    eur_rate: float = DEFAULT_EUR_PER_USD,
    region: str = "spaincentral",
) -> Dict[str, Any]:
    cost_basic_usd = (FIREWALL_HOURLY_RATES["Basic"] * hours_per_month) + (monthly_gb * FIREWALL_PROCESSING_RATES["Basic"])
    cost_standard_usd = (FIREWALL_HOURLY_RATES["Standard"] * hours_per_month) + (monthly_gb * FIREWALL_PROCESSING_RATES["Standard"])
    cost_premium_usd = (FIREWALL_HOURLY_RATES["Premium"] * hours_per_month) + (monthly_gb * FIREWALL_PROCESSING_RATES["Premium"])

    # Crossover between Basic and Standard
    fixed_delta = (FIREWALL_HOURLY_RATES["Standard"] - FIREWALL_HOURLY_RATES["Basic"]) * hours_per_month
    rate_delta = FIREWALL_PROCESSING_RATES["Basic"] - FIREWALL_PROCESSING_RATES["Standard"]
    crossover_gb = fixed_delta / rate_delta if rate_delta > 0 else float("inf")

    rec = "Basic" if cost_basic_usd <= cost_standard_usd else "Standard"
    savings_usd = abs(cost_standard_usd - cost_basic_usd)

    return {
        "region": REGION_PROFILES.get(region, {}).get("name", region),
        "monthly_gb_processed": monthly_gb,
        "hours_per_month": hours_per_month,
        "cost_basic_usd": round(cost_basic_usd, 2),
        "cost_basic_eur": round(cost_basic_usd * eur_rate, 2),
        "cost_standard_usd": round(cost_standard_usd, 2),
        "cost_standard_eur": round(cost_standard_usd * eur_rate, 2),
        "cost_premium_usd": round(cost_premium_usd, 2),
        "cost_premium_eur": round(cost_premium_usd * eur_rate, 2),
        "crossover_gb": round(crossover_gb, 2),
        "crossover_tb": round(crossover_gb / 1024.0, 2),
        "recommendation": rec,
        "savings_vs_other_usd": round(savings_usd, 2),
        "savings_vs_other_eur": round(savings_usd * eur_rate, 2),
    }


# ---------------------------------------------------------
# 3. SQL Server & Constrained vCPUs Model
# ---------------------------------------------------------
SQL_LICENSE_HOURLY_RATES = {
    "Enterprise": 0.5484,  # ~$400.33 / core / mo
    "Standard": 0.1465,    # ~$106.95 / core / mo
    "Developer": 0.0,
}

WINDOWS_OS_HOURLY_PER_CORE = 0.029  # ~$21.17 / core / mo
BASE_COMPUTE_HOURLY_PER_CORE = 0.08  # Approx baseline hardware rate


def calculate_sql_licensing(
    total_physical_cores: int = 32,
    active_cores: int = 8,
    sql_edition: str = "Enterprise",
    has_windows_ahb: bool = False,
    has_sql_ahb: bool = False,
    ri_years: int = 0,
    hours_per_month: float = 730.0,
    eur_rate: float = DEFAULT_EUR_PER_USD,
    region: str = "spaincentral",
) -> Dict[str, Any]:
    sql_rate = SQL_LICENSE_HOURLY_RATES.get(sql_edition, SQL_LICENSE_HOURLY_RATES["Enterprise"])
    win_rate = 0.0 if has_windows_ahb else WINDOWS_OS_HOURLY_PER_CORE

    compute_discount = 0.0
    if ri_years == 1:
        compute_discount = 0.40
    elif ri_years >= 3:
        compute_discount = 0.65

    # 1. Unconstrained Baseline
    baseline_compute = (total_physical_cores * BASE_COMPUTE_HOURLY_PER_CORE) * hours_per_month
    baseline_win = (total_physical_cores * WINDOWS_OS_HOURLY_PER_CORE) * hours_per_month
    baseline_sql = (total_physical_cores * sql_rate) * hours_per_month
    baseline_total_usd = baseline_compute + baseline_win + baseline_sql

    # 2. Optimized
    opt_compute = (total_physical_cores * BASE_COMPUTE_HOURLY_PER_CORE * (1.0 - compute_discount)) * hours_per_month
    opt_win = (total_physical_cores * win_rate) * hours_per_month
    opt_sql = 0.0 if has_sql_ahb else (active_cores * sql_rate * hours_per_month)
    opt_total_usd = opt_compute + opt_win + opt_sql

    savings_usd = baseline_total_usd - opt_total_usd
    savings_pct = (savings_usd / baseline_total_usd * 100.0) if baseline_total_usd > 0 else 0.0
    licensing_reduction_pct = ((total_physical_cores - active_cores) / total_physical_cores * 100.0)

    return {
        "region": REGION_PROFILES.get(region, {}).get("name", region),
        "total_physical_cores": total_physical_cores,
        "active_cores": active_cores,
        "sql_edition": sql_edition,
        "has_windows_ahb": has_windows_ahb,
        "has_sql_ahb": has_sql_ahb,
        "ri_years": ri_years,
        "baseline_monthly_usd": round(baseline_total_usd, 2),
        "baseline_monthly_eur": round(baseline_total_usd * eur_rate, 2),
        "optimized_monthly_usd": round(opt_total_usd, 2),
        "optimized_monthly_eur": round(opt_total_usd * eur_rate, 2),
        "monthly_savings_usd": round(savings_usd, 2),
        "monthly_savings_eur": round(savings_usd * eur_rate, 2),
        "annual_savings_usd": round(savings_usd * 12.0, 2),
        "annual_savings_eur": round(savings_usd * 12.0 * eur_rate, 2),
        "total_savings_pct": round(savings_pct, 2),
        "licensing_core_reduction_pct": round(licensing_reduction_pct, 2),
    }


# ---------------------------------------------------------
# 4. Storage Model (Premium SSD v1 vs. v2)
# ---------------------------------------------------------
PREMIUM_V1_TIERS = [
    (128, 500, 100, 19.71),
    (256, 1100, 125, 38.01),
    (512, 2300, 150, 73.22),
    (1024, 5000, 200, 135.17),
    (2048, 7500, 250, 256.70),
    (4096, 7500, 250, 480.00),
]


def calculate_storage(
    capacity_gb: int,
    needed_iops: int,
    needed_throughput_mbps: int,
    eur_rate: float = DEFAULT_EUR_PER_USD,
    region: str = "spaincentral",
) -> Dict[str, Any]:
    matching_tier = None
    for size, iops, mbps, cost in PREMIUM_V1_TIERS:
        if size >= capacity_gb and iops >= needed_iops and mbps >= needed_throughput_mbps:
            matching_tier = (1, size, iops, mbps, cost)
            break

    if not matching_tier:
        base_tier = PREMIUM_V1_TIERS[-2]  # P40
        disks_by_iops = (needed_iops + base_tier[1] - 1) // base_tier[1]
        disks_by_mbps = (needed_throughput_mbps + base_tier[2] - 1) // base_tier[2]
        disks_needed = max(2, disks_by_iops, disks_by_mbps)
        matching_tier = (disks_needed, base_tier[0] * disks_needed, base_tier[1] * disks_needed, base_tier[2] * disks_needed, base_tier[3] * disks_needed)

    num_disks_v1, total_cap_v1, total_iops_v1, total_mbps_v1, cost_v1_usd = matching_tier

    # Premium SSD v2
    v2_cap_cost = capacity_gb * 0.0808
    v2_extra_iops = max(0, needed_iops - 3000)
    v2_iops_cost = v2_extra_iops * 0.0051
    v2_extra_mbps = max(0, needed_throughput_mbps - 125)
    v2_mbps_cost = v2_extra_mbps * 0.061
    cost_v2_usd = v2_cap_cost + v2_iops_cost + v2_mbps_cost

    savings_usd = cost_v1_usd - cost_v2_usd
    savings_pct = (savings_usd / cost_v1_usd * 100.0) if cost_v1_usd > 0 else 0.0

    return {
        "region": REGION_PROFILES.get(region, {}).get("name", region),
        "requested_capacity_gb": capacity_gb,
        "requested_iops": needed_iops,
        "requested_throughput_mbps": needed_throughput_mbps,
        "premium_v1_disks": num_disks_v1,
        "premium_v1_allocated_gb": total_cap_v1,
        "premium_v1_cost_usd": round(cost_v1_usd, 2),
        "premium_v1_cost_eur": round(cost_v1_usd * eur_rate, 2),
        "premium_v2_cost_usd": round(cost_v2_usd, 2),
        "premium_v2_cost_eur": round(cost_v2_usd * eur_rate, 2),
        "monthly_savings_usd": round(savings_usd, 2),
        "monthly_savings_eur": round(savings_usd * eur_rate, 2),
        "savings_pct": round(savings_pct, 2),
        "recommendation": "Premium SSD v2 (Decoupled, zero RAID 0 overhead)" if cost_v2_usd < cost_v1_usd else "Evaluate specific tier",
    }


# ---------------------------------------------------------
# CLI Dispatcher
# ---------------------------------------------------------
def create_common_parser():
    p = argparse.ArgumentParser(add_help=False)
    p.add_argument("--region", type=str, default="spaincentral", choices=["spaincentral", "westeurope", "eastus"], help="Target Azure Region (default: spaincentral)")
    p.add_argument("--eur-rate", type=float, default=DEFAULT_EUR_PER_USD, help="EUR per USD exchange rate (default: 0.92)")
    p.add_argument("--currency", type=str, default="BOTH", choices=["BOTH", "USD", "EUR"], help="Currency display filter")
    p.add_argument("--json", action="store_true", help="Output results in JSON format")
    return p


def main():
    common_p = create_common_parser()
    parser = argparse.ArgumentParser(description="Azure Hybrid IaaS FinOps Dual-Currency Calculator (USD $ / EUR €)", parents=[common_p])
    subparsers = parser.add_subparsers(dest="command", required=True)

    # Subcommand: expressroute
    p_er = subparsers.add_parser("expressroute", help="Compare ExpressRoute Metered vs. Unlimited plans", parents=[common_p])
    p_er.add_argument("--bandwidth", type=int, default=1000, choices=[50, 100, 200, 500, 1000, 10000], help="Circuit bandwidth in Mbps")
    p_er.add_argument("--monthly-egress-gb", type=float, default=5000.0, help="Expected monthly egress in GB")
    p_er.add_argument("--egress-rate", type=float, default=0.025, help="Egress fee per GB (USD)")

    # Subcommand: firewall
    p_fw = subparsers.add_parser("firewall", help="Compare Azure Firewall Basic vs. Standard vs. Premium", parents=[common_p])
    p_fw.add_argument("--monthly-gb", type=float, default=5000.0, help="Data volume processed in GB")
    p_fw.add_argument("--hours", type=float, default=730.0, help="Active hours per month")

    # Subcommand: sql-licensing
    p_sql = subparsers.add_parser("sql-licensing", help="Calculate SQL Server Constrained vCPU & AHB savings", parents=[common_p])
    p_sql.add_argument("--physical-cores", type=int, default=32, help="Underlying host physical cores")
    p_sql.add_argument("--active-cores", type=int, default=8, help="Active cores exposed to OS (CCC)")
    p_sql.add_argument("--edition", type=str, default="Enterprise", choices=["Enterprise", "Standard", "Developer"])
    p_sql.add_argument("--windows-ahb", action="store_true", help="Enable Azure Hybrid Benefit for Windows Server")
    p_sql.add_argument("--sql-ahb", action="store_true", help="Enable Azure Hybrid Benefit for SQL Server")
    p_sql.add_argument("--ri-years", type=int, default=0, choices=[0, 1, 3], help="Reserved Instance duration in years")

    # Subcommand: storage
    p_st = subparsers.add_parser("storage", help="Compare Premium SSD v1 vs. Premium SSD v2", parents=[common_p])
    p_st.add_argument("--capacity-gb", type=int, default=1024, help="Required capacity in GiB")
    p_st.add_argument("--iops", type=int, default=12000, help="Required IOPS")
    p_st.add_argument("--throughput", type=int, default=250, help="Required throughput in MB/s")

    args = parser.parse_args()

    if args.command == "expressroute":
        res = calculate_expressroute(args.bandwidth, args.monthly_egress_gb, args.egress_rate, args.eur_rate, args.region)
    elif args.command == "firewall":
        res = calculate_firewall(args.monthly_gb, args.hours, args.eur_rate, args.region)
    elif args.command == "sql-licensing":
        res = calculate_sql_licensing(args.physical_cores, args.active_cores, args.edition, args.windows_ahb, args.sql_ahb, args.ri_years, eur_rate=args.eur_rate, region=args.region)
    elif args.command == "storage":
        res = calculate_storage(args.capacity_gb, args.iops, args.throughput, args.eur_rate, args.region)
    else:
        parser.print_help()
        sys.exit(1)

    if args.json:
        print(json.dumps(res, indent=2))
    else:
        print("\n=========================================================================")
        print(f" AZURE FINOPS ENGINE: {args.command.upper()} | {res.get('region', args.region)}")
        print(f" Currency Rate: 1 USD = {args.eur_rate} EUR")
        print("=========================================================================")
        for k, v in res.items():
            if args.currency == "USD" and k.endswith("_eur"):
                continue
            if args.currency == "EUR" and k.endswith("_usd"):
                continue
            k_fmt = k.replace("_", " ").title()
            val_fmt = f"{v:,.2f}" if isinstance(v, (int, float)) and not isinstance(v, bool) and not k.endswith("_pct") and not k.endswith("_gb") and not k.endswith("_tb") and not k.endswith("_mbps") and not k.endswith("_years") and not k.endswith("_cores") and not k.endswith("_disks") else str(v)
            if k.endswith("_usd"):
                val_fmt = f"${val_fmt}"
            elif k.endswith("_eur"):
                val_fmt = f"€{val_fmt}"
            print(f" {k_fmt:32}: {val_fmt}")
        print("=========================================================================\n")


if __name__ == "__main__":
    main()
