# ADR-001: Adoption of Constrained vCPU VM Sizes for SQL Server IaaS Workloads

## Status
Accepted

## Context
In our hybrid cloud architecture, database workloads (SQL Server) running on Azure Virtual Machines demand high memory capacity (>= 128-256 GiB RAM) to maintain large in-memory buffer pools, and high disk I/O throughput to sustain transactional transaction log flushes. 
However, query concurrency and processing metrics indicate that these databases rarely exceed 4 to 8 physical execution threads under normal and peak operations.

Under standard Azure pricing, selecting an `Standard_E32s_v5` to satisfy the memory (256 GiB) and storage bandwidth requirements exposes 32 vCPUs to the Guest OS. Microsoft SQL Server licensing models bill on every active vCPU detected by the operating system, resulting in licensing costs exceeding $12,800/month for SQL Server Enterprise edition alone.

## Decision
We adopt **Constrained vCPU virtual machine sizes** (specifically `Standard_E32-8s_v5` and `Standard_E16-4s_v5`) for all IaaS-hosted SQL Server workloads.
The Azure hypervisor will restrict the exposed virtual processors to the guest operating system while maintaining:
1. The full underlying physical memory allocation (256 GiB).
2. The full remote storage bandwidth and IOPS limits (80,000 IOPS / 1,200 MB/s).
3. The full network interface bandwidth limits.

## Consequences
### Positive
- **75% Reduction in SQL Server Software Licensing Fees**: Reduces monthly SQL Enterprise licensing from 32 cores down to 8 cores, saving over $9,600/month per instance.
- **NUMA Scheduler Contention Relief**: Eliminates latch contention and diagnostic warnings on large multi-core virtual NUMA nodes.
- **License Compliance Protection**: Azure bills licensing based on the constrained count, fully certified by Microsoft software licensing audit standards.

### Negative / Trade-offs
- Base compute hardware and un-discounted Windows OS charges remain billed at the underlying 32-core SKU tier.
- If transactional concurrency unexpectedly spikes beyond 8 cores, resizing requires VM restart or moving to a higher constrained tier (`E32-16s_v5`).
