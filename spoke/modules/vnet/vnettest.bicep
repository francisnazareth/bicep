param location string = 'westeurope'

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'vnet-test-we-01'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.130.0.0/22'
      ]
    }

    subnets: [
      {
        name: 'snet-aks-superapp-01'
        properties: {
          addressPrefix: '10.130.0.0/24'
        }
      }
      {
        name: 'snet-aks-superapp-api-01'
        properties: {
          addressPrefix: '10.130.1.0/27'
          delegations: [
            {
              name: 'snet-aks-superapp-api-01-delegation'
              properties: {
                serviceName: 'Microsoft.ContainerService/managedClusters'
              }
            }
          ]

        }
      }
      {
        name: 'snet-aks-miniapp-01'
        properties: {
          addressPrefix: '10.130.2.0/24'
        }
      }
      {
        name: 'snet-aks-miniapp-api-01'
        properties: {
          addressPrefix: '10.130.1.32/27'
          delegations: [
            {
              name: 'snet-aks-miniapp-api-01-delegation'
              properties: {
                serviceName: 'Microsoft.ContainerService/managedClusters'
              }
            }
          ]

        }
      }
      {
        name: 'snet-pe-01'
        properties: {
          addressPrefix: '10.130.1.64/27'
        }
      }
      {
        name: 'snet-superapp-mysql-01'
        properties: {
          addressPrefix: '10.130.1.96/27'
          delegations: [
            {
              name: 'snet-superapp-mysql-01-delegation'
              properties: {
                serviceName: 'Microsoft.DBforMySQL/flexibleservers'
              }
            }
          ]
        }
      }
      {
        name: 'snet-miniapp-mysql-01'
        properties: {
          addressPrefix: '10.130.1.128/27'
          delegations: [
            {
              name: 'snet-miniapp-mysql-01-delegation'
              properties: {
                serviceName: 'Microsoft.DBforMySQL/flexibleservers'
              }
            }
          ]
        }
      }
      {
        name: 'snet-vm-01'
        properties: {
          addressPrefix: '10.130.1.160/27'
        }
      }
    ]
  }
}
