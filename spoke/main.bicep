targetScope = 'subscription'

param spokeRGName string 
param location string
param tagValues object

param vnetName string
param vnetAddressPrefix string
param peSubnetName string
param peSubnetAddressPrefix string
param aksRouteTableName string
param firewallPrivateIP string
param aksManagedIdentityName string
param aksSuperAppSubnetName string
param aksSuperAppSubnetAddressPrefix string
param aksSuperAppAPISubnetName string
param aksSuperAppAPISubnetAddressPrefix string
param aksMiniAppSubnetName string
param aksMiniAppSubnetAddressPrefix string
param aksMiniAppAPISubnetName string
param aksMiniAppAPISubnetAddressPrefix string
param agentVMSize string
param aksSuperAppClusterName string 
param aksMiniAppClusterName string 
param logAnalyticsWorkspaceID string 
param acrName string 
param storageAccountName string 
param availabilityZones array 
param mysqlSuperAppSubnetAddressPrefix string
param mysqlSuperAppSubnetName string
param mysqlMiniAppSubnetAddressPrefix string
param mysqlMiniAppSubnetName string
param vmSubnetAddressPrefix string 
param vmSubnetName string 

param mysqlSuperAppServerName string
param mysqlMiniAppServerName string 
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

module privateDNSZones './modules/privateDNSZones/privateDNSZones.bicep' = {
  name: 'privateDNSZones'
  scope: spokeRG
  dependsOn: [
    managedIdentity
  ]
  params: {
    tagValues: tagValues
    aksManagedIdentityID: managedIdentity.outputs.aksManagedIdentityResourceID
    aksManagedIdentityPrincipalID: managedIdentity.outputs.aksManagedIdentityPrincipalID
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
    aksSuperAppSubnetName: aksSuperAppSubnetName
    aksSuperAppSubnetAddressPrefix: aksSuperAppSubnetAddressPrefix
    aksSuperAppAPISubnetName: aksSuperAppAPISubnetName
    aksSuperAppAPISubnetAddressPrefix: aksSuperAppAPISubnetAddressPrefix
    aksMiniAppSubnetName: aksMiniAppSubnetName
    aksMiniAppSubnetAddressPrefix: aksMiniAppSubnetAddressPrefix
    aksMiniAppAPISubnetName: aksMiniAppAPISubnetName
    aksMiniAppAPISubnetAddressPrefix: aksMiniAppAPISubnetAddressPrefix
    peSubnetName: peSubnetName
    peSubnetAddressPrefix: peSubnetAddressPrefix
    aksRouteTableID: aksRouteTable.outputs.routeTableId
    aksManagedIdentityID: managedIdentity.outputs.aksManagedIdentityResourceID
    aksManagedIdentityPrincipalID: managedIdentity.outputs.aksManagedIdentityPrincipalID
    mysqlSuperAppSubnetAddressPrefix: mysqlSuperAppSubnetAddressPrefix
    mysqlSuperAppSubnetName: mysqlSuperAppSubnetName 
    mysqlMiniAppSubnetAddressPrefix: mysqlMiniAppSubnetAddressPrefix
    mysqlMiniAppSubnetName: mysqlMiniAppSubnetName
    vmSubnetAddressPrefix: vmSubnetAddressPrefix
    vmSubnetName: vmSubnetName
  }
}

/*
module superAppAKS './modules/aks/aksSuperApp.bicep' = {
  name: aksSuperAppClusterName
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
    aksAPISubnetID: vnet.outputs.aksSuperAppAPISubnetID
    aksSubnetID: vnet.outputs.aksSuperAppSubnetID
    aksClusterName: aksSuperAppClusterName
    agentVMSize: agentVMSize
    logAnalyticsWorkspaceID: logAnalyticsWorkspaceID
    availabilityZones: availabilityZones
  }
}

module miniAppAKS './modules/aks/aksMiniApp.bicep' = {
  name: aksMiniAppClusterName
  scope: spokeRG
  dependsOn: [
    vnet
    managedIdentity
  ]
  params: {
    tagValues: tagValues
    aksManagedIdentityID: managedIdentity.outputs.aksManagedIdentityResourceID
    location: location
    aksAPISubnetID: vnet.outputs.aksMiniAppAPISubnetID
    aksSubnetID: vnet.outputs.aksMiniAppSubnetID
    aksClusterName: aksMiniAppClusterName
    agentVMSize: agentVMSize
    logAnalyticsWorkspaceID: logAnalyticsWorkspaceID
    availabilityZones: availabilityZones
    privateDNSZoneID: superAppAKS.outputs.privateDNSZoneID
  }
}
*/

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
module mysqlSuperApp './modules/mysql/mysql.bicep' = {
  name: 'mysql-superapp'
  scope: spokeRG
  params: {
    tagValues: tagValues
    location: location
    serverName: mysqlSuperAppServerName
    administratorLogin: mysqlAdminUsername
    administratorLoginPassword: mysqlAdminPassword
    skuName: mysqlSKU
  }
}

module mysqlMiniApp './modules/mysql/mysql.bicep' = {
  name: 'mysql-miniapp'
  scope: spokeRG
  params: {
    tagValues: tagValues
    location: location
    serverName: mysqlMiniAppServerName
    administratorLogin: mysqlAdminUsername
    administratorLoginPassword: mysqlAdminPassword
    skuName: mysqlSKU
  }
}
