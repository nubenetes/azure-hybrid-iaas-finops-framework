#!/usr/bin/env python3
"""
Unit tests for Azure Hybrid IaaS FinOps Calculator
Verifies mathematical break-even points, licensing equations, and storage models.
"""

import unittest
from finops_calculator import (
    calculate_expressroute,
    calculate_firewall,
    calculate_sql_licensing,
    calculate_storage,
)


class TestFinOpsCalculator(unittest.TestCase):

    def test_expressroute_breakeven_1gbps(self):
        res = calculate_expressroute(bandwidth_mbps=1000, monthly_egress_gb=5000.0, egress_rate=0.025)
        self.assertEqual(res["cost_metered_usd"], 436.0 + (5000.0 * 0.025))  # 561.00
        self.assertEqual(res["cost_unlimited_usd"], 6450.0)
        # Breakeven volume = (6450 - 436) / 0.025 = 240,560 GB
        self.assertEqual(res["breakeven_egress_gb"], 240560.0)
        self.assertEqual(res["recommendation"], "Metered")
        self.assertGreater(res["monthly_savings_usd"], 5800.0)

    def test_expressroute_unlimited_switch(self):
        # When traffic exceeds 240,560 GB, Unlimited is recommended
        res = calculate_expressroute(bandwidth_mbps=1000, monthly_egress_gb=250000.0, egress_rate=0.025)
        self.assertEqual(res["recommendation"], "Unlimited")

    def test_firewall_crossover(self):
        # 730 hours. Crossover point is ~12,737 GB
        res = calculate_firewall(monthly_gb=5000.0, hours_per_month=730.0)
        self.assertAlmostEqual(res["crossover_gb"], 12737.76, delta=1.0)
        self.assertEqual(res["recommendation"], "Basic")

        res_heavy = calculate_firewall(monthly_gb=20000.0, hours_per_month=730.0)
        self.assertEqual(res_heavy["recommendation"], "Standard")

    def test_sql_licensing_constrained_cores_75_pct_reduction(self):
        # 32 cores -> 8 cores with SQL Enterprise
        res = calculate_sql_licensing(
            total_physical_cores=32,
            active_cores=8,
            sql_edition="Enterprise",
            has_windows_ahb=False,
            has_sql_ahb=False,
            ri_years=0,
        )
        self.assertEqual(res["licensing_core_reduction_pct"], 75.0)
        self.assertGreater(res["monthly_savings_usd"], 6000.0)
        self.assertGreater(res["total_savings_pct"], 60.0)

    def test_sql_licensing_with_ahb_and_3yr_ri(self):
        # 32 physical cores, 8 active cores, AHB for both, 3-Yr RI
        res = calculate_sql_licensing(
            total_physical_cores=32,
            active_cores=8,
            sql_edition="Enterprise",
            has_windows_ahb=True,
            has_sql_ahb=True,
            ri_years=3,
        )
        # SQL license is 0, Win OS is 0, compute hardware has 65% discount
        self.assertGreater(res["total_savings_pct"], 90.0)
        self.assertGreater(res["annual_savings_usd"], 150000.0)

    def test_storage_premium_v1_vs_v2(self):
        # 1024 GB, 12,000 IOPS, 250 MB/s
        res = calculate_storage(capacity_gb=1024, needed_iops=12000, needed_throughput_mbps=250)
        self.assertGreater(res["savings_pct"], 60.0)
        self.assertGreater(res["monthly_savings_usd"], 300.0)
        self.assertIn("Premium SSD v2", res["recommendation"])


if __name__ == "__main__":
    unittest.main()
