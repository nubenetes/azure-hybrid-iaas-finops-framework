@description('Location for Database Spoke resources')
param location string = resourceGroup().location

@description('Availability Zone for Premium SSD v2')
param zone string = '1'

@description('Hub VNet Resource ID for peering')
param hubVnetId string

@description('Administrator username')
param adminUsername string = 'sqladmin'

@description('Administrator password')
@secure()
param adminPassword string

@description('Tags for resources')
param tags object = {}

resource spokeDbVnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: 'vnet-spoke-db-prod'
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.2.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-database-tier'
        properties: {
          addressPrefix: '10.2.1.0/24'
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
            }
            {
              service: 'Microsoft.KeyVault'
            }
          ]
        }
      }
    ]
  }
}

resource peerDbToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  parent: spokeDbVnet
  name: 'peer-spoke-db-to-hub'
  properties: {
    remoteVirtualNetwork: {
      id: hubVnetId
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
  }
}

resource sqlNic 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: 'nic-sql-prod-01'
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig-sql'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', spokeDbVnet.name, 'snet-database-tier')
          }
        }
      }
    ]
  }
}

// FinOps Decoupled Storage: Premium SSD v2 Data Disk
// 512 GiB capacity, 13,500 IOPS, 250 MB/s throughput
resource sqlDataDiskV2 'Microsoft.Compute/disks@2023-04-02' = {
  name: 'disk-sql-data-v2'
  location: location
  zones: [
    zone
  ]
  tags: tags
  sku: {
    name: 'PremiumV2_LRS'
  }
  properties: {
    creationData: {
      createOption: 'Empty'
    }
    diskSizeGB: 512
    diskIOPSReadWrite: 13500
    diskMBpsReadWrite: 250
  }
}

// FinOps Constrained vCPU Size: Standard_E32-8s_v5
// 256 GiB RAM, 80,000 IOPS, but only 8 cores licensed -> Saves 75% on SQL Enterprise licensing!
resource sqlVm 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: 'vm-sql-prod-01'
  location: location
  zones: [
    zone
  ]
  tags: tags
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_E32-8s_v5'
    }
    // FinOps: Azure Hybrid Benefit for Windows Server
    licenseType: 'Windows_Server'
    osProfile: {
      computerName: 'sql-prod-01'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftSQLServer'
        offer: 'sql2022-ws2022'
        sku: 'enterprise-gen2'
        version: 'latest'
      }
      osDisk: {
        name: 'osdisk-sql-prod-01'
        caching: 'ReadWrite'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      dataDisks: [
        {
          lun: 10
          name: sqlDataDiskV2.name
          createOption: 'Attach'
          caching: 'None' // Premium SSD v2 requires caching None
          managedDisk: {
            id: sqlDataDiskV2.id
          }
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: sqlNic.id
        }
      ]
    }
  }
}

output spokeDbVnetId string = spokeDbVnet.id
output sqlVmId string = sqlVm.id
output sqlVmPrivateIp string = sqlNic.properties.ipConfigurations[0].properties.privateIPAddress
