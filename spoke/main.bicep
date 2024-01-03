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
param superAppStorageAccountName string
param miniAppStorageAccountName string  
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
param superAppRedisCacheName string 
param miniAppRedisCacheName string

/* Create resource group where all assets will be deployed*/

resource spokeRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: spokeRGName
  location: location
  tags: tagValues
}

/* Create user assigned managed identity*/
module managedIdentity './modules/managedIdentity/managedIdentity.bicep' = {
  name: aksManagedIdentityName
  scope: spokeRG
  params: {
    tagValues: tagValues
    location: location
    aksManagedIdentityName: aksManagedIdentityName
  }
}

/*Create necessary private DNS Zones*/
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

/* Route table to be attached to AKS Subnets, to route all outbound traffic to Firewall private IP*/
module aksRouteTable './modules/routeTable/routeTable.bicep' = {
  name: aksRouteTableName
  scope: spokeRG
  params: {
    tagValues: tagValues
    location: location
    routeTableName: aksRouteTableName
    firewallPrivateIP: firewallPrivateIP
  }
}

param vmNSGName string 

/* VNET and necessary subnets */
module vnet './modules/vnet/vnet.bicep' = {
  name: vnetName
  scope: spokeRG
  dependsOn: [
    aksRouteTable
    managedIdentity
  ]
  params: {
    tagValues: tagValues
    location: location
    vnetName: vnetName
    vmNSGName: vmNSGName
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
    location: location
    aksAPISubnetID: vnet.outputs.aksSuperAppAPISubnetID
    aksSubnetID: vnet.outputs.aksSuperAppSubnetID
    aksClusterName: aksSuperAppClusterName
    agentVMSize: agentVMSize
    logAnalyticsWorkspaceID: logAnalyticsWorkspaceID
    availabilityZones: availabilityZones
    privateDNSZoneID: privateDNSZones.outputs.aksPrivateDNSZoneID
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
    privateDNSZoneID: privateDNSZones.outputs.aksPrivateDNSZoneID
  }
}

module acr './modules/acr/acr.bicep' = {
  name: acrName
  scope: spokeRG
  params: {
    tagValues: tagValues
    location: location
    acrName: acrName
  }
}

module superAppStorage './modules/storage/storage.bicep' = {
  name: superAppStorageAccountName
  scope: spokeRG
  params: {
    storageAccountName: superAppStorageAccountName
    tagValues: tagValues
    location: location
  }
}

module miniAppStorage './modules/storage/storage.bicep' = {
  name: miniAppStorageAccountName
  scope: spokeRG
  params: {
    storageAccountName: miniAppStorageAccountName
    tagValues: tagValues
    location: location
  }
}

module mysqlSuperApp './modules/mysql/mysql.bicep' = {
  name: mysqlSuperAppServerName
  scope: spokeRG
  dependsOn:[
    vnet
  ]
  params: {
    tagValues: tagValues
    location: location
    serverName: mysqlSuperAppServerName
    administratorLogin: mysqlAdminUsername
    administratorLoginPassword: mysqlAdminPassword
    skuName: mysqlSKU
    mysqlSubnetID: vnet.outputs.mysqlSuperAppSubnetID
  }
}

module mysqlMiniApp './modules/mysql/mysql.bicep' = {
  name: mysqlMiniAppServerName
  scope: spokeRG
  dependsOn:[
    vnet
  ]
  params: {
    tagValues: tagValues
    location: location
    serverName: mysqlMiniAppServerName
    administratorLogin: mysqlAdminUsername
    administratorLoginPassword: mysqlAdminPassword
    skuName: mysqlSKU
    mysqlSubnetID: vnet.outputs.mysqlMiniAppSubnetID
  }
}

module superAppRedis './modules/redis/redis.bicep' = {
  name: 'superAppRedis'
  scope: spokeRG

  params: {
    tagValues: tagValues
    location: location
    redisCacheName: superAppRedisCacheName
  }
}

module miniAppRedis './modules/redis/redis.bicep' = {
  name: 'miniAppRedis'
  scope: spokeRG

  params: {
    tagValues: tagValues
    location: location
    redisCacheName: miniAppRedisCacheName
  }
}

module mongoDB './modules/mongodb/mongodb.bicep' = {
  name: 'mongoDB'
  scope: spokeRG
  params: {
    tagValues: tagValues
    location: location
    accountName: 'mongosuperapppocqc01'
    databaseName: 'superappdb'
    collection1Name: 'superappcollection1'
    collection2Name: 'superappcollection2'
    primaryRegion: 'qatarcentral'
    secondaryRegion: 'westeurope'
  }
}

@secure()
param vmName string
param vmSize string 
param adminUsername string
@secure()
param adminPassword string

module vm './modules/vm/vm.bicep' = {
  name: 'vm'
  scope: spokeRG
  params: {
    location: location
    tagValues: tagValues
    managementSubnetID: vnet.outputs.vmSubnetID
    vmName: vmName
    vmSize: vmSize
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}
