# Mathematical Model: Azure Firewall SKU Crossover & Break-Even Analysis

## 1. Executive Summary

Azure Firewall is a cloud-native, fully stateful Network-as-a-Service (PaaS) deployed within the central Hub VNet of a hub-spoke topology. Azure Firewall utilizes a **two-dimensional pricing model**:
1. **Fixed Hourly Deployment Fee**: Charged per hour the firewall resource exists.
2. **Variable Data Processing Fee**: Charged per Gigabyte of data inspected/traversed across the firewall.

When choosing between **Azure Firewall Basic** and **Azure Firewall Standard**, engineering teams frequently choose Basic because of its lower fixed hourly rate ($0.395/hr vs. $1.25/hr). However, Azure Firewall Basic charges **$0.065 per GB** for data processing, whereas Standard charges only **$0.016 per GB**—a **4x higher variable penalty on Basic**.

This document mathematically models the exact data volume crossover point where Azure Firewall Basic becomes *more expensive* than Azure Firewall Standard, and outlines how non-production scheduling eliminates the fixed cost penalty.

---

## 2. Mathematical Formulation

### 2.1 Pricing Parameters (Zone 1 - 730 hours/month)

| SKU | Fixed Hourly Rate ($/hr) | Fixed Monthly Cost ($/mo) | Data Processing Rate ($/GB) | Max Throughput Limit |
| :--- | :--- | :--- | :--- | :--- |
| **Basic** | $0.395 / hr | $288.35 / mo | $0.065 / GB | 250 Mbps |
| **Standard** | $1.250 / hr | $912.50 / mo | $0.016 / GB | 30 Gbps |
| **Premium** | $1.750 / hr | $1,277.50 / mo | $0.016 / GB | 30 Gbps + TLS/IDPS |

### 2.2 Cost Equations

Let $V$ be the total monthly volume of data processed through the firewall in Gigabytes ($\text{GB}$):

$$\text{Cost}_{\text{Basic}}(V) = 288.35 + 0.065 \times V$$

$$\text{Cost}_{\text{Standard}}(V) = 912.50 + 0.016 \times V$$

$$\text{Cost}_{\text{Premium}}(V) = 1277.50 + 0.016 \times V$$

### 2.3 Crossover Point ($V_{\text{crossover}}$)

The volume where Azure Firewall Basic costs exactly equal Azure Firewall Standard:

$$\text{Cost}_{\text{Basic}}(V_{\text{crossover}}) = \text{Cost}_{\text{Standard}}(V_{\text{crossover}})$$

$$288.35 + 0.065 \times V_{\text{crossover}} = 912.50 + 0.016 \times V_{\text{crossover}}$$

$$(0.065 - 0.016) \times V_{\text{crossover}} = 912.50 - 288.35$$

$$0.049 \times V_{\text{crossover}} = 624.15$$

$$V_{\text{crossover}} = \frac{624.15}{0.049} \approx 12,737.76 \text{ GB} \approx 12.74 \text{ TB/month}$$

> [!NOTE]
> **Sub-environment Crossover Analysis (Part-Time / Deallocated Firewall):**
> If the non-production firewall is deallocated outside business hours (e.g. running 10 hours/day on weekdays = ~220 hours/month):
> - Fixed Basic: $220 \times 0.395 = \$86.90$
> - Fixed Standard: $220 \times 1.250 = \$275.00$
> - Fixed Delta: $\$188.10$
> - Part-Time Crossover: $188.10 / 0.049 \approx \mathbf{3,838.78 \text{ GB (3.84 TB/month)}}$.

---

## 3. Comparison Matrix Across Monthly Data Volumes

| Monthly Volume ($V$) | Basic Total Cost | Standard Total Cost | Premium Total Cost | Recommendation |
| :--- | :--- | :--- | :--- | :--- |
| **500 GB** | $320.85 | $920.50 | $1,285.50 | **Basic** (Dev / Micro-spoke) |
| **2,000 GB (2 TB)** | $418.35 | $944.50 | $1,309.50 | **Basic** (Moderate dev hub) |
| **5,000 GB (5 TB)** | $613.35 | $992.50 | $1,357.50 | **Basic** (approaching limits) |
| **10,000 GB (10 TB)** | $938.35 | $1,072.50 | $1,437.50 | **Standard** (Near parity + 30 Gbps) |
| **12,738 GB (~12.7 TB)** | **$1,116.32** | **$1,116.32** | **$1,481.32** | **EXACT CROSSOVER POINT** |
| **20,000 GB (20 TB)** | $1,588.35 | $1,232.50 | $1,597.50 | **Standard** (Saves $355.85/mo) |
| **50,000 GB (50 TB)** | $3,538.35 | $1,712.50 | $2,077.50 | **Standard** (Saves $1,825.85/mo) |
| **100,000 GB (100 TB)**| $6,788.35 | $2,512.50 | $2,877.50 | **Standard** (Saves $4,275.85/mo) |

---

## 4. Bandwidth Bottleneck Penalty

Beyond financial calculations, Azure Firewall Basic imposes a hard structural limit of **250 Mbps** total throughput.
If backup traffic, database replica re-synchronization, or large patch deployments route through a Basic firewall:
- Throughput bottlenecks degrade application latency.
- Processing costs on Basic climb rapidly toward the crossover point.

**Recommendation**:
- Use **Basic** strictly in isolated dev/test spoke VNets with low throughput (<250 Mbps) and <3 TB monthly traffic.
- Use **Standard** in the primary corporate Hub VNet for enterprise workloads.
- Use **Automation runbooks** to stop non-prod Firewalls on weeknights and weekends, saving **$637/month per firewall** on fixed fees.
