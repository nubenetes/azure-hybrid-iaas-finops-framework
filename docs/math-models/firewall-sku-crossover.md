# Mathematical Model: Azure Firewall SKU Crossover & Break-Even Analysis

## 1. Executive Summary

Azure Firewall is a cloud-native, fully stateful Network-as-a-Service (PaaS) deployed within the central Hub VNet of a hub-spoke topology. Azure Firewall utilizes a **two-dimensional pricing model**:
1. **Fixed Hourly Deployment Fee**: Charged per hour the firewall resource exists.
2. **Variable Data Processing Fee**: Charged per Gigabyte of data inspected/traversed across the firewall.

When choosing between **Azure Firewall Basic** and **Azure Firewall Standard**, engineering teams frequently choose Basic because of its lower fixed hourly rate ($0.395/hr vs. $1.25/hr). However, Azure Firewall Basic charges **$0.065 per GB** for data processing, whereas Standard charges only **$0.016 per GB**—a **4x higher variable penalty on Basic**.

> 💶 **Dual-Currency Baseline**: Modeled in **USD ($)** and **EUR (€)** ($1.00 USD = €0.92 EUR) applicable to **Spain Central (Madrid)**, **West Europe (Netherlands)**, and **East US**.

---

## 2. Mathematical Formulation

### 2.1 Pricing Parameters (Zone 1 - 730 hours/month)

| SKU | Fixed Hourly Rate | Fixed Monthly Cost | Data Processing Rate | Max Throughput Limit |
| :--- | :--- | :--- | :--- | :--- |
| **Basic** | $0.395 / hr (**€0.363 / hr**) | $288.35 / mo (**€265.28 / mo**) | $0.065 / GB (**€0.060 / GB**) | 250 Mbps |
| **Standard** | $1.250 / hr (**€1.150 / hr**) | $912.50 / mo (**€839.50 / mo**) | $0.016 / GB (**€0.0147 / GB**) | 30 Gbps |
| **Premium** | $1.750 / hr (**€1.610 / hr**) | $1,277.50 / mo (**€1,175.30 / mo**)| $0.016 / GB (**€0.0147 / GB**) | 30 Gbps + TLS/IDPS |

### 2.2 Cost Equations

Let $V$ be the total monthly volume of data processed through the firewall in Gigabytes ($\text{GB}$):

$$\text{Cost}_{\text{Basic}}(V) = 288.35 + 0.065 \times V \quad [\text{EUR}: 265.28 + 0.060 \times V]$$

$$\text{Cost}_{\text{Standard}}(V) = 912.50 + 0.016 \times V \quad [\text{EUR}: 839.50 + 0.0147 \times V]$$

### 2.3 Crossover Point ($V_{\text{crossover}}$)

The volume where Azure Firewall Basic costs exactly equal Azure Firewall Standard:

$$\text{Cost}_{\text{Basic}}(V_{\text{crossover}}) = \text{Cost}_{\text{Standard}}(V_{\text{crossover}})$$

$$288.35 + 0.065 \times V_{\text{crossover}} = 912.50 + 0.016 \times V_{\text{crossover}}$$

$$V_{\text{crossover}} = \frac{624.15}{0.049} \approx 12,737.76 \text{ GB} \approx 12.74 \text{ TB/month}$$

---

## 3. Comparison Matrix Across Monthly Data Volumes (Dual Currency)

| Monthly Volume ($V$) | Basic Total Cost | Standard Total Cost | Premium Total Cost | Recommendation |
| :--- | :--- | :--- | :--- | :--- |
| **500 GB** | $320.85 (**€295.18**) | $920.50 (**€846.86**) | $1,285.50 (**€1,182.66**) | **Basic** (Dev / Micro-spoke) |
| **2,000 GB (2 TB)** | $418.35 (**€384.88**) | $944.50 (**€868.94**) | $1,309.50 (**€1,204.74**) | **Basic** (Moderate dev hub) |
| **5,000 GB (5 TB)** | $613.35 (**€564.28**) | $992.50 (**€913.10**) | $1,357.50 (**€1,248.90**) | **Basic** (approaching limits) |
| **10,000 GB (10 TB)** | $938.35 (**€863.28**) | $1,072.50 (**€986.70**) | $1,437.50 (**€1,322.50**) | **Standard** (Near parity + 30 Gbps) |
| **12,738 GB (~12.7 TB)** | **$1,116.32 (€1,027.01)**| **$1,116.32 (€1,027.01)**| **$1,481.32 (€1,362.81)** | **EXACT CROSSOVER POINT** |
| **20,000 GB (20 TB)** | $1,588.35 (**€1,461.28**)| $1,232.50 (**€1,133.90**)| $1,597.50 (**€1,469.70**) | **Standard** (Saves $355.85 / €327.38) |
| **50,000 GB (50 TB)** | $3,538.35 (**€3,255.28**)| $1,712.50 (**€1,575.50**)| $2,077.50 (**€1,911.30**) | **Standard** (Saves $1,825.85 / €1,679.78) |
| **100,000 GB (100 TB)**| $6,788.35 (**€6,245.28**)| $2,512.50 (**€2,311.50**)| $2,877.50 (**€2,647.30**) | **Standard** (Saves $4,275.85 / €3,933.78) |
