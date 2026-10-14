# ADR-002: Migration from Premium SSD v1 to Premium SSD v2 for Transactional Storage

## Status
Accepted

## Context
SQL Server instances deployed on Azure IaaS previously utilized **Premium SSD v1** managed disks. Under Premium SSD v1, performance parameters (IOPS and throughput MB/s) were rigidly coupled to disk capacity. To achieve 7,500 IOPS, engineering teams were forced to provision 2 TiB (P40) disks, even when the database only required 200 GiB of data. Furthermore, to reach 15,000 to 20,000 IOPS, administrators configured Windows Server Storage Spaces (RAID 0 disk striping), introducing operational fragility, snapshot inconsistency risks, CPU overhead for parity/striping, and 70-80% wasted storage capacity.

## Decision
We mandate the adoption of **Premium SSD v2** for all production SQL Server transaction log, database data, and TempDB disks.
- Decouple disk capacity, IOPS, and throughput.
- Leverage the baseline included performance (3,000 IOPS and 125 MB/s free on every disk).
- Eliminate guest-level RAID 0 / Storage Spaces striping in favor of single high-performance disks.
- Implement automated Day-2 runbooks to scale IOPS/throughput dynamically up to 4 times per 24-hour period for nightly batch or backup windows.

## Consequences
### Positive
- **Drastic Cost Optimization**: Eliminates overprovisioned storage capacity. A 512 GiB disk with 12,000 IOPS costs ~$120/mo on Premium SSD v2 versus $640/mo for striped P40 disks.
- **Zero-Downtime Dynamic Performance Tuning**: IOPS and MB/s sliders can be adjusted online without stopping the virtual machine.
- **Architectural Simplification**: Direct single-disk volume mounting eliminates software RAID complexity and simplifies Azure Backup volume-consistent snapshots.

### Negative / Trade-offs
- **No Host Caching**: Premium SSD v2 does not support read-only host caching. (Mitigated by sub-millisecond baseline latency and Ebdsv5 NVMe interfaces).
- **Zonal Availability Requirement**: Premium SSD v2 disks must be created in the same Azure Availability Zone as the VM.
- **VM Series Compatibility**: Requires modern VM series (e.g., v5 series such as Ebdsv5/Ebsv5 or Dsv5).
