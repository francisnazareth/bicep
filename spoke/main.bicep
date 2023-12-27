targetScope = 'subscription'

param spokeRGName string 
param location string
param tagValues object

param vnetName string
param vnetAddressPrefix string
param aksSubnetName string
param aksSubnetAddressPrefix string
param peSubnetName string
param peSubnetAddressPrefix string
param aksRouteTableName string
param firewallPrivateIP string
param aksManagedIdentityName string

resource spokeRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: spokeRGName
  location: location
  tags: tagValues
}
module managedIdentity './modules/managedIdentity/managedIdentity.bicep' = {
  name: 'managedIdentity'
  scope: spokeRG
  params: {
    tagValues: tagValues
    location: location
    aksManagedIdentityName: aksManagedIdentityName
  }
}
module aksRouteTable './modules/routeTable/routeTable.bicep' = {
  name: 'routeTable'
  scope: spokeRG
  params: {
    tagValues: tagValues
    location: location
    routeTableName: aksRouteTableName
    firewallPrivateIP: firewallPrivateIP
  }
}
module vnet './modules/vnet/vnet.bicep' = {
  name: 'vnet'
  scope: spokeRG
  dependsOn: [
    aksRouteTable
    managedIdentity
  ]
  params: {
    tagValues: tagValues
    location: location
    vnetName: vnetName
    vnetAddressPrefix: vnetAddressPrefix
    aksSubnetName: aksSubnetName
    aksSubnetAddressPrefix: aksSubnetAddressPrefix
    peSubnetName: peSubnetName
    peSubnetAddressPrefix: peSubnetAddressPrefix
    aksRouteTableID: aksRouteTable.outputs.routeTableId
    aksManagedIdentityID: managedIdentity.outputs.aksManagedIdentityResourceID
    aksManagedIdentityPrincipalID: managedIdentity.outputs.aksManagedIdentityPrincipalID
  }
}

module aks './modules/aks/aks.bicep' = {
  name: 'aks'
  scope: spokeRG
  dependsOn: [
    vnet
    managedIdentity
  ]
  params: {
    tagValues: tagValues
    aksManagedIdentityID: managedIdentity.outputs.aksManagedIdentityResourceID
    aksManagedIdentityPrincipalID: managedIdentity.outputs.aksManagedIdentityPrincipalID
    location: location
    aksSubnetID: vnet.outputs.aksSubnetID
  }
}
