#!/usr/bin/env python3
"""
Unit tests for Azure Hybrid IaaS FinOps Calculator
Verifies mathematical break-even points, licensing equations, storage models,
and dual-currency (USD $ and EUR €) calculations across representative regions.
"""

import unittest
from finops_calculator import (
    calculate_expressroute,
    calculate_firewall,
    calculate_sql_licensing,
    calculate_storage,
    DEFAULT_EUR_PER_USD,
)


class TestFinOpsCalculator(unittest.TestCase):

    def test_expressroute_breakeven_1gbps_dual_currency(self):
        res = calculate_expressroute(
            bandwidth_mbps=1000,
            monthly_egress_gb=5000.0,
            egress_rate_usd=0.025,
            eur_rate=0.92,
            region="spaincentral",
        )
        self.assertEqual(res["cost_metered_usd"], 561.00)
        self.assertEqual(res["cost_metered_eur"], round(561.00 * 0.92, 2))
        self.assertEqual(res["cost_unlimited_usd"], 6450.00)
        self.assertEqual(res["cost_unlimited_eur"], round(6450.00 * 0.92, 2))
        self.assertEqual(res["breakeven_egress_gb"], 240560.0)
        self.assertEqual(res["recommendation"], "Metered")
        self.assertIn("Spain Central", res["region"])
        self.assertGreater(res["monthly_savings_eur"], 5300.0)

    def test_expressroute_unlimited_switch(self):
        res = calculate_expressroute(bandwidth_mbps=1000, monthly_egress_gb=250000.0, egress_rate_usd=0.025)
        self.assertEqual(res["recommendation"], "Unlimited")

    def test_firewall_crossover_dual_currency(self):
        res = calculate_firewall(monthly_gb=5000.0, hours_per_month=730.0, eur_rate=0.92, region="spaincentral")
        self.assertAlmostEqual(res["crossover_gb"], 12737.76, delta=1.0)
        self.assertEqual(res["recommendation"], "Basic")
        self.assertAlmostEqual(res["cost_basic_eur"], round(res["cost_basic_usd"] * 0.92, 2))

        res_heavy = calculate_firewall(monthly_gb=20000.0, hours_per_month=730.0)
        self.assertEqual(res_heavy["recommendation"], "Standard")

    def test_sql_licensing_constrained_cores_75_pct_reduction(self):
        res = calculate_sql_licensing(
            total_physical_cores=32,
            active_cores=8,
            sql_edition="Enterprise",
            has_windows_ahb=False,
            has_sql_ahb=False,
            ri_years=0,
            eur_rate=0.92,
            region="spaincentral",
        )
        self.assertEqual(res["licensing_core_reduction_pct"], 75.0)
        self.assertGreater(res["monthly_savings_usd"], 6000.0)
        self.assertGreater(res["monthly_savings_eur"], 5500.0)
        self.assertGreater(res["total_savings_pct"], 60.0)

    def test_sql_licensing_with_ahb_and_3yr_ri_eur(self):
        res = calculate_sql_licensing(
            total_physical_cores=32,
            active_cores=8,
            sql_edition="Enterprise",
            has_windows_ahb=True,
            has_sql_ahb=True,
            ri_years=3,
            eur_rate=0.92,
            region="spaincentral",
        )
        self.assertGreater(res["total_savings_pct"], 90.0)
        self.assertGreater(res["annual_savings_eur"], 138000.0)

    def test_storage_premium_v1_vs_v2_dual_currency(self):
        res = calculate_storage(
            capacity_gb=1024,
            needed_iops=12000,
            needed_throughput_mbps=250,
            eur_rate=0.92,
            region="spaincentral",
        )
        self.assertGreater(res["savings_pct"], 60.0)
        self.assertGreater(res["monthly_savings_usd"], 300.0)
        self.assertGreater(res["monthly_savings_eur"], 275.0)
        self.assertIn("Premium SSD v2", res["recommendation"])


if __name__ == "__main__":
    unittest.main()
