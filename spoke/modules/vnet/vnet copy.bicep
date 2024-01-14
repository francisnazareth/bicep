param vnetName string
param vnetAddressPrefix string
param location string = resourceGroup().location
param aksSuperAppSubnetName string
param aksSuperAppSubnetAddressPrefix string
param aksMiniAppSubnetName string
param aksMiniAppSubnetAddressPrefix string
param aksSuperAppAPISubnetName string
param aksSuperAppAPISubnetAddressPrefix string
param aksMiniAppAPISubnetName string
param aksMiniAppAPISubnetAddressPrefix string
param mysqlSuperAppSubnetName string 
param mysqlSuperAppSubnetAddressPrefix string
param mysqlMiniAppSubnetName string
param mysqlMiniAppSubnetAddressPrefix string
param vmSubnetName string
param vmSubnetAddressPrefix string 
param peSubnetName string
param peSubnetAddressPrefix string
param tagValues object
param aksRouteTableID string
param aksManagedIdentityID string
param aksManagedIdentityPrincipalID string
param vmNSGName string

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2022-05-01' = {
  name: vmNSGName
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-3389'
        properties: {
          priority: 1000
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '3389'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnetName
  location: location
  tags: tagValues
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: aksSuperAppSubnetName
        properties: {
          addressPrefix: aksSuperAppSubnetAddressPrefix
          routeTable: {
            id: aksRouteTableID
          }
        }
      }
      {
        name: aksMiniAppSubnetName
        properties: {
          addressPrefix: aksMiniAppSubnetAddressPrefix
          routeTable: {
            id: aksRouteTableID
          }
        }
      }
      {
        name: peSubnetName
        properties: {
          addressPrefix: peSubnetAddressPrefix
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
      {
        name: vmSubnetName
        properties: {
          addressPrefix: vmSubnetAddressPrefix
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
          routeTable: {
            id: aksRouteTableID
          }
        }
      }
      {
        name: aksSuperAppAPISubnetName
        properties: {
          addressPrefix: aksSuperAppAPISubnetAddressPrefix
          delegations: [
            {
              name: 'ManagedClusters'
              properties: {
                serviceName: 'Microsoft.ContainerService/managedClusters'
              }
            }
          ]
        }
      }
      {
        name: aksMiniAppAPISubnetName
        properties: {
          addressPrefix: aksMiniAppAPISubnetAddressPrefix
          delegations: [
            {
              name: 'ManagedClusters'
              properties: {
                serviceName: 'Microsoft.ContainerService/managedClusters'
              }
            }
          ]
        }
      }
      {
        name: mysqlSuperAppSubnetName
        properties: {
          addressPrefix: mysqlSuperAppSubnetAddressPrefix
          delegations: [
            {
              name: 'MySQLflexibleServers'
              properties: {
                serviceName: 'Microsoft.DBforMySQL/flexibleServers'
              }
            }
          ]
        }
      }
      {
        name: mysqlMiniAppSubnetName
        properties: {
          addressPrefix: mysqlMiniAppSubnetAddressPrefix
          delegations: [
            {
              name: 'MySQLflexibleServers'
              properties: {
                serviceName: 'Microsoft.DBforMySQL/flexibleServers'
              }
            }
          ]
        }
      }
    ]
  }
  resource aksSuperAppSubnet 'subnets' existing = {
    name: aksSuperAppSubnetName
  }

  resource peSubnet 'subnets' existing = {
    name: peSubnetName
  }

  resource aksMiniAppSubnet 'subnets' existing = {
    name: aksMiniAppSubnetName
  }

  resource vmSubnet 'subnets' existing = {
    name: vmSubnetName
  }

  resource aksMiniAppAPISubnet 'subnets' existing = {
    name: aksMiniAppAPISubnetName
  }

  resource aksSuperAppAPISubnet 'subnets' existing = {
    name: aksSuperAppAPISubnetName
  }

  resource mysqlSuperAppSubnet 'subnets' existing = {
    name: mysqlSuperAppSubnetName
  }

  resource mysqlMiniAppSubnet 'subnets' existing = {
    name: mysqlMiniAppSubnetName
  }

}

output vnetId string = vnet.id
output aksSuperAppSubnetID string = vnet::aksSuperAppSubnet.id
output peSubnetID string = vnet::peSubnet.id
output aksSuperAppAPISubnetID string = vnet::aksSuperAppAPISubnet.id
output aksMiniAppSubnetID string = vnet::aksMiniAppSubnet.id
output aksMiniAppAPISubnetID string = vnet::aksMiniAppAPISubnet.id
output mysqlSuperAppSubnetID string = vnet::mysqlSuperAppSubnet.id
output mysqlMiniAppSubnetID string = vnet::mysqlMiniAppSubnet.id
output vmSubnetID string = vnet::vmSubnet.id

resource networkContributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: resourceGroup()
  name: '4d97b98b-1d4f-4787-a291-c67834d212e7'
}

resource vnetContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, aksManagedIdentityID, networkContributorRoleDefinition.id)
  scope: vnet
  properties: {
    roleDefinitionId: networkContributorRoleDefinition.id
    principalId: aksManagedIdentityPrincipalID
    principalType: 'ServicePrincipal'
  }
}
