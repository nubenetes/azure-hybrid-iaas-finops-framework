@description('Location for Observability resources')
param location string = resourceGroup().location

@description('Log Analytics retention in days')
param retentionInDays int = 30

@description('Tags for resources')
param tags object = {}

resource lawWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: 'law-finops-core'
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: retentionInDays
  }
}

// FinOps Edge Filter Data Collection Rule
resource dcrEdgeFilter 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: 'dcr-finops-windows-filtered'
  location: location
  tags: tags
  properties: {
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: lawWorkspace.id
          name: 'law-destination'
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-WindowsEvent'
          'Microsoft-Perf'
        ]
        destinations: [
          'law-destination'
        ]
      }
    ]
    dataSources: {
      windowsEventLogs: [
        {
          streams: [
            'Microsoft-WindowsEvent'
          ]
          name: 'security-filtered-source'
          xPathQueries: [
            'Security!*[System[(EventID=4625 or EventID=4672 or EventID=4720 or EventID=4726 or EventID=4738)]]'
          ]
        }
      ]
      performanceCounters: [
        {
          streams: [
            'Microsoft-Perf'
          ]
          samplingFrequencyInSeconds: 60
          counterSpecifiers: [
            '\\Processor Information(_Total)\\% Processor Time'
            '\\Memory\\Available MBytes'
            '\\PhysicalDisk(_Total)\\Avg. Disk sec/Read'
            '\\PhysicalDisk(_Total)\\Avg. Disk sec/Write'
          ]
          name: 'perf-counter-source'
        }
      ]
    }
  }
}

output workspaceId string = lawWorkspace.id
output dcrId string = dcrEdgeFilter.id
