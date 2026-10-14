# ADR-005: Adoption of Azure Monitor Agent (AMA) with DCR Edge XPath Filtering

## Status
Accepted

## Context
Deploying default monitoring extensions across dozens of high-traffic Windows Server IIS VMs generates tens of gigabytes of raw W3C web server access logs and Windows Event logs daily.
Log Analytics charges **~$2.30 per GB** for raw data ingestion, plus retention fees beyond 30 days.
Under legacy monitoring architectures (Log Analytics Agent / MMA), all logs were piped uninhibited into the central workspace. This caused the "Runaway Telemetry Syndrome", where the monthly Log Analytics ingestion bill exceeded the compute cost of the virtual machines generating the logs.

## Decision
1. Mandate the migration to **Azure Monitor Agent (AMA)** across all virtual machines and VMSS instances.
2. Deploy centralized **Data Collection Rules (DCR)** enforcing edge filtering inside the guest OS kernel using XPath queries:
   - **IIS Logs**: Drop all HTTP 200, 301, and 302 requests; ingest only anomalies (HTTP >= 400), failed requests, and requests with server latency `time-taken > 3000ms`.
   - **Windows Security Logs**: Ingest strictly high-value audit events (Event ID 4625 failed logons, 4672 privilege use, 4720 account creations); discard high-frequency process execution chatter (Event ID 4688).
   - **Performance Counters**: Tune collection interval to 60 or 300 seconds on non-critical nodes.
3. Configure the **Basic Table Plan** on Log Analytics for high-volume operational and network logs, achieving >80% ingestion cost reduction.

## Consequences
### Positive
- **60% to 75% Reduction in Ingestion Invoices**: Filters ephemeral white noise at the edge before crossing into the Azure PaaS billing boundary.
- **Improved KQL Query Performance**: Workspaces remain free of junk data, accelerating security investigation queries.
- **Compliance Retained**: All forensic-grade security alerts and application error traces remain intact.

### Negative / Trade-offs
- Granular analytics for routine 200 OK traffic must rely on client-side analytics (e.g. Application Insights / Google Analytics) rather than raw server W3C logs.
