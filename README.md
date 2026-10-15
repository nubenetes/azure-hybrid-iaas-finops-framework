# Azure Hybrid IaaS FinOps Framework & Architecture Blueprint

[![CI - Lint, Test & Validate FinOps Suite](https://github.com/nubenetes/azure-hybrid-iaas-finops-framework/actions/workflows/ci-lint-validate.yml/badge.svg)](https://github.com/nubenetes/azure-hybrid-iaas-finops-framework/actions/workflows/ci-lint-validate.yml)
[![Framework: FinOps Foundation & CAF](https://img.shields.io/badge/Framework-FinOps_Foundation_%26_Azure_CAF-0078D4?logo=microsoftazure)](https://www.finops.org/)
[![Terraform >= 1.5](https://img.shields.io/badge/Terraform->=1.5_(AzureRM_v4)-844FBA?logo=terraform)](https://www.terraform.io/)
[![Bicep v0.48+](https://img.shields.io/badge/Bicep-IaC_Nativo-0078D4?logo=microsoftazure)](https://learn.microsoft.com/azure/azure-resource-manager/bicep/)
[![Python 3.10+](https://img.shields.io/badge/Python-3.10%2B_(CLI_Calculator)-3776AB?logo=python)](automation/python/)
[![PowerShell 7+](https://img.shields.io/badge/PowerShell-Runbooks_(Az)-5391FE?logo=powershell)](automation/powershell/)
[![Docs: Español](https://img.shields.io/badge/Documento_Original-Espa%C3%B1ol-yellow.svg)](docs/informe-exhaustivo-finops-azure-iaas-es.md)
[![Docs: English](https://img.shields.io/badge/Full_Report-English-blue.svg)](docs/comprehensive-finops-azure-iaas-report-en.md)
[![Licencia: Apache 2.0](https://img.shields.io/badge/Licencia-Apache_2.0-blue.svg)](LICENSE)

An enterprise-grade **FinOps architectural framework, decision engine, and Infrastructure-as-Code (IaC) blueprint** for optimizing hybrid Microsoft Azure IaaS environments (Windows Server, SQL Server on VMs, Hub-and-Spoke networking, ExpressRoute, and Azure Monitor).

It implements, validates, and deepens the research from the technical monograph *"Informe Exhaustivo de Prácticas FinOps y Optimización de Costes para Arquitecturas Azure IaaS Híbridas"*, providing mathematical break-even models, dual-engine IaC (Terraform AzureRM v4 and native Bicep), automated Azure Policy guardrails, Azure Resource Graph (ARG) audit queries, Day-2 PowerShell runbooks, and an interactive FinOps calculator CLI.

> 📖 **Full Unabridged Monograph in Markdown**:
> - 🇪🇸 **[Texto Íntegro en Español](docs/informe-exhaustivo-finops-azure-iaas-es.md)**
> - 🇬🇧 **[Full English Translation](docs/comprehensive-finops-azure-iaas-report-en.md)**

---

## 📑 Table of Contents

- [1. 🏛️ Global Hybrid Architecture](#1-️-global-hybrid-architecture)
- [2. 💡 Financial Impact: Baseline vs. FinOps Optimized (USD $ & EUR €)](#2--financial-impact-baseline-vs-finops-optimized-usd---eur-)
- [3. 📚 Documentation Suite & Technical Guides (docs/)](#3--documentation-suite--technical-guides-docs)
- [4. 🧱 Core Architectural Pillars](#4--core-architectural-pillars)
  - [4.1. Visibility, Tagging & Coercive Governance](#41-visibility-tagging--coercive-governance)
  - [4.2. 3D Compute Optimization: Rightsizing, Lifecycle & Spot](#42-3d-compute-optimization-rightsizing-lifecycle--spot)
  - [4.3. Advanced Microsoft Licensing: AHB & Constrained vCPUs (CCC)](#43-advanced-microsoft-licensing-ahb--constrained-vcpus-ccc)
  - [4.4. Long-Term Financial Engineering: Commitment Portfolio](#44-long-term-financial-engineering-commitment-portfolio)
  - [4.5. Decoupled Storage Subsystem: Premium SSD v2](#45-decoupled-storage-subsystem-premium-ssd-v2)
  - [4.6. Hybrid Network Economics: ExpressRoute, Firewall & Endpoints](#46-hybrid-network-economics-expressroute-firewall--endpoints)
  - [4.7. Observability Cost Containment: AMA, DCR & Basic Table Plans](#47-observability-cost-containment-ama-dcr--basic-table-plans)
- [5. 📐 Mathematical Break-Even Models](#5--mathematical-break-even-models)
- [6. 📜 Architecture Decision Records (ADRs)](#6--architecture-decision-records-adrs)
- [7. 🔍 Azure Resource Graph (KQL) Audit Suite](#7--azure-resource-graph-kql-audit-suite)
- [8. 🧮 FinOps Interactive Calculator CLI (Dual-Currency & Regions)](#8--finops-interactive-calculator-cli-dual-currency--regions)
- [9. ⚙️ Day-2 Automation Runbooks](#9-️-day-2-automation-runbooks)
- [10. 🚀 Infrastructure as Code Quick Start](#10--infrastructure-as-code-quick-start)
  - [10.1. Terraform / OpenTofu (AzureRM v4)](#101-terraform--opentofu-azurerm-v4)
  - [10.2. Azure Bicep](#102-azure-bicep)
- [11. 📂 Repository Structure](#11--repository-structure)
- [12. 🎥 Video Guides, Technical Shorts & Multimedia Sessions (YouTube)](#12--video-guides-technical-shorts--multimedia-sessions-youtube)
- [13. 🌐 High Added-Value Knowledge Base & Curated Internet References](#13--high-added-value-knowledge-base--curated-internet-references)
  - [13.1. Microsoft Learn Official Architecture & Sizing Standards](#131-microsoft-learn-official-architecture--sizing-standards)
  - [13.2. FinOps Foundation Framework & Working Group Publications](#132-finops-foundation-framework--working-group-publications)
  - [13.3. Mathematical & Pricing Break-Even Analyses](#133-mathematical--pricing-break-even-analyses)
  - [13.4. Real-World Community Investigations, Reddit & Microsoft Q&A Deep Dives](#134-real-world-community-investigations-reddit--microsoft-qa-deep-dives)
  - [13.5. Complete 61-Item Concordance Table](#135-complete-61-item-concordance-table)
  - [13.6. Modern 2026 FinOps Tooling & Automation Repositories](#136-modern-2026-finops-tooling--automation-repositories-github)
- [14. 📜 License](#14--license)

---

## 1. 🏛️ Global Hybrid Architecture

```mermaid
flowchart TD
    subgraph OnPrem["🏢 On-Premises Corporate Data Center"]
        LocalAD["Active Directory Domain Services"]
        LocalClients["Enterprise Users / RDP Management"]
        LocalApp["Legacy On-Prem ERP Integrations"]
    end

    subgraph Hub["🛡️ Central Hub VNet (Shared Security & Core)"]
        ERGW["ExpressRoute Gateway<br/>(Metered Plan: $436/mo / €401/mo)"]
        FW["Azure Firewall (Standard or Basic)<br/>(Crossover Point: 12.74 TB/mo)"]
        ADReplicas["AD DS Domain Controllers<br/>(3-Year Reserved Instances - 72% off)"]
        CostAlloc["Cost Allocation Engine<br/>(Proportional Chargeback to Spokes)"]
    end

    subgraph SpokeWeb["🌐 Spoke Web Tier (.NET / IIS)"]
        VMSS["VMSS IIS Application Cluster<br/>Base Layer: 2 On-Demand (AHB)<br/>Surge Layer: Spot Instances (90% off)"]
        SvcEndP1["Service Endpoints (100% Free)<br/>Storage & Key Vault"]
    end

    subgraph SpokeDB["💾 Spoke Database Tier (SQL Server AlwaysOn)"]
        SQLVM["SQL Server on IaaS VM<br/>SKU: Standard_E32-8s_v5 (Constrained vCPU)<br/>256 GiB RAM | 80k IOPS | 8 Cores Licensed<br/>(75% License Cost Reduction)"]
        SSDV2["Premium SSD v2 Data Disks<br/>Decoupled Capacity (512 GiB)<br/>Independent IOPS (13.5k) & MB/s (250)<br/>Zero Storage Spaces / RAID 0 Overhead"]
    end

    subgraph Observability["📊 FinOps Observability & Governance"]
        AMA["Azure Monitor Agent (AMA)<br/>DCR XPath Filtering (Drop HTTP 200/300)"]
        BasicTable["Log Analytics Workspace<br/>Basic Table Plan (€0.46/GB vs €2.12/GB)<br/>(>80% Log Ingestion Reduction)"]
        PolicyEnforce["Azure Policy Engine<br/>Deny Untagged | Enforce AHB | Restrict Dev SKUs"]
    end

    OnPrem <-->|ExpressRoute Private Peering| ERGW
    ERGW --> FW
    FW --> SpokeWeb
    FW --> SpokeDB
    SpokeWeb --> SpokeDB
    SpokeWeb --> SvcEndP1
    SpokeWeb --> AMA
    SpokeDB --> AMA
    AMA --> BasicTable
    PolicyEnforce -.-> Hub
    PolicyEnforce -.-> SpokeWeb
    PolicyEnforce -.-> SpokeDB
```

---

## 2. 💡 Financial Impact: Baseline vs. FinOps Optimized (USD $ & EUR €)

The table below illustrates a representative enterprise deployment (Hub-Spoke, 10 SQL Server database nodes, 30 IIS web server instances, ExpressRoute 1 Gbps, and centralized telemetry) modeled for European and US Zone 1 regions (**Spain Central / Madrid** and **West Europe / Netherlands** alongside **East US**):

> 💶 **Dual Currency Modeling**: All financial estimates are presented in both **USD ($)** and **EUR (€)** using the reference conversion rate ($1.00 \text{ USD} \approx €0.92 \text{ EUR} / €1.00 \text{ EUR} \approx $1.087 \text{ USD}$).

| Architecture Layer | Unoptimized Lift-and-Shift | FinOps Framework Optimized | Monthly Savings | Annual Savings |
| :--- | :--- | :--- | :--- | :--- |
| **SQL Server Licensing** | Unconstrained `E32s_v5` (32 cores) PAYG = **$128,105 / €117,857 / mo** | Constrained `E32-8s_v5` (8 cores) + AHB = **$0 (SA) or $32,026 / €29,464 / mo** | **-$96,079 / -€88,393 / mo** | **$1,152,948 / €1,060,712 / yr** |
| **Windows Server OS** | Default PAYG licensing (~36% surcharge) = **$14,280 / €13,138 / mo** | Azure Hybrid Benefit (AHB) enabled across all VMs = **$0 / €0 / mo** | **-$14,280 / -€13,138 / mo** | **$171,360 / €157,651 / yr** |
| **Database Storage** | Striped P40 disks on Premium v1 (40 TB) = **$5,530 / €5,088 / mo** | Decoupled Premium SSD v2 (5 TB + 13.5k IOPS) = **$1,365 / €1,256 / mo** | **-$4,165 / -€3,832 / mo** | **$49,980 / €45,982 / yr** |
| **ExpressRoute Circuit** | 1 Gbps Unlimited Plan ($6,450 port flat) = **$6,450 / €5,934 / mo** | 1 Gbps Metered Plan ($436 port + 8 TB egress) = **$636 / €585 / mo** | **-$5,814 / -€5,349 / mo** | **$69,768 / €64,187 / yr** |
| **Web Tier Compute** | Static 24/7 D-series PAYG VMs = **$9,850 / €9,062 / mo** | VMSS Priority Mix (2 On-Demand Base + Spot Burst) = **$3,450 / €3,174 / mo** | **-$6,400 / -€5,888 / mo** | **$76,800 / €70,656 / yr** |
| **Telemetry & Logs** | Full unfiltered IIS W3C & Security logs = **$7,600 / €6,992 / mo** | AMA + DCR XPath Edge filter + Basic Table Plan = **$1,520 / €1,398 / mo** | **-$6,080 / -€5,594 / mo** | **$72,960 / €67,123 / yr** |
| **PaaS Endpoint Traffic** | Private Endpoints on all internal subnets = **$1,250 / €1,150 / mo** | VNet Service Endpoints (100% Free) = **$0 / €0 / mo** | **-$1,250 / -€1,150 / mo** | **$15,000 / €13,800 / yr** |
| **TOTAL TCO** | **$173,065 / €159,220 / month** | **$39,077 / €35,951 / month** | **-$133,988 / -€123,269 / mo** | **$1,607,856 / €1,479,228 / yr** |

> 💰 **Bottom Line Impact**: Implementing this framework generates a **77.4% sustained reduction in monthly cloud expenditure**, eliminating over **$1.6 Million USD (~€1.48 Million EUR) annually** in infrastructure waste.

---

## 3. 📚 Documentation Suite & Technical Guides (`docs/`)

> 🧭 **Interactive Documentation Portal**: For role-based reading paths (Executive, FinOps Analyst, DevOps/SRE, DBA) and complete navigation, explore **[`docs/README.md`](docs/README.md)**.

| Document | Language / Topic | Summary |
| :--- | :--- | :--- |
| **[📚 Documentation Portal](docs/README.md)** | Index & Navigation | Complete portal with role-based reading paths, directory index, and quick resource maps. |
| **[Original Monograph (ES)](docs/informe-exhaustivo-finops-azure-iaas-es.md)** | Español (Texto Íntegro) | Transcripción completa y fidedigna del informe técnico original en Markdown. |
| **[Original Monograph (EN)](docs/comprehensive-finops-azure-iaas-report-en.md)** | English (Full Unabridged) | Complete, unabridged English translation of the technical monograph. |
| **[01. Governance & Tagging](docs/01-governance-tagging-cost-allocation.md)** | Governance & Chargeback | Coercive tagging taxonomy, Azure Policy rules, Hub cost allocation, and daily Parquet exports. |
| **[02. Compute Rightsizing](docs/02-compute-rightsizing-lifecycle-spot.md)** | Compute & Lifecycle | 30-day P95/P99 rightsizing, Burstable series, guest OS shutdown trap, and VMSS Spot Priority Mix. |
| **[03. Advanced Licensing](docs/03-licensing-ahb-constrained-vcpu.md)** | Licensing & Constrained vCPUs | Azure Hybrid Benefit (AHB), 180-day Dual-Use Rights, and Constrained vCPUs (`E32-8s_v5`) to save 75% on SQL. |
| **[04. Commitment Engineering](docs/04-commitment-portfolio-ri-savings-plans.md)** | RIs & Savings Plans | The "Floor & Ceiling" commitment model: 3-Year RIs for immutable base + Savings Plans for elastic tiers. |
| **[05. Decoupled Storage](docs/05-storage-optimization-premium-ssdv2.md)** | Premium SSD v2 | Eliminating RAID 0 striping; independent Capacity, IOPS, and MB/s sliders; zero-downtime scaling. |
| **[06. Hybrid Networking](docs/06-hybrid-network-expressroute-firewall-endpoints.md)** | ExpressRoute & Firewall | Asymmetric egress, ExpressRoute break-even formulas, Firewall crossover, and Service Endpoints. |
| **[07. Observability Containment](docs/07-observability-ama-dcr-log-analytics.md)** | AMA, DCR & Log Analytics | Edge XPath filtering (drop HTTP 200s, filter Event IDs), and Basic Table Plan (>80% savings). |
| **[08. Anti-Patterns & Gotchas](docs/08-anti-patterns-and-gotchas.md)** | Troubleshooting & Traps | Catalog of the Top 15 architectural mistakes, licensing traps, and hidden cost leaks in Azure IaaS. |
| **[09. FinOps Tooling Ecosystem (2026)](docs/09-finops-tooling-ecosystem-2026.md)** | Tooling & Open-Source | Modern 2026 ecosystem: FinOps Toolkit, AZQR, Azure Cost CLI, aztree, AOE, AzGovViz, Infracost, Steampipe. |
| **[10. Audit & Optimization Playbook](docs/10-audit-optimization-playbook-step-by-step.md)** | Step-by-Step Playbook | Automated discovery, waste remediation, shift-left PR gates, live SQL auditing, and Eisenhower matrix. |
| **[11. Enterprise Roadmap & Calendar](docs/11-enterprise-roadmap-calendar-milestones.md)** | 24-Week Implementation Plan | 5-phase execution plan, Day-0 to Day-180 milestones, enterprise RACI matrix, and ROI velocity curve. |
| **[12. Legacy Architecture Governance & Results](docs/12-legacy-architecture-governance-results.md)** | Legacy Systems & Results | Non-invasive optimization for legacy IaaS, waiver workflows, before/after results (-77.4%), and unit economics. |
| **[13. Advanced FinOps Mastery Guide](docs/13-advanced-finops-mastery-guide.md)** | Strategic Cost Blueprint | The FinOps Iron Triangle, priority tiers, dependency graphs, 6 deadly sins, and 2026 solutions. |
| **[📜 Architecture Decision Records](docs/adr/README.md)** | ADRs (ADR-001 to ADR-005) | Formal records for SQL CCC, Premium SSD v2, ExpressRoute, Service Endpoints, and AMA DCR. |
| **[📐 Mathematical Models](docs/math-models/README.md)** | Economic Proofs (USD $ & EUR €)| Break-even formulas for ExpressRoute, Azure Firewall crossover, and SQL Server CCC core licensing. |

---

## 4. 🧱 Core Architectural Pillars

### 4.1. Visibility, Tagging & Coercive Governance
- **Comprehensive Taxonomy**: Mandatory organizational dimensions (`CostCenter`, `Environment`, `Owner`, `Workload`, `SharedService`).
- **Coercive Azure Policy**: Deployments lacking required financial context are rejected at ARM compilation ([`enforce-mandatory-tags.json`](policies/enforce-mandatory-tags.json)). Child resources automatically inherit tags from parent resource groups ([`inherit-tags-from-rg.json`](policies/inherit-tags-from-rg.json)).
- **Hub-Spoke Cost Allocation**: Implements Azure Cost Allocation Rules to distribute central firewall and gateway costs proportionally to consuming spokes based on empirical network and compute metrics.
- 📖 *Full Technical Guide*: [`docs/01-governance-tagging-cost-allocation.md`](docs/01-governance-tagging-cost-allocation.md)

### 4.2. 3D Compute Optimization: Rightsizing, Lifecycle & Spot
- **Empirical Rightsizing**: 30-day continuous telemetry focusing on P95 and P99 percentiles instead of averages.
- **VM Series Specialization**: B-series burstable for Dev/Test (minimum B2s for Windows Server); F/D-series for stateless .NET IIS; E-series and `Ebdsv5` NVMe for SQL Server.
- **The Deallocation Trap**: Eliminates the common mistake of shutting down VMs from the guest OS (`Stopped` state continues charging CPU/RAM at 100%). Enforces `Stopped (deallocated)` via Azure APIs ($0.00/hr compute).
- **VMSS Priority Mix**: Configures scale sets with a reliable on-demand floor and elastic Spot instances for up to 90% discount on web scaling tiers.
- 📖 *Full Technical Guide*: [`docs/02-compute-rightsizing-lifecycle-spot.md`](docs/02-compute-rightsizing-lifecycle-spot.md)

### 4.3. Advanced Microsoft Licensing: AHB & Constrained vCPUs (CCC)
- **Azure Hybrid Benefit (AHB)**: Amortizes existing Software Assurance investments to eliminate the Windows Server OS fee (~36% savings) and SQL Server engine fee (up to 85% combined savings).
- **180-Day Dual-Use Rights**: Enables parallel testing and live migration of on-premises licenses to Azure for 6 months with zero audit penalties.
- **SQL Server Developer Edition**: 100% feature parity with Enterprise at zero licensing cost in non-prod.
- **Constrained vCPUs (CCC)**: Deploys `Standard_E32-8s_v5` to satisfy 256 GiB RAM and 80,000 IOPS while masking 24 cores from the OS. SQL Server invoices only 8 cores, yielding an immediate 75% license reduction.
- 📖 *Full Technical Guide*: [`docs/03-licensing-ahb-constrained-vcpu.md`](docs/03-licensing-ahb-constrained-vcpu.md)

### 4.4. Long-Term Financial Engineering: Commitment Portfolio
- **The "Floor & Ceiling" Model**: Combines rigid 3-Year Reserved Instances (RIs) for 60-70% immutable baseline infrastructure with flexible Compute Savings Plans for elastic tiers, avoiding commitment lock-in while capturing up to 72% discounts.
- 📖 *Full Technical Guide*: [`docs/04-commitment-portfolio-ri-savings-plans.md`](docs/04-commitment-portfolio-ri-savings-plans.md)

### 4.5. Decoupled Storage Subsystem: Premium SSD v2
- **Abolishing the RAID 0 Anti-Pattern**: Replaces Windows Storage Spaces striped P30/P40 disks with single decoupled Premium SSD v2 disks.
- **Independent Sliders**: Adjust Capacity (GiB), IOPS, and Throughput (MB/s) independently. Every disk includes 3,000 IOPS and 125 MB/s free of charge.
- **Zero-Downtime Tuning**: Dynamic performance scaling up to 4 times per 24-hour period allows boosting IOPS before nightly backup windows and dialing down afterwards.
- 📖 *Full Technical Guide*: [`docs/05-storage-optimization-premium-ssdv2.md`](docs/05-storage-optimization-premium-ssdv2.md)

### 4.6. Hybrid Network Economics: ExpressRoute, Firewall & Endpoints
- **ExpressRoute Break-Even**: Proves mathematically that the Unlimited plan requires sustained >73% line saturation 24/7. Hybrid enterprises transferring <240 TB/mo save $5,800/mo (~€5,336/mo) by deploying Metered.
- **The Asymmetric Transition Trap**: Upgrading Metered to Unlimited is zero-downtime; downgrading Unlimited to Metered is blocked by Microsoft and requires circuit destruction. Always start Metered.
- **Azure Firewall Crossover**: Evaluates the 12.74 TB/month crossover between Basic ($0.065/GB processing) and Standard ($0.016/GB processing).
- **Service Endpoints vs. Private Endpoints**: Defaults to 100% free Service Endpoints for internal VNet-to-PaaS traffic, reserving Private Endpoints strictly for on-premises hybrid access.
- 📖 *Full Technical Guide*: [`docs/06-hybrid-network-expressroute-firewall-endpoints.md`](docs/06-hybrid-network-expressroute-firewall-endpoints.md)

### 4.7. Observability Cost Containment: AMA, DCR & Basic Table Plans
- **Edge XPath Filtering**: Azure Monitor Agent evaluates XPath filters inside the Windows kernel, discarding HTTP 200-399 and non-critical Event IDs before data crosses the network.
- **Log Analytics Basic Table Plan**: Reduces ingestion cost from ~$2.30/GB (~€2.12/GB) down to ~$0.50/GB (~€0.46/GB) (>78% savings) for high-volume network and firewall diagnostic logs.
- 📖 *Full Technical Guide*: [`docs/07-observability-ama-dcr-log-analytics.md`](docs/07-observability-ama-dcr-log-analytics.md)

---

## 5. 📐 Mathematical Break-Even Models

| Model | Core Formula | Key Finding / Threshold (Dual Currency) | Documentation |
| :--- | :--- | :--- | :--- |
| **ExpressRoute Break-Even** | $E_{\text{break-even}} = \frac{P_{\text{unlimited}} - P_{\text{metered}}}{C_{\text{egress}}}$ | 1 Gbps circuit break-even = **240.6 TB/month (73.2% 24/7 saturation)**. Unlimited ($6,450 / €5,934) vs Metered ($436 / €401). | [`docs/math-models/expressroute-breakeven.md`](docs/math-models/expressroute-breakeven.md) |
| **Firewall SKU Crossover** | $V_{\text{crossover}} = \frac{\Delta \text{Fixed}}{\Delta \text{Processing Rate}}$ | Basic vs. Standard crossover = **12.74 TB/month** ($0.065 / €0.060 per GB vs $0.016 / €0.0147 per GB). | [`docs/math-models/firewall-sku-crossover.md`](docs/math-models/firewall-sku-crossover.md) |
| **SQL Server Constrained Cores**| $R_{\text{savings}} = \left(1 - \frac{N_{\text{active}}}{N_{\text{phys}}}\right) \times 100\%$ | `E32-8s_v5` yields **75% software licensing reduction** with full 256 GiB RAM. Saves $9,607 / €8,839 monthly. | [`docs/math-models/sql-licensing-ccc-matrix.md`](docs/math-models/sql-licensing-ccc-matrix.md) |

---

## 6. 📜 Architecture Decision Records (ADRs)

Key architectural trade-offs are documented as immutable Architecture Decision Records:
- **[ADR-001: Constrained vCPU for SQL Workloads](docs/adr/ADR-001-constrained-vcpu-for-sql-workloads.md)**: Adoption of Constrained vCPU VM Sizes for SQL Server IaaS Workloads.
- **[ADR-002: Premium SSD v2 Decoupled Storage](docs/adr/ADR-002-premium-ssd-v2-decoupled-storage.md)**: Migration from Premium SSD v1 to Premium SSD v2 for Transactional Storage.
- **[ADR-003: ExpressRoute Metered vs. Unlimited](docs/adr/ADR-003-expressroute-metered-vs-unlimited.md)**: Default Selection of Metered Data Plan for Hybrid Azure ExpressRoute Circuits.
- **[ADR-004: Service Endpoints vs. Private Endpoints](docs/adr/ADR-004-service-endpoints-vs-private-endpoints.md)**: Standardizing on Service Endpoints vs. Private Endpoints for PaaS Traffic.
- **[ADR-005: AMA DCR Edge Log Filtering](docs/adr/ADR-005-ama-dcr-edge-log-filtering.md)**: Adoption of Azure Monitor Agent (AMA) with DCR Edge XPath Filtering.

---

## 7. 🔍 Azure Resource Graph (KQL) Audit Suite

A complete suite of KQL queries designed to run in Azure Resource Graph Explorer to detect cost leaks and licensing optimization candidates:

| Audit Target | KQL Query File | Detected Financial Leak |
| :--- | :--- | :--- |
| **Stopped (Non-Deallocated) VMs** | [`find-stopped-not-deallocated-vms.kql`](kql-queries/find-stopped-not-deallocated-vms.kql) | VMs stopped from guest OS still charging 100% CPU/RAM |
| **Orphaned Managed Disks** | [`find-orphaned-managed-disks.kql`](kql-queries/find-orphaned-managed-disks.kql) | Unattached OS/Data disks billing storage capacity |
| **Unassociated Public IPs** | [`find-unassociated-public-ips.kql`](kql-queries/find-unassociated-public-ips.kql) | Static public IPs incurring hourly idle reservation fees |
| **Missing Azure Hybrid Benefit** | [`find-vms-missing-hybrid-benefit.kql`](kql-queries/find-vms-missing-hybrid-benefit.kql) | Windows and SQL VMs paying full PAYG licensing rates |
| **SQL VMs for Constrained vCPUs**| [`find-sql-vms-eligible-for-constrained-vcpu.kql`](kql-queries/find-sql-vms-eligible-for-constrained-vcpu.kql) | High-core SQL VMs eligible for 50-75% licensing reduction |
| **Oversized Premium v1 Disks** | [`audit-premium-ssd-v1-to-v2-candidates.kql`](kql-queries/audit-premium-ssd-v1-to-v2-candidates.kql) | Oversized P30/P40 disks eligible for Premium SSD v2 migration |
| **Log Analytics Ingestion Spikes** | [`audit-log-analytics-ingestion-spikes.kql`](kql-queries/audit-log-analytics-ingestion-spikes.kql) | Tables generating excessive ingestion fees in workspace |

---

## 8. 🧮 FinOps Interactive Calculator CLI (Dual-Currency & Regions)

A standalone Python command-line utility providing instant mathematical evaluations and TCO modeling supporting **Spain Central (Madrid)**, **West Europe (Netherlands)**, and **East US** in both **USD ($)** and **EUR (€)**:

```bash
# Compare ExpressRoute Metered vs. Unlimited in Spain Central (Madrid) with dual currency:
python3 automation/python/finops_calculator.py expressroute --bandwidth 1000 --monthly-egress-gb 5000 --region spaincentral

# Output:
# =========================================================================
#  AZURE FINOPS ENGINE: EXPRESSROUTE | Spain Central (Madrid)
#  Currency Rate: 1 USD = 0.92 EUR
# =========================================================================
#  Region                          : Spain Central (Madrid)
#  Bandwidth Mbps                  : 1000
#  Monthly Egress Gb               : 5000.0
#  Egress Rate Usd Per Gb          : 0.025
#  Egress Rate Eur Per Gb          : 0.023
#  Cost Metered Usd                : $561.00
#  Cost Metered Eur                : €516.12
#  Cost Unlimited Usd              : $6,450.00
#  Cost Unlimited Eur              : €5,934.00
#  Breakeven Egress Tb             : 234.92
#  Breakeven Saturation Pct        : 73.23
#  Recommendation                  : Metered
#  Monthly Savings Usd             : $5,889.00
#  Monthly Savings Eur             : €5,417.88
# =========================================================================
```

Other available commands:
- `python3 automation/python/finops_calculator.py firewall --monthly-gb 20000 --region spaincentral`
- `python3 automation/python/finops_calculator.py sql-licensing --physical-cores 32 --active-cores 8 --windows-ahb --ri-years 3 --region spaincentral`
- `python3 automation/python/finops_calculator.py storage --capacity-gb 1024 --iops 12000 --throughput 250 --region spaincentral`

---

## 9. ⚙️ Day-2 Automation Runbooks

Production-grade PowerShell runbooks for Azure Automation or scheduled tasks:
- **[`Start-Stop-Deallocate-VMs.ps1`](automation/powershell/Start-Stop-Deallocate-VMs.ps1)**: Automatically deallocates non-prod and tagged VMs outside business hours.
- **[`Optimize-PremiumSSDv2-IOPS.ps1`](automation/powershell/Optimize-PremiumSSDv2-IOPS.ps1)**: Dynamically scales Premium SSD v2 IOPS and throughput with **zero downtime** before nightly database backups and dials them down before morning traffic.
- **[`Deconstruct-AzureFirewall-NonProd.ps1`](automation/powershell/Deconstruct-AzureFirewall-NonProd.ps1)**: Suspends non-production Azure Firewall instances outside office hours, eliminating the $912/month base fee.

---

## 10. 🚀 Infrastructure as Code Quick Start

### 10.1. Terraform / OpenTofu (AzureRM v4)

```bash
cd terraform

# Initialize providers and modules
terraform init

# Validate configuration
terraform validate

# Review FinOps optimized execution plan for Spain Central or West Europe
terraform plan -var="location=spaincentral" -var="environment=prod"

# Deploy reference architecture
terraform apply -auto-approve
```

### 10.2. Azure Bicep

```bash
cd bicep

# Compile and validate Bicep template
az bicep build --file main.bicep

# Deploy using Azure CLI in Spain Central (Madrid)
az deployment group create \
  --resource-group rg-finops-core-prod \
  --template-file main.bicep \
  --parameters location='spaincentral' @main.bicepparam
```

---

## 11. 📂 Repository Structure

```text
.
├── .github/
│   └── workflows/
│       └── ci-lint-validate.yml          # GitHub Actions CI for Terraform, Bicep, Python & Shell
├── automation/
│   ├── powershell/
│   │   ├── Cleanup-OrphanedDisks.ps1     # Automated unattached disk backup and quarantine deletion
│   │   ├── Deconstruct-AzureFirewall-NonProd.ps1
│   │   ├── Optimize-PremiumSSDv2-IOPS.ps1
│   │   └── Start-Stop-Deallocate-VMs.ps1
│   └── python/
│       ├── finops_calculator.py          # Interactive CLI financial calculator (USD $ & EUR €)
│       ├── requirements.txt
│       └── test_finops_calculator.py     # Unit test suite verifying mathematical models
├── bicep/
│   ├── main.bicep                        # Native Azure Bicep root deployment
│   ├── main.bicepparam
│   └── modules/
│       ├── azurePolicy.bicep
│       ├── dcrRules.bicep
│       ├── hubNetwork.bicep
│       ├── spokeDb.bicep
│       └── spokeWeb.bicep
├── docs/
│   ├── README.md                         # Master Documentation Portal & Role-Based Reading Paths
│   ├── informe-exhaustivo-finops-azure-iaas-es.md   # Texto íntegro original del informe (Español)
│   ├── comprehensive-finops-azure-iaas-report-en.md # Full unabridged technical report (English)
│   ├── 01-governance-tagging-cost-allocation.md
│   ├── 02-compute-rightsizing-lifecycle-spot.md
│   ├── 03-licensing-ahb-constrained-vcpu.md
│   ├── 04-commitment-portfolio-ri-savings-plans.md
│   ├── 05-storage-optimization-premium-ssdv2.md
│   ├── 06-hybrid-network-expressroute-firewall-endpoints.md
│   ├── 07-observability-ama-dcr-log-analytics.md
│   ├── 08-anti-patterns-and-gotchas.md
│   ├── 09-finops-tooling-ecosystem-2026.md          # 2026 Microsoft & Open-Source FinOps tools
│   ├── 10-audit-optimization-playbook-step-by-step.md # Step-by-step audit & remediation playbook
│   ├── 11-enterprise-roadmap-calendar-milestones.md # 24-week implementation calendar & RACI
│   ├── 12-legacy-architecture-governance-results.md # Legacy estate governance & quantitative ROI
│   ├── 13-advanced-finops-mastery-guide.md          # Definitive FinOps blueprint, traps & solutions
│   ├── adr/                              # Architecture Decision Records (ADR-001 to ADR-005)
│   │   ├── ADR-001-constrained-vcpu-for-sql-workloads.md
│   │   ├── ADR-002-premium-ssd-v2-decoupled-storage.md
│   │   ├── ADR-003-expressroute-metered-vs-unlimited.md
│   │   ├── ADR-004-service-endpoints-vs-private-endpoints.md
│   │   └── ADR-005-ama-dcr-edge-log-filtering.md
│   └── math-models/                      # Mathematical Break-Even Formulations (USD & EUR)
│       ├── expressroute-breakeven.md
│       ├── firewall-sku-crossover.md
│       └── sql-licensing-ccc-matrix.md
├── kql-queries/                          # Azure Resource Graph (ARG) FinOps Audit Suite
│   ├── audit-log-analytics-ingestion-spikes.kql
│   ├── audit-premium-ssd-v1-to-v2-candidates.kql
│   ├── find-orphaned-managed-disks.kql
│   ├── find-sql-vms-eligible-for-constrained-vcpu.kql
│   ├── find-stopped-not-deallocated-vms.kql
│   ├── find-unassociated-public-ips.kql
│   └── find-vms-missing-hybrid-benefit.kql
├── policies/                             # Azure Policy Definitions (JSON)
│   ├── enforce-azure-hybrid-benefit.json
│   ├── enforce-mandatory-tags.json
│   ├── enforce-premium-ssd-v2-production.json
│   ├── inherit-tags-from-rg.json
│   └── restrict-vm-skus-dev.json
├── scripts/
│   └── validate-all.sh                   # Comprehensive local pre-commit validation harness
├── terraform/
│   ├── main.tf                           # Root Terraform orchestrator
│   ├── outputs.tf
│   ├── terraform.tfvars.example
│   ├── variables.tf
│   ├── versions.tf                       # AzureRM v4 provider configuration
│   └── modules/
│       ├── governance_policy/
│       ├── hub_network/
│       ├── observability_dcr/
│       ├── spoke_db/
│       └── spoke_web/
├── azure-pipelines.yml                   # Azure DevOps Pipeline
├── bitbucket-pipelines.yml               # Bitbucket Pipelines
├── .gitlab-ci.yml                        # GitLab CI Pipeline
├── CONTRIBUTING.md
├── LICENSE                               # Apache 2.0
└── README.md                             # This documentation
```

---

## 12. 🎥 Video Guides, Technical Shorts & Multimedia Sessions (YouTube)

The mathematical models, architectural patterns, and automation engines of this framework are accompanied by a dedicated series of technical video guides, podcasts, and shorts synthesized with **Gemini NotebookLM**.

All episodes and technical shorts are hosted on the official YouTube channel [**@nubenetes**](https://youtube.com/@nubenetes).

> [!NOTE]
> **Multilingual Technical Content 🌐**:
> The architectural masterclasses and podcast feature native **Spanish** narration, while the rapid technical shorts feature native **English** voiceover with automatic subtitles (CC) in over **20 languages** for international engineering teams.

### 📊 Technical Multimedia Catalog (22 Sessions)

#### 🎙️ Architectural Podcast & Long-Form Sessions
| Format | Title / Episode | Focus / Core Engineering Domain | Language | Duration | Direct YouTube Link |
| :---: | :--- | :--- | :---: | :---: | :--- |
| 🎙️ **Podcast** | [**Podcast: Estrategias FinOps en Azure: Ahorro en Cómputo, SQL Server y Redes Híbridas**](https://www.youtube.com/watch?v=Kt2MyQlUXew) | **Comprehensive Masterclass**: Full architecture overview, AHUB, SQL Server CCC, ExpressRoute break-even, and AMA DCR | 🇪🇸 Spanish *(CC 20+)* | `21:24` | [▶️ Watch Podcast](https://www.youtube.com/watch?v=Kt2MyQlUXew) |

#### 📽️ Deep-Dive Video Guides & Masterclasses (The Explainer Series)
| Format | Title / Episode | Focus / Core Engineering Domain | Language | Duration | Direct YouTube Link |
| :---: | :--- | :--- | :---: | :---: | :--- |
| 📽️ **Video Guide** | [**Azure FinOps Framework: Enterprise Hybrid IaaS Architecture Blueprint**](https://www.youtube.com/watch?v=7xUIjosp28w) | **Global Architecture Blueprint**: Hub-Spoke topology, lift-and-shift traps vs. FinOps optimization, and 7-figure savings | 🇬🇧 English *(CC 20+)* | `8:37` | [▶️ Watch Video](https://www.youtube.com/watch?v=7xUIjosp28w) |
| 📽️ **Video Guide** | [**Azure FinOps Hub-and-Spoke: Blueprint de Arquitectura y Reducción del 77% en IaaS**](https://www.youtube.com/watch?v=RIiM9thkq2U) | **Global Architecture Blueprint**: Topología de referencia, desacoplamiento y modelo TCO $173k a $39k/mes | 🇪🇸 Spanish *(CC 20+)* | `7:40` | [▶️ Watch Video](https://www.youtube.com/watch?v=RIiM9thkq2U) |
| 📽️ **Video Guide** | [**Azure FinOps: 3D Compute Engineering, Rightsizing & VM Lifecycle Automation**](https://www.youtube.com/watch?v=jt7t1BPNBsY) | **3D Compute Engineering**: Empirical P95/P99 rightsizing, guest OS shutdown trap, API deallocation, and VMSS Spot | 🇬🇧 English *(CC 20+)* | `7:22` | [▶️ Watch Video](https://www.youtube.com/watch?v=jt7t1BPNBsY) |
| 📽️ **Video Guide** | [**Rightsizing en Azure: Optimización Empírica P95/P99 y Trampa del Apagado en Cómputo**](https://www.youtube.com/watch?v=b4QUPOKc_ng) | **3D Compute Engineering**: Dimensionamiento empírico P95/P99, trampa Stopped vs Deallocated y escalado VMSS | 🇪🇸 Spanish *(CC 20+)* | `7:09` | [▶️ Watch Video](https://www.youtube.com/watch?v=b4QUPOKc_ng) |
| 📽️ **Video Guide** | [**Azure Core Masking: Slash SQL Server Licensing Costs by 75% with FinOps**](https://www.youtube.com/watch?v=vl6LKMgcKnw) | **Database Licensing**: Masking 24 cores on E32-8s_v5 to save $96k/mo (€88k/mo) on SQL Server while retaining 256 GB RAM | 🇬🇧 English *(CC 20+)* | `8:35` | [▶️ Watch Video](https://www.youtube.com/watch?v=vl6LKMgcKnw) |
| 📽️ **Video Guide** | [**Enmascaramiento de Núcleos en Azure: Ahorra un 75% en Licencias de SQL Server**](https://www.youtube.com/watch?v=JSudzAtZr9g) | **Database Licensing**: vCPUs restringidas, fórmula de licencias por núcleo y aprovechamiento de Azure Hybrid Benefit | 🇪🇸 Spanish *(CC 20+)* | `6:11` | [▶️ Watch Video](https://www.youtube.com/watch?v=JSudzAtZr9g) |
| 📽️ **Video Guide** | [**Azure Storage: Decouple Capacity & IOPS with Premium SSD v2 in FinOps**](https://www.youtube.com/watch?v=BZsmqa_FUGk) | **Storage Paradigm Shift**: Decoupled Capacity/IOPS/MBps, eliminating RAID 0 striping, and NVMe on Ebdsv5 series | 🇬🇧 English *(CC 20+)* | `8:43` | [▶️ Watch Video](https://www.youtube.com/watch?v=BZsmqa_FUGk) |
| 📽️ **Video Guide** | [**Almacenamiento FinOps en Azure: Premium SSD v2 y Fin del Desperdicio en Discos**](https://www.youtube.com/watch?v=vxBSeN1c3os) | **Storage Paradigm Shift**: Eliminación de Storage Spaces RAID 0, baseline gratuito de 3.000 IOPS y escalado dinámico | 🇪🇸 Spanish *(CC 20+)* | `6:14` | [▶️ Watch Video](https://www.youtube.com/watch?v=vxBSeN1c3os) |
| 📽️ **Video Guide** | [**Azure Hybrid Network FinOps: ExpressRoute Economics, Firewall Tiers & Endpoints**](https://www.youtube.com/watch?v=p5HPpm3CI0A) | **Hybrid Network Economics**: ExpressRoute 240 TB/mo break-even, asymmetric downgrade trap, and Firewall crossover | 🇬🇧 English *(CC 20+)* | `8:42` | [▶️ Watch Video](https://www.youtube.com/watch?v=p5HPpm3CI0A) |
| 📽️ **Video Guide** | [**Economía de Redes Híbridas en Azure: ExpressRoute, Firewall y Endpoints**](https://www.youtube.com/watch?v=j9HNF-73zDQ) | **Hybrid Network Economics**: ExpressRoute break-even (240 TB/mo), asymmetric downgrade trap, and Firewall crossover | 🇪🇸 Spanish *(CC 20+)* | `7:14` | [▶️ Watch Video](https://www.youtube.com/watch?v=j9HNF-73zDQ) |
| 📽️ **Video Guide** | [**Azure Telemetry & Observability FinOps: AMA Edge Filtering & Log Cost Control**](https://www.youtube.com/watch?v=FBEXO3Mk1h8) | **Observability Containment**: Eradicating runaway ingestion bills, kernel XPath filtering with AMA, and Basic Table Plans | 🇬🇧 English *(CC 20+)* | `7:35` | [▶️ Watch Video](https://www.youtube.com/watch?v=FBEXO3Mk1h8) |
| 📽️ **Video Guide** | [**FinOps en Azure: Control de Costes en Telemetría, Logs y Monitorización**](https://www.youtube.com/watch?v=jXgyXSNmXwM) | **Observability Containment**: Eliminating runaway telemetry, kernel XPath filtering with AMA, and Basic Table Plans | 🇪🇸 Spanish *(CC 20+)* | `5:33` | [▶️ Watch Video](https://www.youtube.com/watch?v=jXgyXSNmXwM) |
| 📽️ **Video Guide** | [**Azure Governance & Policy FinOps: Coercive Guardrails, Tagging & Cost Allocation**](https://www.youtube.com/watch?v=ewLnUSh-fJU) | **Coercive Governance & Automation**: Azure Policy guardrails, ARM deny effects, tag inheritance, and hub cost allocation | 🇬🇧 English *(CC 20+)* | `8:13` | [▶️ Watch Video](https://www.youtube.com/watch?v=ewLnUSh-fJU) |
| 📽️ **Video Guide** | [**FinOps Azure Híbrido: Gobernanza Coercitiva, Políticas y Automatización**](https://www.youtube.com/watch?v=yAm1-z2ZpfA) | **Coercive Governance & Automation**: Azure Policy guardrails, hub cost allocation, ARG KQL audits, and shift-left gates | 🇪🇸 Spanish *(CC 20+)* | `6:42` | [▶️ Watch Video](https://www.youtube.com/watch?v=yAm1-z2ZpfA) |

#### ⚡ Technical Shorts & Quick Takeaways
| Format | Title / Episode | Focus / Core Engineering Domain | Language | Duration | Direct YouTube Link |
| :---: | :--- | :--- | :---: | :---: | :--- |
| ⚡ **Short** | [**How the Azure FinOps Framework Slashes Cloud Bills**](https://www.youtube.com/shorts/ohhFQPy97U8) | **TCO Reduction ($173k to $39k/mo)**: Decoupling physical resources from licensing, storage, and networking | 🇬🇧 English *(CC 20+)* | `1:16` | [▶️ Watch Short](https://www.youtube.com/shorts/ohhFQPy97U8) |
| ⚡ **Short** | [**Turning Azure FinOps Theory into Automated Action**](https://www.youtube.com/shorts/09oqxYUeHd8) | **Continuous Automation Pipeline**: IaC modules, ARG KQL audits, Day-2 PowerShell runbooks, and CLI calculators | 🇬🇧 English *(CC 20+)* | `1:19` | [▶️ Watch Short](https://www.youtube.com/shorts/09oqxYUeHd8) |
| ⚡ **Short** | [**The Azure Cloud VM Shutdown Trap: Stopped vs Deallocated**](https://www.youtube.com/shorts/G49JolO2L2I) | **Lifecycle Management**: Guest OS shutdown trap vs. Azure control-plane deallocation to zero compute fees | 🇬🇧 English *(CC 20+)* | `1:13` | [▶️ Watch Short](https://www.youtube.com/shorts/G49JolO2L2I) |
| ⚡ **Short** | [**How Core Masking Slashes Cloud Database Costs**](https://www.youtube.com/shorts/EZQ6GnAEtpE) | **SQL Server Constrained vCPUs**: Masking 24 cores on E32-8s_v5 to save 75% on licensing while keeping 256 GB RAM | 🇬🇧 English *(CC 20+)* | `1:27` | [▶️ Watch Short](https://www.youtube.com/shorts/EZQ6GnAEtpE) |
| ⚡ **Short** | [**How Azure Premium SSD v2 Decouples Storage**](https://www.youtube.com/shorts/FseN2K1O9PU) | **Storage Subsystem**: Independent IOPS/throughput sliders, eliminating RAID 0 striping and unneeded gigabytes | 🇬🇧 English *(CC 20+)* | `1:08` | [▶️ Watch Short](https://www.youtube.com/shorts/FseN2K1O9PU) |
| ⚡ **Short** | [**How Edge Filtering Slashes Azure Log Costs**](https://www.youtube.com/shorts/qzkXGfuQmT4) | **Observability Containment**: Dropping 90%+ routine logs at the edge with AMA XPath and Basic Table Plans | 🇬🇧 English *(CC 20+)* | `1:30` | [▶️ Watch Short](https://www.youtube.com/shorts/qzkXGfuQmT4) |
| ⚡ **Short** | [**How Cloud Unlimited Plans Trap You**](https://www.youtube.com/shorts/Xd2adpKN6VM) | **ExpressRoute Economics**: 240 TB/mo break-even threshold, asymmetric downgrade trap, and Metered default | 🇬🇧 English *(CC 20+)* | `1:24` | [▶️ Watch Short](https://www.youtube.com/shorts/Xd2adpKN6VM) |

<details>
<summary>📂 <strong>Detailed Agenda, Transcripts & Engineering Takeaways</strong></summary>

<br/>

### Section A: Deep-Dive Video Guides & Masterclasses (14 Sessions)

#### 1. Azure FinOps Framework: Enterprise Hybrid IaaS Architecture Blueprint (8:37)
- 🔗 **Direct URL**: [https://www.youtube.com/watch?v=7xUIjosp28w](https://www.youtube.com/watch?v=7xUIjosp28w)
- ⏱️ **Duration**: 8:37 | 🌐 **Language**: 🇬🇧 English *(CC 20+)*
- 🏷️ **Domain**: Global Hybrid IaaS Architecture Blueprint, Hub-and-Spoke, SQL Licensing, TCO Impact
- 📝 **Technical Overview**:
> Deep dive into the reference architecture blueprint for enterprise Azure hybrid IaaS environments. Explores how standard unoptimized migrations spending $173,000/month are transformed into high-efficiency architectures operating at $39,000/month (over 77% sustained reduction). Demonstrates the strategic value of centralizing shared services, decoupling physical compute from software licensing, implementing metered network circuits, and enforcing automated policy guardrails.

#### 2. Azure FinOps Hub-and-Spoke: Blueprint de Arquitectura y Reducción del 77% en IaaS (7:40)
- 🔗 **Direct URL**: [https://www.youtube.com/watch?v=RIiM9thkq2U](https://www.youtube.com/watch?v=RIiM9thkq2U)
- ⏱️ **Duration**: 7:40 | 🌐 **Language**: 🇪🇸 Spanish *(CC 20+)*
- 🏷️ **Domain**: Blueprint Global de Arquitectura Hub-and-Spoke, Aislamiento de Servicios y Modelo TCO
- 📝 **Technical Overview**:
> Masterclass arquitectónica sobre el diseño e implementación del blueprint de referencia en Azure. Analiza la transformación radical desde arquitecturas sobredimensionadas hacia modelos desacoplados y eficientes, explicando la centralización de seguridad perimetral, la eliminación de redundancias en gateways y la gobernanza continua para blindar presupuestos cloud.

#### 3. Azure FinOps: 3D Compute Engineering, Rightsizing & VM Lifecycle Automation (7:22)
- 🔗 **Direct URL**: [https://www.youtube.com/watch?v=jt7t1BPNBsY](https://www.youtube.com/watch?v=jt7t1BPNBsY)
- ⏱️ **Duration**: 7:22 | 🌐 **Language**: 🇬🇧 English *(CC 20+)*
- 🏷️ **Domain**: 3D Compute Engineering, P95/P99 Telemetry Rightsizing, Lifecycle Automation, Spot VMSS
- 📝 **Technical Overview**:
> Analyzes empirical compute optimization across three dimensions: metric telemetry, specialized VM families, and automated lifecycle management. Explains why average-based sizing fails and details the mechanics of the hypervisor reservation trap where shutting down from inside the guest OS continues 100% compute billing. Covers automated API-based deallocation runbooks and priority mix scaling in Virtual Machine Scale Sets (VMSS) combining on-demand baselines with up to 90% discounted Spot instances.

#### 4. Rightsizing en Azure: Optimización Empírica P95/P99 y Trampa del Apagado en Cómputo (7:09)
- 🔗 **Direct URL**: [https://www.youtube.com/watch?v=b4QUPOKc_ng](https://www.youtube.com/watch?v=b4QUPOKc_ng)
- ⏱️ **Duration**: 7:09 | 🌐 **Language**: 🇪🇸 Spanish *(CC 20+)*
- 🏷️ **Domain**: Dimensionamiento Empírico de Cómputo, Telemetría P95/P99, Stopped vs Deallocated
- 📝 **Technical Overview**:
> Guía técnica exhaustiva sobre optimización tridimensional de cómputo en Azure. Explica en detalle por qué el apagado desde Windows o Linux mantiene activa la reserva del hipervisor y la facturación al 100%, cómo automatizar la desasignación por API con runbooks de Azure Automation y el aprovechamiento de VMSS Spot con descuentos del 90%.

#### 5. Azure Core Masking: Slash SQL Server Licensing Costs by 75% with FinOps (8:35)
- 🔗 **Direct URL**: [https://www.youtube.com/watch?v=vl6LKMgcKnw](https://www.youtube.com/watch?v=vl6LKMgcKnw)
- ⏱️ **Duration**: 8:35 | 🌐 **Language**: 🇬🇧 English *(CC 20+)*
- 🏷️ **Domain**: Database Licensing, Constrained vCPUs (Standard_E32-8s_v5), Azure Hybrid Benefit
- 📝 **Technical Overview**:
> Detailed technical breakdown on how to eliminate over $96,000/month (€88,393/month, $1.15M+ annually) in enterprise database licensing fees. Explains how Constrained vCPU sizes (such as Standard_E32-8s_v5) mask 24 physical cores from the operating system while guaranteeing full access to 256 GB RAM and 80,000 IOPS. Details the core licensing formula, stacking Azure Hybrid Benefit with existing Software Assurance, and leveraging 180-day dual-use migration rights.

#### 6. Enmascaramiento de Núcleos en Azure: Ahorra un 75% en Licencias de SQL Server (6:11)
- 🔗 **Direct URL**: [https://www.youtube.com/watch?v=JSudzAtZr9g](https://www.youtube.com/watch?v=JSudzAtZr9g)
- ⏱️ **Duration**: 6:11 | 🌐 **Language**: 🇪🇸 Spanish *(CC 20+)*
- 🏷️ **Domain**: Licenciamiento de Bases de Datos, vCPUs Restringidas, Beneficio Híbrido de Azure
- 📝 **Technical Overview**:
> Explicación en profundidad del enmascaramiento de núcleos respaldado formalmente por Microsoft. Demuestra cómo ejecutar cargas pesadas de SQL Server sobre instancias como Standard_E32-8s_v5 licenciando únicamente 8 núcleos mientras se preservan 256 GB de memoria RAM y todo el ancho de banda del subsistema de disco, ahorrando más de 1 millón de dólares al año.

#### 7. Azure Storage: Decouple Capacity & IOPS with Premium SSD v2 in FinOps (8:43)
- 🔗 **Direct URL**: [https://www.youtube.com/watch?v=BZsmqa_FUGk](https://www.youtube.com/watch?v=BZsmqa_FUGk)
- ⏱️ **Duration**: 8:43 | 🌐 **Language**: 🇬🇧 English *(CC 20+)*
- 🏷️ **Domain**: Decoupled Storage Subsystem, Premium SSD v2, NVMe Architecture (Ebdsv5)
- 📝 **Technical Overview**:
> Explores the storage paradigm shift in Azure. Contrasts legacy Premium SSD v1 and Windows Storage Spaces RAID 0 striping arrays (which forced provisioning terabytes of dead disk space purely to aggregate IOPS) with modern Premium SSD v2 architecture. Covers independent sliders for Capacity, IOPS, and Throughput, the free included baseline (3,000 IOPS and 125 MB/s), dynamic zero-downtime scaling for nightly database backups, and pairing with NVMe interfaces on Ebdsv5 series VMs.

#### 8. Almacenamiento FinOps en Azure: Premium SSD v2 y Fin del Desperdicio en Discos (6:14)
- 🔗 **Direct URL**: [https://www.youtube.com/watch?v=vxBSeN1c3os](https://www.youtube.com/watch?v=vxBSeN1c3os)
- ⏱️ **Duration**: 6:14 | 🌐 **Language**: 🇪🇸 Spanish *(CC 20+)*
- 🏷️ **Domain**: Desacoplamiento de Almacenamiento, Premium SSD v2, Erradicación de RAID 0
- 📝 **Technical Overview**:
> Masterclass sobre el fin del impuesto al almacenamiento sobredimensionado. Analiza los controles independientes de Capacidad, IOPS y MB/s en Premium SSD v2, el aprovechamiento del baseline gratuito de 3.000 IOPS y 125 MB/s a coste cero, y la configuración de escalado dinámico por script para ventanas nocturnas de mantenimiento y backups.

#### 9. Azure Hybrid Network FinOps: ExpressRoute Economics, Firewall Tiers & Endpoints (8:42)
- 🔗 **Direct URL**: [https://www.youtube.com/watch?v=p5HPpm3CI0A](https://www.youtube.com/watch?v=p5HPpm3CI0A)
- ⏱️ **Duration**: 8:42 | 🌐 **Language**: 🇬🇧 English *(CC 20+)*
- 🏷️ **Domain**: Hybrid Network Economics, ExpressRoute Break-Even, Azure Firewall Crossover, Service Endpoints
- 📝 **Technical Overview**:
> Mathematical cost modeling for hybrid enterprise networking. Demonstrates the 240 TB/month break-even threshold for 1 Gbps ExpressRoute Unlimited circuits, warns against the asymmetric transition trap requiring circuit deletion, evaluates the 12.74 TB/mo crossover point between Azure Firewall Basic and Standard, and contrasts free Service Endpoints with Private Endpoints.

#### 10. Economía de Redes Híbridas en Azure: ExpressRoute, Firewall y Endpoints (7:14)
- 🔗 **Direct URL**: [https://www.youtube.com/watch?v=j9HNF-73zDQ](https://www.youtube.com/watch?v=j9HNF-73zDQ)
- ⏱️ **Duration**: 7:14 | 🌐 **Language**: 🇪🇸 Spanish *(CC 20+)*
- 🏷️ **Domain**: Economía de Redes Híbridas, Umbral ExpressRoute, Azure Firewall, Puntos de Conexión
- 📝 **Technical Overview**:
> Rigor matemático aplicado a la conectividad híbrida empresarial. Demuestra por qué los planes Unlimited de ExpressRoute exigen más del 73% de saturación 24/7 para amortizarse frente a tarifas Medidas, la trampa de bloqueo que impide el downgrade sin destruir el circuito, y el punto de cruce óptimo entre las variantes Basic y Standard de Azure Firewall.

#### 11. Azure Telemetry & Observability FinOps: AMA Edge Filtering & Log Cost Control (7:35)
- 🔗 **Direct URL**: [https://www.youtube.com/watch?v=FBEXO3Mk1h8](https://www.youtube.com/watch?v=FBEXO3Mk1h8)
- ⏱️ **Duration**: 7:35 | 🌐 **Language**: 🇬🇧 English *(CC 20+)*
- 🏷️ **Domain**: Observability Cost Containment, Azure Monitor Agent (AMA), XPath Edge Filtering, Basic Table Plans
- 📝 **Technical Overview**:
> Practical blueprint to eliminate runaway telemetry where log analytics bills surpass virtual machine hosting expenses. Shows how Azure Monitor Agent (AMA) uses Data Collection Rules (DCR) and kernel-level XPath filtering to drop 90%+ routine informational logs inside the guest OS, routing diagnostic data to Basic Table Plans (€0.46/GB vs €2.12/GB).

#### 12. FinOps en Azure: Control de Costes en Telemetría, Logs y Monitorización (5:33)
- 🔗 **Direct URL**: [https://www.youtube.com/watch?v=jXgyXSNmXwM](https://www.youtube.com/watch?v=jXgyXSNmXwM)
- ⏱️ **Duration**: 5:33 | 🌐 **Language**: 🇪🇸 Spanish *(CC 20+)*
- 🏷️ **Domain**: Contención de Telemetría, Azure Monitor Agent (AMA), Filtrado XPath, Tablas Básicas
- 📝 **Technical Overview**:
> Sesión práctica para frenar facturas astronómicas de monitorización. Explora la migración del agente legacy MMA a AMA, la creación de reglas DCR con filtros XPath para descartar ruido HTTP 200/300 en el origen, y el ahorro del 78% mediante tablas de plan Básico para logs de infraestructura y red.

#### 13. Azure Governance & Policy FinOps: Coercive Guardrails, Tagging & Cost Allocation (8:13)
- 🔗 **Direct URL**: [https://www.youtube.com/watch?v=ewLnUSh-fJU](https://www.youtube.com/watch?v=ewLnUSh-fJU)
- ⏱️ **Duration**: 8:13 | 🌐 **Language**: 🇬🇧 English *(CC 20+)*
- 🏷️ **Domain**: Coercive Governance, Azure Policy, ARM Deny Effects, Tag Inheritance, Cost Allocation
- 📝 **Technical Overview**:
> Explains how proactive policy guardrails prevent cloud budget sprawl before resources deploy. Details Azure Policy definitions with Deny effects to block non-compliant SKUs at ARM compile-time, automatic tag inheritance from resource groups with Modify effects, and Cost Management allocation rules to distribute central firewall and gateway costs to consuming spoke subscriptions.

#### 14. FinOps Azure Híbrido: Gobernanza Coercitiva, Políticas y Automatización (6:42)
- 🔗 **Direct URL**: [https://www.youtube.com/watch?v=yAm1-z2ZpfA](https://www.youtube.com/watch?v=yAm1-z2ZpfA)
- ⏱️ **Duration**: 6:42 | 🌐 **Language**: 🇪🇸 Spanish *(CC 20+)*
- 🏷️ **Domain**: Gobernanza Coercitiva, Azure Policy, Reparto de Costes del Hub, Auditoría ARG KQL
- 📝 **Technical Overview**:
> Sesión técnica exhaustiva sobre gobernanza continua y coercitiva. Detalla cómo bloquear despliegues fuera de norma en tiempo de compilación con efectos Deny, forzar herencia de etiquetas de centro de coste y aplicar reglas de reparto de costes del Hub central hacia los Spokes consumidores con consultas automatizadas en Azure Resource Graph.

---

### Section B: Architectural Masterclass Podcast

#### 8. Podcast: Estrategias FinOps en Azure: Ahorro en Cómputo, SQL Server y Redes Híbridas (21:24)
- 🔗 **Direct URL**: [https://www.youtube.com/watch?v=Kt2MyQlUXew](https://www.youtube.com/watch?v=Kt2MyQlUXew)
- ⏱️ **Duration**: 21:24
- 🏷️ **Domain**: Full Hybrid IaaS Architecture, Governance, Compute, SQL Licensing, Networking, Observability
- 📝 **Technical Overview**:
> Deep-dive architectural podcast covering the end-to-end framework. Analyzes how hybrid Windows Server and SQL Server enterprise architectures can reduce operating expenses by over 77% ($1.6M+ annually). Explores the 4 core pillars: Compute rightsizing and deallocation, SQL Server licensing optimization via Constrained vCPUs and AHUB, network transit modeling for ExpressRoute and Azure Firewall, and kernel-level log filtering via Azure Monitor Agent.

---

### Section C: Technical Shorts & Rapid Takeaways

#### 9. How the Azure FinOps Framework Slashes Cloud Bills (1:16)
- 🔗 **Direct URL**: [https://www.youtube.com/shorts/ohhFQPy97U8](https://www.youtube.com/shorts/ohhFQPy97U8)
- ⏱️ **Duration**: 1:16
- 🏷️ **Domain**: Global TCO, Mathematical Decoupling, Enterprise Framework Overview

#### 10. Turning Azure FinOps Theory into Automated Action (1:19)
- 🔗 **Direct URL**: [https://www.youtube.com/shorts/09oqxYUeHd8](https://www.youtube.com/shorts/09oqxYUeHd8)
- ⏱️ **Duration**: 1:19
- 🏷️ **Domain**: Continuous Automation Engine, IaC, Azure Resource Graph, PowerShell Runbooks, CLI Calculators

#### 11. The Azure Cloud VM Shutdown Trap: Stopped vs Deallocated (1:13)
- 🔗 **Direct URL**: [https://www.youtube.com/shorts/G49JolO2L2I](https://www.youtube.com/shorts/G49JolO2L2I)
- ⏱️ **Duration**: 1:13
- 🏷️ **Domain**: Compute Lifecycle, Hypervisor Reservation, Stopped vs. Stopped (Deallocated)

#### 12. How Core Masking Slashes Cloud Database Costs (1:27)
- 🔗 **Direct URL**: [https://www.youtube.com/shorts/EZQ6GnAEtpE](https://www.youtube.com/shorts/EZQ6GnAEtpE)
- ⏱️ **Duration**: 1:27
- 🏷️ **Domain**: Database Licensing, Constrained vCPUs (Standard_E32-8s_v5), Azure Hybrid Benefit

#### 13. How Azure Premium SSD v2 Decouples Storage (1:08)
- 🔗 **Direct URL**: [https://www.youtube.com/shorts/FseN2K1O9PU](https://www.youtube.com/shorts/FseN2K1O9PU)
- ⏱️ **Duration**: 1:08
- 🏷️ **Domain**: Storage Economics, Premium SSD v2, Decoupled Capacity/IOPS/Throughput

#### 14. How Edge Filtering Slashes Azure Log Costs (1:30)
- 🔗 **Direct URL**: [https://www.youtube.com/shorts/qzkXGfuQmT4](https://www.youtube.com/shorts/qzkXGfuQmT4)
- ⏱️ **Duration**: 1:30
- 🏷️ **Domain**: Observability Cost Containment, Azure Monitor Agent, DCR XPath Filtering, Basic Table Plan

#### 15. How Cloud Unlimited Plans Trap You (1:24)
- 🔗 **Direct URL**: [https://www.youtube.com/shorts/Xd2adpKN6VM](https://www.youtube.com/shorts/Xd2adpKN6VM)
- ⏱️ **Duration**: 1:24
- 🏷️ **Domain**: Hybrid Network Economics, ExpressRoute Metered vs. Unlimited, Break-Even Formula

</details>

---

## 13. 🌐 High Added-Value Knowledge Base & Curated Internet References

This section documents the foundational industry research, architectural standards, pricing disclosures, and real-world engineering benchmarks upon which the technical monograph and this repository are built.

### 13.1. Microsoft Learn Official Architecture & Sizing Standards

- **[Azure Managed Disk Types & Premium SSD v2 Specifications](https://learn.microsoft.com/en-us/azure/virtual-machines/disks-types)**:
  *Key FinOps Takeaway*: Documents the architecture of Premium SSD v2, where Capacity, IOPS, and MB/s throughput are decoupled. Explains the included baseline of 3,000 IOPS and 125 MB/s free of charge and the rules for zero-downtime scaling up to 4 times per 24 hours.
- **[Constrained vCPU Sizes & Core Customization (CCC)](https://learn.microsoft.com/en-us/azure/virtual-machines/constrained-vcpu)**:
  *Key FinOps Takeaway*: The authoritative specification on how the Azure hypervisor masks processor presentation to Windows and SQL Server, enabling 50% to 75% software licensing cost reductions while preserving full physical host RAM and storage throughput.
- **[Checklist & Best Practices for SQL Server on Azure VMs](https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/performance-guidelines-best-practices-checklist?view=azuresql)**:
  *Key FinOps Takeaway*: Engineering guidelines covering storage layout, tempdb placement, memory allocation, and the critical prohibition of Standard HDD for production data volumes.
- **[Storage Best Practices for SQL Server on Azure Virtual Machines](https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/performance-guidelines-best-practices-storage?view=azuresql)**:
  *Key FinOps Takeaway*: Explains why host caching is disabled on Premium SSD v2, and how pairing modern `Ebdsv5` NVMe interfaces delivers sub-millisecond transaction log latency.
- **[Pricing Guidance for SQL Server on Azure VMs](https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/pricing-guidance?view=azuresql)**:
  *Key FinOps Takeaway*: Details the dual-licensing mechanics (Pay-As-You-Go per second vs. Azure Hybrid Benefit), Developer Edition exemptions, and the SQL IaaS Agent Extension.
- **[Azure Hybrid Benefit for Windows Server](https://learn.microsoft.com/en-us/windows-server/get-started/azure-hybrid-benefit)**:
  *Key FinOps Takeaway*: Explains how bringing Software Assurance (SA) core licenses eliminates the ~36% Windows OS markup, matching Linux base compute pricing.
- **[Transition to Centrally Managed Azure Hybrid Benefit](https://learn.microsoft.com/en-us/azure/cost-management-billing/scope-level/transition-existing)**:
  *Key FinOps Takeaway*: Explains the 180-day dual-use rights grace period during on-premises to cloud migration and enrollment-level scope management.
- **[Create and Manage Azure Cost Allocation Rules](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/allocate-costs)**:
  *Key FinOps Takeaway*: Official guide to configuring shared-cost redistribution in Cost Management (fixed percentage, even split, and proportional compute/network split).
- **[Data Collection Rules (DCRs) and Azure Monitor Agent (AMA)](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview)**:
  *Key FinOps Takeaway*: Technical documentation of XPath event filtering at the edge inside Windows Server, preventing high-volume telemetry from reaching billable ingestion pipelines.
- **[Azure Monitor Logs Cost Calculations & Table Plans](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs)**:
  *Key FinOps Takeaway*: Outlines the pricing differential between standard Analytics tables ($2.30/GB / ~€2.12/GB) and Basic Table Plans (~$0.50/GB / ~€0.46/GB, >78% savings) for high-volume logs.

### 13.2. FinOps Foundation Framework & Working Group Publications

- **[FinOps Foundation: Optimizing Azure Managed Disks for Value](https://www.finops.org/wg/finops-for-azure-managed-disks-optimizing-for-value/)**:
  *Key FinOps Takeaway*: Working group recommendations detailing the financial transition from monolithic P30/P40 disks to granular Premium SSD v2, addressing orphaned disk leakage and storage sizing rights.
- **[FinOps Best Practices for Compute](https://learn.microsoft.com/en-us/cloud-computing/finops/best-practices/compute)**:
  *Key FinOps Takeaway*: Joint Microsoft and FinOps Foundation guidelines covering rightsizing heuristics, the deallocated state lifecycle, and commitment discount portfolios.
- **[CloudZero: Azure Cost Optimization Complete Guide](https://www.cloudzero.com/blog/azure-cost-optimization/)**:
  *Key FinOps Takeaway*: Industry analysis of cloud unit economics, breaking down the 4 phases of continuous FinOps maturity and organizational showback/chargeback.

### 13.3. Mathematical & Pricing Break-Even Analyses

- **[EgressCost: Azure Bandwidth & Egress Pricing Explained](https://egresscost.com/azure/)**:
  *Key FinOps Takeaway*: Independent empirical breakdown of Azure zonal data transfer tariffs (Zone 1, Zone 2, Zone 3) and asymmetric internet egress fees.
- **[Azure ExpressRoute Pricing Breakdown & Circuit Analysis](https://azure.microsoft.com/en-us/pricing/details/expressroute/)**:
  *Key FinOps Takeaway*: Official pricing matrices for ExpressRoute Metered vs. Unlimited ports, demonstrating the mathematical break-even threshold requiring >73% sustained 24/7 line saturation.
- **[Pump.co: Azure ExpressRoute Pricing, Costs, Drivers & Savings](https://www.pump.co/blog/azure-expressroute-pricing/)**:
  *Key FinOps Takeaway*: Analysis of corporate migration overspending on ExpressRoute Unlimited plans and operational strategies for starting with Metered circuits.
- **[Critical Cloud: Azure Firewall Basic vs. Standard Cost Comparison](https://criticalcloud.ai/blog/azure/azure-firewall-basic-vs-standard-cost-comparison/)**:
  *Key FinOps Takeaway*: Empirical evaluation of the data processing fee penalty ($0.065/GB on Basic vs. $0.016/GB on Standard), demonstrating the ~12.74 TB/month crossover point.
- **[Enforza: Azure Firewall Pricing — What It Costs and How to Cut It](https://enforza.io/azure-firewall-cost/)**:
  *Key FinOps Takeaway*: Tactical guide to deallocating non-production firewalls outside business hours using Azure Automation to eliminate the $912/mo (~€840/mo) fixed fee.
- **[FastTrack for Azure: Private Endpoints vs. Service Endpoints](https://techcommunity.microsoft.com/blog/fasttrackforazureblog/azure-private-endpoint-vs-service-endpoint-a-comprehensive-guide/4363095)**:
  *Key FinOps Takeaway*: Microsoft engineering deep-dive on why Service Endpoints (100% Free) should remain the default standard for internal Azure VNet-to-PaaS traffic, and when Private Endpoints justify their hourly and per-GB costs.

### 13.4. Real-World Community Investigations, Reddit & Microsoft Q&A Deep Dives

- **[Microsoft Q&A: Server Licensed Cores for Core Constrained vCPU VM Sizes](https://learn.microsoft.com/en-us/answers/questions/1336404/server-licensed-cores-for-core-constrained-vcpu-vm)**:
  *Key FinOps Takeaway*: Community verification from Microsoft licensing specialists confirming that software license audits legally count only active cores exposed to the OS.
- **[Microsoft Q&A: Azure VM Resize & SQL Server Standard License Per-Second Impact](https://learn.microsoft.com/en-us/answers/questions/5810958/azure-vm-resize-sql-server-standard-license-will-a)**:
  *Key FinOps Takeaway*: Details the operational risk of scaling up a VM without reapplying CCC constraints, instantly triggering higher per-second license billing.
- **[Reddit r/AZURE: SQL VM Sizing — IOPS vs NVMe Performance Benchmarks](https://www.reddit.com/r/AZURE/comments/1i0pnjt/sql_vm_sizing_iops_vs_nvme/)**:
  *Key FinOps Takeaway*: Real-world DBA benchmarks comparing remote storage latency against local NVMe scratch storage for SQL Server tempdb.
- **[Reddit r/AZURE: ExpressRoute Direct & Port Type Migration Traps](https://www.reddit.com/r/AZURE/comments/t651y8/expressroute_direct/)**:
  *Key FinOps Takeaway*: Architectural warnings detailing the inability to downgrade from Unlimited to Metered in-place, necessitating telecom circuit recreation and downtime.
- **[Reddit r/AZURE: Azure Monitor Agent (AMA) and Data Collection Rules in Practice](https://www.reddit.com/r/AZURE/comments/q1vcpu/azure_monitor_agent_and_data_collection_rules/)**:
  *Key FinOps Takeaway*: Practical operator experiences applying XPath queries to silence IIS HTTP 200 noise and reduce monthly Log Analytics ingestion bills by 70%.
- **[Microsoft Q&A: Applying Custom Data Collection Rules for AMA to Reduce Log Ingestion](https://learn.microsoft.com/en-us/answers/questions/2086637/applying-custom-data-collection-rules-for-ama-to-r)**:
  *Key FinOps Takeaway*: Concrete XPath recipes for filtering out non-actionable Windows Event IDs (such as process creation 4688 noise).

---

### 13.5. Complete 61-Item Concordance Table

The table below links every bibliographic reference cited in the original monograph [1–61] to its source URL:

| Ref | Title & Source | Canonical URL |
| :---: | :--- | :--- |
| **[1]** | Azure Cost Optimization: The Complete Guide (2026) - CloudZero | [https://www.cloudzero.com/blog/azure-cost-optimization/](https://www.cloudzero.com/blog/azure-cost-optimization/) |
| **[2]** | Azure Cost Optimization: Complete Guide 2026 - nOps | [https://www.nops.io/blog/azure-cost-optimization/](https://www.nops.io/blog/azure-cost-optimization/) |
| **[3]** | Mastering Cost Allocation in Azure - Another DevOps Blog | [https://anotherdevops.blog/posts/cost-allocation/](https://anotherdevops.blog/posts/cost-allocation/) |
| **[4]** | Azure Managed Disk Types - Microsoft Learn | [https://learn.microsoft.com/en-us/azure/virtual-machines/disks-types](https://learn.microsoft.com/en-us/azure/virtual-machines/disks-types) |
| **[5]** | Data Collection Rules (DCRs) in Azure Monitor - Microsoft Learn | [https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview) |
| **[6]** | Azure Cost Optimization Guide: Practical Strategies - Matías | [https://medium.com/@cocamatias/azure-cost-optimization-guide-practical-strategies-that-actually-work-9c542018f157](https://medium.com/@cocamatias/azure-cost-optimization-guide-practical-strategies-that-actually-work-9c542018f157) |
| **[7]** | Azure Cost Allocation with Tags - Inventive HQ | [https://inventivehq.com/knowledge-base/microsoft-azure/how-to-enable-cost-allocation-for-shared-resources-in-azure](https://inventivehq.com/knowledge-base/microsoft-azure/how-to-enable-cost-allocation-for-shared-resources-in-azure) |
| **[8]** | Best Practices for Virtual Machine Cost Optimization - Microsoft Learn | [https://learn.microsoft.com/en-us/azure/virtual-machines/cost-optimization-best-practices](https://learn.microsoft.com/en-us/azure/virtual-machines/cost-optimization-best-practices) |
| **[9]** | Azure Cost Management: Fix Shared Chargeback Disputes - VBeyond | [https://www.vbeyonddigital.com/blog/azure-cost-management-how-to-fix-shared-service-chargeback-disputes/](https://www.vbeyonddigital.com/blog/azure-cost-management-how-to-fix-shared-service-chargeback-disputes/)|
| **[10]**| Create and Manage Azure Cost Allocation Rules - Microsoft Learn | [https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/allocate-costs](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/allocate-costs) |
| **[11]**| Cost Allocation Rules - REST API - Microsoft Learn | [https://learn.microsoft.com/en-us/rest/api/cost-management/cost-allocation-rules?view=rest-cost-management-2026-06-01](https://learn.microsoft.com/en-us/rest/api/cost-management/cost-allocation-rules?view=rest-cost-management-2026-06-01) |
| **[12]**| Introduction to Cost Allocation - Microsoft Cost Management | [https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/cost-allocation-introduction](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/cost-allocation-introduction) |
| **[13]**| Ensuring Effective Cost Allocation In Azure - Xebia | [https://xebia.com/articles/ensuring-effective-cost-allocation-in-azure/](https://xebia.com/articles/ensuring-effective-cost-allocation-in-azure/) |
| **[14]**| Unlocking Azure SQL Pricing: How Much Does it Really Cost? - Intercept | [https://intercept.cloud/en-gb/blogs/azure-sql-pricing](https://intercept.cloud/en-gb/blogs/azure-sql-pricing) |
| **[15]**| Top 20 Azure Cost Optimization Strategies for 2026 - Sedai | [https://sedai.io/blog/cost-optimization-strategies-azure](https://sedai.io/blog/cost-optimization-strategies-azure) |
| **[16]**| Azure VM Cost Optimization: 4 FinOps Levers - EverythingCloud | [https://everythingcloud.com/insights/azure-vm-cost-optimization/](https://everythingcloud.com/insights/azure-vm-cost-optimization/) |
| **[17]**| Checklist: Best Practices for SQL Server on Azure VMs - Microsoft Learn | [https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/performance-guidelines-best-practices-checklist?view=azuresql](https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/performance-guidelines-best-practices-checklist?view=azuresql) |
| **[18]**| Storage Best Practices for SQL Server on Azure VMs - Microsoft Learn | [https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/performance-guidelines-best-practices-storage?view=azuresql](https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/performance-guidelines-best-practices-storage?view=azuresql) |
| **[19]**| Azure SQL Managed Instance Cost Optimization Strategies - Lucidity | [https://www.lucidity.cloud/feeds/blog/azure-sql-managed-instance-cost-optimization](https://www.lucidity.cloud/feeds/blog/azure-sql-managed-instance-cost-optimization) |
| **[20]**| Pricing Guidance for SQL Server on Azure VMs - Microsoft Learn | [https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/pricing-guidance?view=azuresql](https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/pricing-guidance?view=azuresql) |
| **[21]**| FinOps Best Practices for Compute - Microsoft Learn | [https://learn.microsoft.com/en-us/cloud-computing/finops/best-practices/compute](https://learn.microsoft.com/en-us/cloud-computing/finops/best-practices/compute) |
| **[22]**| Understanding Azure SQL Licensing Guide - 2-Data | [https://2-data.com/knowledge-hub/understanding-azure-sql-licensing-a-complete-pricing-guide/](https://2-data.com/knowledge-hub/understanding-azure-sql-licensing-a-complete-pricing-guide/) |
| **[23]**| Azure Hybrid Benefit for Windows Server - Microsoft Learn | [https://learn.microsoft.com/en-us/windows-server/get-started/azure-hybrid-benefit](https://learn.microsoft.com/en-us/windows-server/get-started/azure-hybrid-benefit) |
| **[24]**| Transition to Centrally Managed Azure Hybrid Benefit - Microsoft Learn | [https://learn.microsoft.com/en-us/azure/cost-management-billing/scope-level/transition-existing](https://learn.microsoft.com/en-us/azure/cost-management-billing/scope-level/transition-existing) |
| **[25]**| Azure Hybrid Benefit Explained - ProsperOps | [https://www.prosperops.com/blog/azure-hybrid-benefit/](https://www.prosperops.com/blog/azure-hybrid-benefit/) |
| **[26]**| Azure Hybrid Benefit Pricing Overview - Microsoft Azure | [https://azure.microsoft.com/en-us/pricing/offers/hybrid-benefit](https://azure.microsoft.com/en-us/pricing/offers/hybrid-benefit) |
| **[27]**| Azure Hybrid Benefit: Is it Worth It? - Intercept | [https://intercept.cloud/en-gb/blogs/azure-hybrid-benefit](https://intercept.cloud/en-gb/blogs/azure-hybrid-benefit) |
| **[28]**| SQL Server Standard Virtual Machines Pricing - Microsoft Azure | [https://acom-sandbox.azure.net/en-us/pricing/details/virtual-machines/sql-server-standard/](https://acom-sandbox.azure.net/en-us/pricing/details/virtual-machines/sql-server-standard/) |
| **[29]**| Constrained vCPU Sizes - Azure Virtual Machines | [https://docs.azure.cn/en-us/virtual-machines/constrained-vcpu](https://docs.azure.cn/en-us/virtual-machines/constrained-vcpu) |
| **[30]**| VM vCore Customization for SQL Server - Microsoft Learn | [https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/vm-vcore-customization-for-sql?view=azuresql](https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/vm-vcore-customization-for-sql?view=azuresql) |
| **[31]**| Constrained vCPU Sizes Reference - Microsoft Learn | [https://learn.microsoft.com/en-us/azure/virtual-machines/constrained-vcpu](https://learn.microsoft.com/en-us/azure/virtual-machines/constrained-vcpu) |
| **[32]**| Server Licensed Cores for Core Constrained vCPU VM Sizes - Microsoft Q&A | [https://learn.microsoft.com/en-us/answers/questions/1336404/server-licensed-cores-for-core-constrained-vcpu-vm](https://learn.microsoft.com/en-us/answers/questions/1336404/server-licensed-cores-for-core-constrained-vcpu-vm) |
| **[33]**| Azure VM Updates: Reduce Software Licensing Costs - BPS | [https://bpsme.com/reduce-software-licensing-costs-azure/](https://bpsme.com/reduce-software-licensing-costs-azure/) |
| **[34]**| Azure VM Resize SQL Server Standard License - Microsoft Q&A | [https://learn.microsoft.com/en-us/answers/questions/5810958/azure-vm-resize-sql-server-standard-license-will-a](https://learn.microsoft.com/en-us/answers/questions/5810958/azure-vm-resize-sql-server-standard-license-will-a) |
| **[35]**| Deploy SQL Server on Azure VMs with Premium SSD v2 - Microsoft Learn | [https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/storage-configuration-premium-ssd-v2?view=azuresql](https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/storage-configuration-premium-ssd-v2?view=azuresql) |
| **[36]**| Azure Managed Disks: Standard HDD vs SSD vs Premium - C# Corner | [https://www.c-sharpcorner.com/article/azure-infrastructure-series-7-azure-managed-disks-standard-hdd-vs-standard-ss/](https://www.c-sharpcorner.com/article/azure-infrastructure-series-7-azure-managed-disks-standard-hdd-vs-standard-ss/) |
| **[37]**| FinOps for Azure Managed Disks: Optimizing for Value - FinOps Foundation | [https://www.finops.org/wg/finops-for-azure-managed-disks-optimizing-for-value/](https://www.finops.org/wg/finops-for-azure-managed-disks-optimizing-for-value/) |
| **[38]**| SQL VM Sizing IOPs vs NVMe - Reddit r/AZURE | [https://www.reddit.com/r/AZURE/comments/1i0pnjt/sql_vm_sizing_iops_vs_nvme/](https://www.reddit.com/r/AZURE/comments/1i0pnjt/sql_vm_sizing_iops_vs_nvme/) |
| **[39]**| Azure VM vs Disk vs Costs: Does Size Matter? - Robert Smit | [https://robertsmit.wordpress.com/2019/07/09/azure-vm-vs-disk-vs-costs-does-size-matter-or-a-higher-price-for-better-specifications-azure-storage-performance/](https://robertsmit.wordpress.com/2019/07/09/azure-vm-vs-disk-vs-costs-does-size-matter-or-a-higher-price-for-better-specifications-azure-storage-performance/) |
| **[40]**| Managed Disks Pricing - Microsoft Azure | [https://azure.microsoft.com/en-us/pricing/details/managed-disks/](https://azure.microsoft.com/en-us/pricing/details/managed-disks/) |
| **[41]**| Optimize Azure VM Disk Performance by Tier - OneUptime | [https://oneuptime.com/blog/post/2026-02-16-how-to-optimize-azure-vm-disk-performance-by-choosing-the-right-storage-tier/view](https://oneuptime.com/blog/post/2026-02-16-how-to-optimize-azure-vm-disk-performance-by-choosing-the-right-storage-tier/view) |
| **[42]**| Azure ExpressRoute Pricing Details - Microsoft Azure | [https://azure.microsoft.com/en-us/pricing/details/expressroute/](https://azure.microsoft.com/en-us/pricing/details/expressroute/) |
| **[43]**| Azure Bandwidth & Egress Pricing Explained (2026) - EgressCost | [https://egresscost.com/azure/](https://egresscost.com/azure/) |
| **[44]**| Azure ExpressRoute Pricing: Costs, Drivers, and Savings - Pump.co | [https://www.pump.co/blog/azure-expressroute-pricing/](https://www.pump.co/blog/azure-expressroute-pricing/) |
| **[45]**| Azure ExpressRoute Pricing Guide — Circuit + - EPC Group | [https://www.epcgroup.net/answers/azure-expressroute-pricing-guide](https://www.epcgroup.net/answers/azure-expressroute-pricing-guide) |
| **[46]**| ExpressRoute Direct Discussions - Reddit r/AZURE | [https://www.reddit.com/r/AZURE/comments/t651y8/expressroute_direct/](https://www.reddit.com/r/AZURE/comments/t651y8/expressroute_direct/) |
| **[47]**| Azure Firewall Pricing: What It Costs and How to Cut It - Enforza | [https://enforza.io/azure-firewall-cost/](https://enforza.io/azure-firewall-cost/) |
| **[48]**| Azure Firewall: Pricing, Benefits & Best Practices Guide - Pump.co | [https://www.pump.co/blog/azure-firewall/](https://www.pump.co/blog/azure-firewall/) |
| **[49]**| Azure Firewall Basic vs Standard: Cost Comparison - Critical Cloud | [https://criticalcloud.ai/blog/azure/azure-firewall-basic-vs-standard-cost-comparison/](https://criticalcloud.ai/blog/azure/azure-firewall-basic-vs-standard-cost-comparison/) |
| **[50]**| Azure Firewall Pricing 2026: Hub-and-Spoke Cost Guide - Pixlodo | [https://pixlodo.com/azure-firewall-pricing/](https://pixlodo.com/azure-firewall-pricing/) |
| **[51]**| Azure Private Endpoint vs. Service Endpoint Guide - FastTrack for Azure | [https://techcommunity.microsoft.com/blog/fasttrackforazureblog/azure-private-endpoint-vs-service-endpoint-a-comprehensive-guide/4363095](https://techcommunity.microsoft.com/blog/fasttrackforazureblog/azure-private-endpoint-vs-service-endpoint-a-comprehensive-guide/4363095) |
| **[52]**| Azure Private Endpoint vs Service Endpoint: When to Use Which? - AzurePro | [https://www.azurepro.ae/azure-private-endpoint-vs-service-endpoint-when-to-use-which/](https://www.azurepro.ae/azure-private-endpoint-vs-service-endpoint-when-to-use-which/) |
| **[53]**| Azure Networking: Service vs Private Endpoints - Jannik Reinhard | [https://jannikreinhard.com/service-endpoints-vs-private-endpoints/](https://jannikreinhard.com/service-endpoints-vs-private-endpoints/) |
| **[54]**| Is Data Transfer More Expensive When Using Private Endpoints? - Microsoft Q&A | [https://learn.microsoft.com/en-us/answers/questions/1325138/is-it-true-that-data-transfer-is-more-expensive-wh](https://learn.microsoft.com/en-us/answers/questions/1325138/is-it-true-that-data-transfer-is-more-expensive-wh) |
| **[55]**| Azure Data Collection Rules (DCR) Explained - Medium | [https://medium.com/@cloudwithaarya/azure-data-collection-rules-dcr-explained-azure-monitor-made-simple-2934c2311e78](https://medium.com/@cloudwithaarya/azure-data-collection-rules-dcr-explained-azure-monitor-made-simple-2934c2311e78) |
| **[56]**| Azure Monitor Cost and Usage - GitHub Documentation | [https://github.com/MicrosoftDocs/azure-monitor-docs/blob/main/articles/azure-monitor/fundamentals/cost-usage.md](https://github.com/MicrosoftDocs/azure-monitor-docs/blob/main/articles/azure-monitor/fundamentals/cost-usage.md) |
| **[57]**| Azure Monitor Pricing Overview - Microsoft Azure | [https://azure.microsoft.com/en-us/pricing/details/monitor/](https://azure.microsoft.com/en-us/pricing/details/monitor/) |
| **[58]**| Azure Monitor Logs Cost Calculations And Options - Microsoft Learn | [https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/cost-logs) |
| **[59]**| Azure Monitor Agent and Data Collection Rules - Reddit r/AZURE | [https://www.reddit.com/r/AZURE/comments/q1vcpu/azure_monitor_agent_and_data_collection_rules/](https://www.reddit.com/r/AZURE/comments/q1vcpu/azure_monitor_agent_and_data_collection_rules/) |
| **[60]**| Cost Optimization in Azure Monitor - Microsoft Learn | [https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/best-practices-cost](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/best-practices-cost) |
| **[61]**| Applying Custom Data Collection Rules for AMA to Reduce Log - Microsoft Q&A | [https://learn.microsoft.com/en-us/answers/questions/2086637/applying-custom-data-collection-rules-for-ama-to-r](https://learn.microsoft.com/en-us/answers/questions/2086637/applying-custom-data-collection-rules-for-ama-to-r) |

### 13.6. Modern 2026 FinOps Tooling & Automation Repositories (GitHub)

The table below catalogs primary open-source and first-party repositories powering modern enterprise Azure FinOps automation:

| Tool / Platform | Organization & Repository | Core Enterprise Automation Capability |
| :--- | :--- | :--- |
| **Microsoft FinOps Toolkit** | [`microsoft/finops-toolkit`](https://github.com/microsoft/finops-toolkit) | FOCUS 1.0 schema lakehouse, Power BI templates, automated export pipelines, and Bicep/Terraform modules. |
| **Azure Quick Review (AZQR)** | [`Azure/azqr`](https://github.com/Azure/azqr) | Official Microsoft CLI scanner evaluating subscriptions against Well-Architected Framework (WAF) cost & SLA best practices. |
| **Azure Cost CLI** | [`mivano/azure-cost-cli`](https://github.com/mivano/azure-cost-cli) | Terminal-based cost queries, daily trends, resource group budgets, and Markdown exports in € and $. |
| **Azure Tree (aztree)** | [`milanm/aztree`](https://github.com/milanm/aztree) | Fast interactive terminal tree visualizer for Azure tenant hierarchy, resource groups, tags, and orphaned assets. |
| **Azure Optimization Engine** | [`microsoft/Azure-Optimization-Engine`](https://github.com/microsoft/Azure-Optimization-Engine) | Extensible Azure Log Analytics & Automation engine for custom enterprise rightsizing and idle resource alerting. |
| **Azure Governance Visualizer** | [`JulianHayward/Azure-Governance-Visualizer`](https://github.com/JulianHayward/Azure-Governance-Visualizer) | Granular visibility into Management Group hierarchies, RBAC, Policy compliance, orphaned assets, and security posture. |
| **Azure Resource Inventory** | [`Claudio-Merola/AzureResourceInventory`](https://github.com/Claudio-Merola/AzureResourceInventory) | Automated PowerShell inventory report generator with cost overlays, security baselines, and Visio network diagrams. |
| **Infracost** | [`infracost/infracost`](https://github.com/infracost/infracost) | Shift-left pre-merge cloud cost estimation, budget diffs, and automated PR guardrails for Terraform and Bicep. |
| **Steampipe Azure Plugin** | [`turbot/steampipe-plugin-azure`](https://github.com/turbot/steampipe-plugin-azure) | Real-time zero-ETL SQL querying across live Azure cloud infrastructure, resource graph, and billing endpoints. |
| **Cloud Custodian** | [`cloud-custodian/cloud-custodian`](https://github.com/cloud-custodian/cloud-custodian) | Declarative YAML policy engine for real-time automated waste reclamation, auto-tagging, and resource deallocation. |

---

## 14. 📜 License

This project is licensed under the **Apache License 2.0**. See the [LICENSE](LICENSE) file for details.
