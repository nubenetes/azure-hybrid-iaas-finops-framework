# ADR-003: Default Selection of Metered Data Plan for Hybrid Azure ExpressRoute Circuits

## Status
Accepted

## Context
When connecting on-premises enterprise data centers to the Azure Hub VNet via Azure ExpressRoute, cloud architects must choose between the **Metered Data Plan** and the **Unlimited Data Plan**.
Risk-averse IT governance boards frequently default to Unlimited to prevent unexpected consumption invoices.
However, for a 1 Gbps circuit in Zone 1, the Unlimited port charges **$6,450/month**, whereas the Metered port costs **$436/month** plus **$0.025/GB** for outbound data.

Mathematical modeling shows that the break-even volume for a 1 Gbps circuit is **240.6 TB/month**, representing **73.2% continuous 24/7 link saturation**. Our empirical hybrid traffic (Active Directory password hash synchronization, periodic RDP administration, domain replication, and batch database extracts) averages between 4 TB and 12 TB monthly.

Furthermore, Azure allows non-disruptive, in-place upgrades from Metered to Unlimited, but **strictly blocks in-place downgrades from Unlimited to Metered**, which requires circuit teardown, telecom re-provisioning, and scheduled downtime.

## Decision
1. All new hybrid ExpressRoute circuits will be provisioned under the **Metered Data Plan**.
2. Azure Monitor alerts will monitor 30-day cumulative egress volume at 50%, 75%, and 90% of the mathematical break-even threshold ($E_{\text{break-even}}$).
3. Any migration to Unlimited requires demonstrated empirical traffic exceeding $E_{\text{break-even}}$ for three consecutive billing cycles.

## Consequences
### Positive
- **Instant Cost Avoidance**: Saves approximately **$5,700 to $6,000 per month per 1 Gbps circuit** (~$70,000/year).
- **Safe Evolutionary Path**: If traffic surges unexpectedly, upgrading to Unlimited takes 5 minutes via the Azure Portal with zero downtime.

### Negative / Trade-offs
- Monthly networking expenditure contains a variable component proportional to monthly egress volume.
