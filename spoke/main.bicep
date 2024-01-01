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
param aksAPISubnetName string
param aksAPISubnetAddressPrefix string
param agentVMSize string
param aksClusterName string 
param aksSystemNodeCount int = 3
param aksSystemNodeMinCount int = 3
param aksSystemNodeMaxCount int = 6
param aksSystemNodepoolMaxPods int = 30
param logAnalyticsWorkspaceID string 
param acrName string 
param storageAccountName string 
param availabilityZones array 
param mysqlSubnetAddressPrefix string
param mysqlSubnetName string
param vmSubnetAddressPrefix string 
param vmSubnetName string 

param mysqlServerName string
param mysqlAdminUsername string
@secure()
@minLength(8)
param mysqlAdminPassword string
param mysqlSKU string 

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
    aksAPISubnetName: aksAPISubnetName
    aksAPISubnetAddressPrefix: aksAPISubnetAddressPrefix
    aksRouteTableID: aksRouteTable.outputs.routeTableId
    aksManagedIdentityID: managedIdentity.outputs.aksManagedIdentityResourceID
    aksManagedIdentityPrincipalID: managedIdentity.outputs.aksManagedIdentityPrincipalID
    mysqlSubnetAddressPrefix: mysqlSubnetAddressPrefix
    mysqlSubnetName: mysqlSubnetName 
    vmSubnetAddressPrefix: vmSubnetAddressPrefix
    vmSubnetName: vmSubnetName
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
    aksAPISubnetID: vnet.outputs.aksAPISubnetID
    aksSubnetID: vnet.outputs.aksSubnetID
    aksClusterName: aksClusterName
    agentVMSize: agentVMSize
    aksSystemNodeCount: aksSystemNodeCount
    aksSystemNodeMinCount: aksSystemNodeMinCount
    aksSystemNodeMaxCount: aksSystemNodeMaxCount
    aksSystemNodepoolMaxPods: aksSystemNodepoolMaxPods
    logAnalyticsWorkspaceID: logAnalyticsWorkspaceID
    availabilityZones: availabilityZones
  }
}

module acr './modules/acr/acr.bicep' = {
  name: 'acr'
  scope: spokeRG
  params: {
    tagValues: tagValues
    location: location
    acrName: acrName
  }
}

module storage './modules/storage/storage.bicep' = {
  name: 'storageAccount'
  scope: spokeRG
  params: {
    storageAccountName: storageAccountName
    tagValues: tagValues
    location: location
  }
}

/*
module mysql './modules/mysql/mysql.bicep' = {
  name: 'mysql'
  scope: spokeRG
  params: {
    tagValues: tagValues
    location: location
    serverName: mysqlServerName
    administratorLogin: mysqlAdminUsername
    administratorLoginPassword: mysqlAdminPassword
    skuName: mysqlSKU
  }
}
*/
