param vnetName string
param vnetAddressPrefix string
param location string = resourceGroup().location
param aksSubnetName string
param aksSubnetAddressPrefix string
param aksAPISubnetName string
param aksAPISubnetAddressPrefix string
param mysqlSubnetName string 
param mysqlSubnetAddressPrefix string
param vmSubnetName string
param vmSubnetAddressPrefix string 
param peSubnetName string
param peSubnetAddressPrefix string
param tagValues object
param aksRouteTableID string
param aksManagedIdentityID string
param aksManagedIdentityPrincipalID string


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
        name: aksSubnetName
        properties: {
          addressPrefix: aksSubnetAddressPrefix
          routeTable: {
            id: aksRouteTableID
          }
        }
      }
      {
        name: aksAPISubnetName
        properties: {
          addressPrefix: aksAPISubnetAddressPrefix
        }
      }
      {
        name: peSubnetName
        properties: {
          addressPrefix: peSubnetAddressPrefix
        }
      }
      {
        name: mysqlSubnetName
        properties: {
          addressPrefix: mysqlSubnetAddressPrefix
        }
      }
      {
        name: vmSubnetName
        properties: {
          addressPrefix: vmSubnetAddressPrefix
        }
      }
    ]
  }

  resource aksSubnet 'subnets' existing = {
      name: aksSubnetName
  }

  resource peSubnet 'subnets' existing = {
      name: peSubnetName
  }

  resource aksApiSubnet 'subnets' existing = {
    name: aksAPISubnetName
  }

  resource mySQLSubnet 'subnets' existing = {
    name: mysqlSubnetName
  }

  resource vmSubnet 'subnets' existing = {
    name: vmSubnetName
  }
}

output vnetId string = vnet.id
output aksSubnetID string = vnet::aksSubnet.id
output peSubnetID string = vnet::peSubnet.id
output aksAPISubnetID string = vnet::aksApiSubnet.id
output mySQLSubnetID string = vnet::mySQLSubnet.id
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
