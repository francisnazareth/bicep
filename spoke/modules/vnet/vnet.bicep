param vnetName string
param vnetAddressPrefix string
param location string = resourceGroup().location
param aksSubnetName string
param aksSubnetAddressPrefix string
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
        name: peSubnetName
        properties: {
          addressPrefix: peSubnetAddressPrefix
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
}

output vnetId string = vnet.id
output aksSubnetID string = vnet::aksSubnet.id
output peSubnetID string = vnet::peSubnet.id


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
