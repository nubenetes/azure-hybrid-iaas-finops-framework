# 📜 Architecture Decision Records (ADRs)

> 🧭 **Navigation**: [🏠 Framework Root](../../README.md) | [📚 Documentation Index](../README.md)

This directory maintains immutable records of key architectural and financial trade-offs decided for the Azure Hybrid IaaS FinOps Framework.

## Index of Architecture Decision Records

| ADR ID | Title | Status | Decided | Financial & Operational Impact |
| :---: | :--- | :---: | :---: | :--- |
| **[ADR-001](ADR-001-constrained-vcpu-for-sql-workloads.md)** | **Constrained vCPU for SQL Workloads** | `Accepted` | 2026-03 | Standardizes on `Standard_E32-8s_v5` to achieve 75% SQL license cost reduction while keeping 256 GiB RAM. |
| **[ADR-002](ADR-002-premium-ssd-v2-decoupled-storage.md)** | **Premium SSD v2 Decoupled Storage** | `Accepted` | 2026-03 | Eliminates RAID 0 Storage Spaces; decouples capacity from IOPS/throughput for >73% storage savings. |
| **[ADR-003](ADR-003-expressroute-metered-vs-unlimited.md)** | **ExpressRoute Metered vs. Unlimited Plan** | `Accepted` | 2026-03 | Enforces Metered plan by default due to break-even threshold (240.6 TB/mo) and asymmetric downgrade trap. |
| **[ADR-004](ADR-004-service-endpoints-vs-private-endpoints.md)**| **Service Endpoints vs. Private Endpoints** | `Accepted` | 2026-03 | Uses 100% free Service Endpoints for internal VNet-to-PaaS traffic, reserving Private Endpoints for hybrid on-prem. |
| **[ADR-005](ADR-005-ama-dcr-edge-log-filtering.md)** | **AMA with DCR Edge XPath Log Filtering** | `Accepted` | 2026-03 | Replaces legacy MMA with AMA + DCRs; drops HTTP 200/300 logs at kernel level; saves >75% on ingestion. |

---

## 🧭 Navigation

- ⬅️ Return to **[Documentation Portal](../README.md)**
- 🏠 Return to **[Framework Root](../../README.md)**
