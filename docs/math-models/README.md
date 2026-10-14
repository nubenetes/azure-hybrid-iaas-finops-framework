# 📐 Mathematical Break-Even Formulations (Dual-Currency: USD $ & EUR €)

> 🧭 **Navigation**: [🏠 Framework Root](../../README.md) | [📚 Documentation Index](../README.md)

This directory houses formal mathematical break-even models, economic proofs, and algebraic crossover thresholds governing hybrid cloud resource commitments. All equations and numerical evaluations are modeled in both **USD ($)** and **EUR (€)** ($1.00 USD = €0.92 EUR).

## Index of Mathematical Formulations

| Model | Target Resource | Formula / Proof | Key Economic Threshold |
| :--- | :--- | :--- | :--- |
| **[ExpressRoute Break-Even](expressroute-breakeven.md)** | Hybrid Networking | $E_{\text{break-even}} = \frac{P_{\text{unlimited}} - P_{\text{metered}}}{C_{\text{egress}}}$ | 1 Gbps circuit break-even = **240.6 TB/month (73.2% 24/7 saturation)**. Below this, Metered saves $5,814 / €5,349 monthly. |
| **[Firewall SKU Crossover](firewall-sku-crossover.md)** | Perimeter Security | $V_{\text{crossover}} = \frac{\Delta \text{Fixed}}{\Delta \text{Processing Rate}}$ | Basic vs Standard crossover = **12.74 TB/month**. Standard is economically superior above this volume. |
| **[SQL Licensing CCC Matrix](sql-licensing-ccc-matrix.md)** | Core Licensing | $R_{\text{savings}} = \left(1 - \frac{N_{\text{active}}}{N_{\text{phys}}}\right) \times 100\%$ | `E32-8s_v5` yields **75% software licensing reduction** while retaining 100% of 256 GiB RAM and 80k IOPS. |

---

## Interactive Validation CLI

All mathematical models defined above are implemented with unit tests in [`automation/python/finops_calculator.py`](../../automation/python/finops_calculator.py):

```bash
# Verify ExpressRoute break-even in Madrid (Spain Central):
python3 automation/python/finops_calculator.py expressroute --bandwidth-gbps 1 --region spaincentral --currency BOTH

# Verify Azure Firewall crossover in West Europe:
python3 automation/python/finops_calculator.py firewall --region westeurope --currency BOTH

# Verify SQL Constrained Core licensing savings:
python3 automation/python/finops_calculator.py sql-ccc --physical-cores 32 --active-cores 8 --currency BOTH
```

---

## 🧭 Navigation

- ⬅️ Return to **[Documentation Portal](../README.md)**
- 🏠 Return to **[Framework Root](../../README.md)**
