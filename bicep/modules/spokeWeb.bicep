@description('Location for Web Spoke resources')
param location string = resourceGroup().location

@description('Hub VNet Resource ID for peering')
param hubVnetId string

@description('Administrator username')
param adminUsername string = 'azureadmin'

@description('Administrator password')
@secure()
param adminPassword string

@description('Tags for resources')
param tags object = {}

resource spokeWebVnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: 'vnet-spoke-web-prod'
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-web-tier'
        properties: {
          addressPrefix: '10.1.1.0/24'
          // FinOps: Service Endpoints are 100% free ($0.00/hr, $0.00/GB)
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

resource peerSpokeToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  parent: spokeWebVnet
  name: 'peer-spoke-web-to-hub'
  properties: {
    remoteVirtualNetwork: {
      id: hubVnetId
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
  }
}

resource vmssIis 'Microsoft.Compute/virtualMachineScaleSets@2023-09-01' = {
  name: 'vmss-iis-web'
  location: location
  tags: tags
  sku: {
    name: 'Standard_D2s_v5'
    tier: 'Standard'
    capacity: 3
  }
  properties: {
    overprovision: false
    upgradePolicy: {
      mode: 'Manual'
    }
    virtualMachineProfile: {
      // FinOps: Azure Hybrid Benefit eliminates ~36% Windows OS license surcharge
      licenseType: 'Windows_Server'
      osProfile: {
        computerNamePrefix: 'iis'
        adminUsername: adminUsername
        adminPassword: adminPassword
      }
      storageProfile: {
        imageReference: {
          publisher: 'MicrosoftWindowsServer'
          offer: 'WindowsServer'
          sku: '2022-datacenter-azure-edition'
          version: 'latest'
        }
        osDisk: {
          createOption: 'FromImage'
          caching: 'ReadWrite'
          managedDisk: {
            storageAccountType: 'StandardSSD_LRS'
          }
        }
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: 'nic-iis-web'
            properties: {
              primary: true
              ipConfigurations: [
                {
                  name: 'ipconfig-iis'
                  properties: {
                    subnet: {
                      id: resourceId('Microsoft.Network/virtualNetworks/subnets', spokeWebVnet.name, 'snet-web-tier')
                    }
                  }
                }
              ]
            }
          }
        ]
      }
      priority: 'Spot'
      evictionPolicy: 'Deallocate'
    }
  }
}

output spokeWebVnetId string = spokeWebVnet.id
output vmssId string = vmssIis.id
