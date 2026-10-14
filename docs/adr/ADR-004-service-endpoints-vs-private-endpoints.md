# ADR-004: Standardizing on Service Endpoints vs. Private Endpoints for PaaS Traffic

## Status
Accepted

## Context
Spoke workloads (IIS web servers and SQL Server VMs) frequently interact with Azure PaaS satellite services, such as Azure Blob Storage (for database automated backups and static media) and Azure Key Vault (for SSL certificates and encrypted database connection strings).
Securing this traffic from the spoke VNet can be accomplished using:
1. **Virtual Network Service Endpoints**: Directs traffic across the Microsoft Azure backbone without leaving the Azure network. PaaS resource retains public IP, but access is restricted to the specific VNet/Subnet. **Cost: 100% Free**.
2. **Azure Private Endpoints (Private Link)**: Provisions a private IP from the customer subnet for each PaaS resource. Isolates traffic from public internet routing, allows on-premises access across ExpressRoute. **Cost: ~$7.30/month per endpoint + $0.01/GB data processing + Azure Private DNS Zone fees**.

Deploying Private Endpoints indiscriminately across dozens of spoke subnets introduces significant micro-billing costs and substantial DNS complexity (split-horizon CNAME overrides and on-prem conditional forwarders).

## Decision
1. **Default Standard**: Use **Service Endpoints** for all VNet-to-Azure-PaaS communications originating from within Azure VNets (e.g., IIS to Blob, SQL to Blob, IIS to Key Vault).
2. **Exception Criteria for Private Endpoints**: Private Endpoints are strictly reserved for:
   - Scenarios requiring direct on-premises access to the Azure PaaS service across ExpressRoute or Site-to-Site VPN.
   - Strict regulatory or compliance mandates (such as PCI-DSS Level 1 or government security profiles) that contractually forbid public IP exposure on the PaaS service.

## Consequences
### Positive
- **Zero Cost Overhead**: Avoids hourly endpoint charges, per-GB private link transit fees, and auxiliary private DNS zone costs.
- **DNS Simplicity**: Avoids DNS split-brain issues with local corporate Active Directory domain controllers.
- **Full Microsoft Backbone Routing**: Traffic remains encrypted and internal to Microsoft’s global network infrastructure.

### Negative / Trade-offs
- On-premises hosts cannot access the PaaS service via Service Endpoints (must use internet with IP firewall rules or deploy dedicated Private Endpoints for hybrid access).
