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
        name: aksSuperAppAPISubnetName
        properties: {
          addressPrefix: aksSuperAppAPISubnetAddressPrefix

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
        name: aksMiniAppAPISubnetName
        properties: {
          addressPrefix: aksMiniAppAPISubnetAddressPrefix

        }
      }
      {
        name: peSubnetName
        properties: {
          addressPrefix: peSubnetAddressPrefix
        }
      }
      {
        name: mysqlSuperAppSubnetName
        properties: {
          addressPrefix: mysqlSuperAppSubnetAddressPrefix
        }
      }
      {
        name: mysqlMiniAppSubnetName
        properties: {
          addressPrefix: mysqlMiniAppSubnetAddressPrefix
      
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

  resource aksSuperAppSubnet 'subnets' existing = {
      name: aksSuperAppSubnetName
  }

  resource aksSuperAppApiSubnet 'subnets' existing = {
    name: aksSuperAppAPISubnetName
  } 

  resource aksMiniAppSubnet 'subnets' existing = {
    name: aksMiniAppSubnetName
  }


  resource aksMiniAppApiSubnet 'subnets' existing = {
    name: aksMiniAppAPISubnetName
  }
  

  resource peSubnet 'subnets' existing = {
    name: peSubnetName
  }

  resource mysqlSuperAppSubnet 'subnets' existing = {
    name: mysqlSuperAppSubnetName
  }

  resource mysqlMiniAppSubnet 'subnets' existing = {
    name: mysqlMiniAppSubnetName
  }

  resource vmSubnet 'subnets' existing = {
    name: vmSubnetName
  }
}

output vnetId string = vnet.id
output aksSuperAppSubnetID string = vnet::aksSuperAppSubnet.id
output peSubnetID string = vnet::peSubnet.id
output aksSuperAppAPISubnetID string = vnet::aksSuperAppApiSubnet.id
output aksMiniAppSubnetID string = vnet::aksMiniAppSubnet.id
output aksMiniAppAPISubnetID string = vnet::aksMiniAppApiSubnet.id
output mysqlSuperAppSubnetID string = vnet::mysqlSuperAppSubnet.id
output mysqlMiniAppSubnetID string = vnet::mysqlMiniAppSubnet.id
output vmSubnetID string = vnet::vmSubnet.id
output vnet object = vnet

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
