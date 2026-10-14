using 'main.bicep'

param location = 'westeurope'
param firewallSkuTier = 'Standard'
param adminUsername = 'finopsadmin'
param adminPassword = 'ChangeMe-SuperSecure2026!#'

param tags = {
  CostCenter: 'CC-FIN-4010'
  Department: 'Platform-Engineering'
  Environment: 'Production'
  Owner: 'finops-lead@company.com'
  Workload: 'Hybrid-IaaS-Reference'
  SharedService: 'false'
}
