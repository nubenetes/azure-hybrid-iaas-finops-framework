# Mathematical Model: SQL Server Licensing, Constrained vCPUs (CCC), and AHB Synergy

> 🧭 **Navigation**: [🏠 Framework Root](../../README.md) | [📚 Documentation Index](../README.md) | [📐 Math Models Index](README.md) | [⬅️ Previous: Firewall SKU Crossover](firewall-sku-crossover.md) | [➡️ Next: Documentation Portal](../README.md)

## 1. Executive Summary

SQL Server licensing in an enterprise IaaS model represents the single highest software cost multiplier. In Azure, SQL Server is billed **per active virtual core (vCPU)** exposed to the Guest Operating System:
- **SQL Server Enterprise**: $\approx \$0.5484$ per vCPU/hour ($\approx \$400.33 \text{ USD} \approx €368.30 \text{ EUR}$ per vCPU/month) under Pay-As-You-Go.
- **SQL Server Standard**: $\approx \$0.1465$ per vCPU/hour ($\approx \$106.95 \text{ USD} \approx €98.39 \text{ EUR}$ per vCPU/month) under Pay-As-You-Go.

Enterprise database workloads often experience the **"SQL Server Hardware Paradox"**: they require immense memory (RAM) and colossal disk I/O throughput (IOPS and bandwidth), but their transactional query concurrency only requires a fraction of the corresponding vCPU count.

Microsoft addresses this via **Constrained vCPU virtual machine sizes** (e.g., `Standard_E32-8s_v5`). This mathematical model analyzes the financial dynamics of Constrained Cores combined with **Azure Hybrid Benefit (AHB)** and **3-Year Reserved Instances (RIs)**.

> 💶 **Dual Currency Modeling**: Evaluated in **USD ($)** and **EUR (€)** ($1.00 \text{ USD} = 0.92 \text{ EUR}$) across **Spain Central (Madrid)**, **West Europe (Netherlands)**, and **East US**.

---

## 2. Mathematical Formulation

### 2.1 The Cost Architecture of a SQL Server IaaS VM

The total monthly cost of a SQL Server VM in Azure is the sum of three distinct billing components:

$$\text{Cost}_{\text{Total}} = \text{Cost}_{\text{Compute Base}} + \text{Cost}_{\text{Windows OS}} + \text{Cost}_{\text{SQL License}}$$

Where:
- $\text{Cost}_{\text{Compute Base}}$: The physical infrastructure cost (RAM, CPU silicon, NVMe, host bandwidth). Billed based on the **full underlying hardware size** ($N_{\text{phys}}$).
- $\text{Cost}_{\text{Windows OS}}$: The Windows Server license fee ($N_{\text{phys}}$ cores). When **Azure Hybrid Benefit (AHB) for Windows Server** is enabled:
  $$\text{Cost}_{\text{Windows OS}} = \$0.00 \quad (€0.00)$$
- $\text{Cost}_{\text{SQL License}}$: The database engine software fee. Billed **ONLY on the active vCPUs** exposed to the Guest OS ($N_{\text{active}}$):
  $$\text{Cost}_{\text{SQL License}} = N_{\text{active}} \times R_{\text{SQL}}$$

When **Azure Hybrid Benefit (AHB) for SQL Server** is enabled using existing licenses with Software Assurance (SA):
$$\text{Cost}_{\text{SQL License}} = \$0.00 \quad (€0.00)$$

### 2.2 Constrained Core Ratios and Licensing Reduction

$$R_{\text{savings}} = \left( 1 - \frac{N_{\text{active}}}{N_{\text{phys}}} \right) \times 100\%$$

For `Standard_E32-8s_v5`:
$$R_{\text{savings}} = \left( 1 - \frac{8}{32} \right) \times 100\% = 75\% \text{ reduction}$$

---

## 3. Financial Comparison Matrix (E32 Family - 256 GiB RAM, 80,000 IOPS)

Assumptions: Europe Zone 1 / Spain Central / West Europe / East US, 730 hours/month. Conversion: $1.00 \text{ USD} = 0.92 \text{ EUR}$.

| Configuration | Base Compute | Active Cores | SQL Enterprise License | Windows OS | Total Monthly | Annual TCO | Net Savings |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Unconstrained E32s_v5 (Full PAYG)** | $1,868.80 (€1,719.30) | 32 | $12,810.56 (€11,785.72) | $678.90 (€624.59) | **$15,358.26 (€14,129.60)** | **$184,299.12 (€169,555.19)**| Baseline |
| **Constrained E32-16s_v5 (PAYG SQL)** | $1,868.80 (€1,719.30) | 16 | $6,405.28 (€5,892.86) | $678.90 (€624.59) | **$8,952.98 (€8,236.74)** | **$107,435.76 (€98,840.90)** | **41.7% ($76,863 / €70,714 / yr)** |
| **Constrained E32-8s_v5 (PAYG SQL)** | $1,868.80 (€1,719.30) | 8 | $3,202.64 (€2,946.43) | $678.90 (€624.59) | **$5,750.34 (€5,290.31)** | **$69,004.08 (€63,483.75)** | **62.6% ($115,295 / €106,071 / yr)** |
| **Constrained E32-8s_v5 + Windows AHB**| $1,868.80 (€1,719.30) | 8 | $3,202.64 (€2,946.43) | $0.00 (€0.00) | **$5,071.44 (€4,665.72)** | **$60,857.28 (€55,988.70)** | **67.0% ($123,442 / €113,566 / yr)** |
| **E32-8s_v5 + Win AHB + SQL AHB** | $1,868.80 (€1,719.30) | 8 | $0.00 (€0.00) | $0.00 (€0.00) | **$1,868.80 (€1,719.30)** | **$22,425.60 (€20,631.55)** | **87.8% ($161,873 / €148,923 / yr)** |
| **E32-8s_v5 + Win AHB + SQL AHB + 3-Yr RI** | $654.08 (€601.75) | 8 | $0.00 (€0.00) | $0.00 (€0.00) | **$654.08 (€601.75)** | **$7,848.96 (€7,221.04)** | **95.7% ($176,450 / €162,334 / yr)** |

---

## 🧭 Navigation

| [⬅️ Previous: Firewall SKU Crossover](firewall-sku-crossover.md) | [📐 Math Models Index](README.md) | [➡️ Next: Documentation Portal](../README.md) |
| :--- | :---: | ---: |
| [📚 Documentation Index](../README.md) | [🏠 Framework Root](../../README.md) | [Next Mathematical Model ➡️](../README.md) |

