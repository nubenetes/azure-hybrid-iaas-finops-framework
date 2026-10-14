targetScope = 'resourceGroup'

@description('Deployment region')
param location string = resourceGroup().location

@description('Azure Firewall SKU Tier: Basic or Standard')
param firewallSkuTier string = 'Standard'

@description('Administrator username')
param adminUsername string = 'finopsadmin'

@description('Administrator password')
@secure()
param adminPassword string

@description('FinOps Core Tags')
param tags object = {
  CostCenter: 'CC-FIN-4010'
  Department: 'Platform-Engineering'
  Environment: 'Production'
  Owner: 'finops-lead@company.com'
  Workload: 'Hybrid-IaaS-Reference'
  SharedService: 'false'
}

// 1. Hub Network
module hub './modules/hubNetwork.bicep' = {
  name: 'hubNetworkDeploy'
  params: {
    location: location
    firewallSkuTier: firewallSkuTier
    tags: union(tags, {
      SharedService: 'true'
      Tier: 'Hub-Security'
    })
  }
}

// 2. Spoke Web Tier
module spokeWeb './modules/spokeWeb.bicep' = {
  name: 'spokeWebDeploy'
  params: {
    location: location
    hubVnetId: hub.outputs.hubVnetId
    adminUsername: adminUsername
    adminPassword: adminPassword
    tags: union(tags, {
      Tier: 'Spoke-Web'
    })
  }
}

// 3. Spoke Database Tier
module spokeDb './modules/spokeDb.bicep' = {
  name: 'spokeDbDeploy'
  params: {
    location: location
    hubVnetId: hub.outputs.hubVnetId
    adminUsername: adminUsername
    adminPassword: adminPassword
    tags: union(tags, {
      Tier: 'Spoke-Database'
    })
  }
}

// 4. Observability Tier (AMA + DCR Edge XPath Filtering)
module observability './modules/dcrRules.bicep' = {
  name: 'observabilityDeploy'
  params: {
    location: location
    tags: union(tags, {
      Tier: 'Shared-Observability'
    })
  }
}

output hubVnetId string = hub.outputs.hubVnetId
output firewallPrivateIp string = hub.outputs.firewallPrivateIp
output spokeWebVnetId string = spokeWeb.outputs.spokeWebVnetId
output spokeDbVnetId string = spokeDb.outputs.spokeDbVnetId
output sqlVmPrivateIp string = spokeDb.outputs.sqlVmPrivateIp
output logAnalyticsWorkspaceId string = observability.outputs.workspaceId
