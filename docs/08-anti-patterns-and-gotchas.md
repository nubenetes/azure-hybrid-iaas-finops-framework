# 08. Enterprise FinOps: Top 15 Architectural Anti-Patterns & Hidden Gotchas

This document catalogs the most prevalent architectural mistakes, licensing traps, and hidden cost leaks encountered in enterprise Azure IaaS hybrid environments, along with concrete remediations.

---

## 1. Compute & Lifecycle Anti-Patterns

### Anti-Pattern 1: The Guest OS "Shutdown" Ghost Charge
- **Symptom**: Administrators run `shutdown /s` from Windows Start Menu. The portal displays status as `Stopped`.
- **Trap**: The hypervisor maintains the physical CPU cores and RAM reserved on the host blade. Compute billing continues at 100% of the hourly rate!
- **Remediation**: Always invoke `Stop-AzVM` or Azure CLI `az vm deallocate` to achieve the `Stopped (deallocated)` state ($0.00/hr compute).

### Anti-Pattern 2: Zombie Disks & Unassociated Static Public IPs
- **Symptom**: Virtual machines are deleted, but their OS and Data disks remain unattached.
- **Trap**: Managed disks bill for allocated storage capacity forever until explicitly deleted. Static Public IPs bill an hourly reservation fee when unattached.
- **Remediation**: Deploy our automated KQL audit queries (`find-orphaned-managed-disks.kql` and `find-unassociated-public-ips.kql`) to identify and purge unattached resources.

### Anti-Pattern 3: B1s Sizing on Windows Server
- **Symptom**: Attempting to save costs by deploying `Standard_B1s` (1 vCPU, 1 GiB RAM) for Windows Server testing.
- **Trap**: Windows Server requires ~1.5 to 2 GiB just to load the kernel and Windows Defender. The VM exhausts RAM, swaps aggressively to pagefile, runs out of CPU burst credits, and locks up.
- **Remediation**: Mandate at least **`Standard_B2s` or `Standard_B2ms`** for Windows Server.

---

## 4. Licensing & Core Sizing Anti-Patterns

### Anti-Pattern 4: Unconstrained Cores on High-RAM SQL Server VMs
- **Symptom**: Deploying a `Standard_E32s_v5` (32 cores, 256 GiB RAM) for a database that only requires 8 execution cores.
- **Trap**: SQL Server licenses every active vCPU. The company incurs ~$12,800/mo in SQL Enterprise licensing unnecessarily.
- **Remediation**: Switch to Constrained Core SKU **`Standard_E32-8s_v5`**, slashing licensing by **75% ($9,600/month savings)** while keeping 256 GiB RAM and 80k IOPS intact.

### Anti-Pattern 5: Missing Azure Hybrid Benefit (AHB) Flag
- **Symptom**: Organization owns Software Assurance on Windows Server or SQL Server, but VMs are deployed with default Pay-As-You-Go licensing flags.
- **Trap**: The organization pays double licensing—once on-premises, and once through Azure PAYG rates.
- **Remediation**: Enforce `enforce-azure-hybrid-benefit.json` Azure Policy to auto-audit and apply AHB across all eligible VMs.

### Anti-Pattern 6: Running Commercial SQL Editions in Dev/Test
- **Symptom**: Provisioning SQL Server Standard or Enterprise in staging and development subscriptions.
- **Trap**: Wasting thousands of dollars per month on non-production licensing.
- **Remediation**: Deploy **SQL Server Developer Edition**, providing 100% feature parity with Enterprise at **$0.00 licensing cost**.

---

## 3. Storage Subsystem Anti-Patterns

### Anti-Pattern 7: Software RAID 0 Striping on Premium SSD v1
- **Symptom**: Provisioning four P30 or P40 disks and creating Windows Storage Spaces RAID 0 to achieve high IOPS.
- **Trap**: 70-80% of purchased disk capacity is empty. Wastes hundreds of dollars per VM, consumes CPU cycles for striping, and complicates volume snapshots.
- **Remediation**: Migrate to a single **Premium SSD v2** disk, provisioning only the needed gigabytes and dynamically setting the IOPS/throughput sliders.

### Anti-Pattern 8: Premium SSD v2 Host Caching Expectation
- **Symptom**: Attempting to enable Read-Only Host Caching on Premium SSD v2.
- **Trap**: Premium SSD v2 does not support host caching; deployment scripts fail.
- **Remediation**: Use `Ebdsv5` or `Ebsv5` VMs with native NVMe local temporary disks for sub-millisecond scratch space and tempdb.

### Anti-Pattern 9: Using Standard HDD for Production SQL Data
- **Symptom**: Placing secondary data files or database logs on Standard HDD to minimize cost.
- **Trap**: Standard HDD latency exhibits erratic latency spikes (>100-500 ms), triggering SQL transaction log timeouts and database corruptions.
- **Remediation**: Enforce Azure Policy banning Standard HDD for database data volumes.

---

## 4. Hybrid Networking Anti-Patterns

### Anti-Pattern 10: The ExpressRoute "Unlimited" Default
- **Symptom**: Defaulting to the Unlimited Plan on a 1 Gbps circuit ($6,450/month) out of fear of variable billing.
- **Trap**: The circuit transfers only 5 TB/month. The organization overpays by over **$5,800 every month**.
- **Remediation**: Always start on **Metered ($436/month + $0.025/GB)**. Only upgrade if empirical egress exceeds 240 TB/month.

### Anti-Pattern 11: The Impossible In-Place ExpressRoute Downgrade
- **Symptom**: Realizing an Unlimited circuit is underutilized and attempting to switch it back to Metered.
- **Trap**: Azure API rejects the downgrade. Requires complete circuit destruction, circuit recreation, telco cross-connect changes, and scheduled downtime.
- **Remediation**: Strictly enforce ADR-003: Never deploy Unlimited on Day 1.

### Anti-Pattern 12: Azure Firewall Basic in High-Traffic Hubs
- **Symptom**: Choosing Azure Firewall Basic to save on the fixed hourly fee ($288/mo vs. $912/mo).
- **Trap**: Basic charges $0.065/GB for data inspection (4x higher than Standard's $0.016/GB) and throttles at 250 Mbps. At 20 TB monthly traffic, Basic costs $1,588/mo vs. $1,232/mo on Standard.
- **Remediation**: Use our [Firewall Crossover Calculator](math-models/firewall-sku-crossover.md) to choose the right SKU based on bandwidth and volume.

### Anti-Pattern 13: Private Endpoints Everywhere
- **Symptom**: Creating Private Endpoints for every internal spoke VM accessing Azure Blob Storage or Key Vault.
- **Trap**: Each endpoint incurs ~$7.30/mo + $0.01/GB data tax + complex Private DNS Zone synchronization.
- **Remediation**: Use **Virtual Network Service Endpoints** (100% Free, zero DNS overhead) for all internal Azure VM-to-PaaS traffic.

---

## 5. Observability Anti-Patterns

### Anti-Pattern 14: Ingesting HTTP 200 OK Logs in Log Analytics
- **Symptom**: Default IIS logging streaming all web server transactions to Log Analytics Analytics tier ($2.30/GB).
- **Trap**: Telemetry ingestion bill exceeds the VM compute bill.
- **Remediation**: Deploy AMA with Data Collection Rules (DCR) XPath filters to drop HTTP 200-399 and capture only anomalies (HTTP >= 400 or time-taken > 3s).

### Anti-Pattern 15: Retaining Firewall Raw Logs in Analytics Tier
- **Symptom**: Storing millions of routine firewall allow/deny logs in the standard Analytics table for 1 year.
- **Trap**: Extreme storage and ingestion costs for data that is almost never interactively queried.
- **Remediation**: Move high-volume firewall diagnostic logs to the **Basic Table Plan ($0.50/GB)** and archive old logs at $0.02/GB/month.
