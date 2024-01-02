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
  }
}


resource aksSuperAppSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  parent: vnet
  name: aksSuperAppSubnetName
  properties: {
    addressPrefix: aksSuperAppSubnetAddressPrefix
    routeTable: {
      id: aksRouteTableID
    }
  }
}


resource aksMiniAppSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  parent: vnet
  name: aksMiniAppSubnetName
  properties: {
    addressPrefix: aksMiniAppSubnetAddressPrefix
    routeTable: {
      id: aksRouteTableID
    }
  }
}

resource peSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  parent: vnet
  name: peSubnetName
  properties: {
    addressPrefix: peSubnetAddressPrefix
  }
}

/*
resource vmSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  parent: vnet
  name: vmSubnetName
  properties: {
    addressPrefix: vmSubnetAddressPrefix
  }
}
*/

resource aksSuperAppAPISubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  parent: vnet
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

resource aksMiniAppAPISubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  parent: vnet
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

resource mysqlSuperAppSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  parent: vnet
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

resource mysqlMiniAppSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  parent: vnet
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

output vnetId string = vnet.id
output aksSuperAppSubnetID string = aksSuperAppSubnet.id
output peSubnetID string = peSubnet.id
output aksSuperAppAPISubnetID string = aksSuperAppAPISubnet.id
output aksMiniAppSubnetID string = aksMiniAppSubnet.id
output aksMiniAppAPISubnetID string = aksMiniAppAPISubnet.id
output mysqlSuperAppSubnetID string = mysqlSuperAppSubnet.id
output mysqlMiniAppSubnetID string = mysqlMiniAppSubnet.id
//output vmSubnetID string = vmSubnet.id

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
