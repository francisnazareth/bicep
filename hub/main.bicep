targetScope = 'subscription'

param location string = 'qatarcentral'
param vnetName string
param vnetAddressPrefix string
param fwSubnetAddressPrefix string
param bastionSubnetAddressPrefix string
param vpnSubnetAddressPrefix string
param appGwSubnetName string
param appGwSubnetAddressPrefix string
param managementSubnetName string
param managementSubnetAddressPrefix string
param sharedServicesSubnetName string
param sharedServicesSubnetAddressPrefix string
param bastionName string 
param bastionPublicIPName string 
param bastionSku string
param logAnalyticsRetentionInDays int 
param logAnalyticsWorkspaceName string 
param logAnalyticsSku string
param ddosProtectionPlanName string 
@description('Enable DDoS protection plan.')
param ddosProtectionPlanEnabled bool 
param firewallPublicIPName string 
param firewallPolicyName string 
param firewallName string 
param availabilityZones array 
param vmName string
param vmSize string
param adminUsername string
@secure()
param adminPassword string
param tagValues object
param backupRGName string 
param managementRGName string 
param monitoringRGName string
param networkRGName string
param recoveryServiceVaultName string 
param managedIdentityName string
param keyVaultName string 
param keyVaultSKU string 
param applicationGatewayName string 
param applicationGatewayPublicIPName string 
param appGatewayWAFPolicyName string

resource backupRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: backupRGName
  location: location
  tags: tagValues
}

resource managementRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: managementRGName
  location: location
  tags: tagValues
}

resource monitoringRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: monitoringRGName
  location: location
  tags: tagValues
}

resource networkRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: networkRGName
  location: location
  tags: tagValues
}
module ddosProtectionPlan 'modules/ddos/ddos.bicep' = {
  name: 'ddosProtectionPlan'
  scope: networkRG
  params: {
    location: location
    ddosProtectionPlanName: ddosProtectionPlanName
    tagValues: tagValues
  }
}

module vnet './modules/vnet/vnet.bicep' = {
  name: 'vnet'
  scope: networkRG
  params: {
    vnetName: vnetName
    location: location
    vnetAddressPrefix: vnetAddressPrefix
    fwSubnetAddressPrefix: fwSubnetAddressPrefix
    bastionSubnetAddressPrefix: bastionSubnetAddressPrefix
    vpnSubnetAddressPrefix: vpnSubnetAddressPrefix
    appGwSubnetName: appGwSubnetName
    appGwSubnetAddressPrefix: appGwSubnetAddressPrefix
    managementSubnetName: managementSubnetName
    managementSubnetAddressPrefix: managementSubnetAddressPrefix
    sharedServicesSubnetName: sharedServicesSubnetName
    sharedServicesSubnetAddressPrefix: sharedServicesSubnetAddressPrefix
    ddosProtectionPlanId: ddosProtectionPlan.outputs.ddosProtectionPlanId
    ddosProtectionPlanEnabled: ddosProtectionPlanEnabled
    tagValues: tagValues
  }
}

module bastion './modules/bastion/bastion.bicep' = {
  name: 'bastion'
  scope: managementRG
  params: {
    location: location
    bastionSubnetID: vnet.outputs.bastionSubnetID
    bastionName: bastionName
    bastionPublicIPName: bastionPublicIPName
    bastionSku: bastionSku
    tagValues: tagValues
  }
}

module logAnalytics './modules/logAnalytics/logAnalytics.bicep' = {
  name: 'logAnalytics'
  scope: monitoringRG
  params: {
    location: location
    tagValues: tagValues
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    logAnalyticsSku: logAnalyticsSku
    logAnalyticsRetentionInDays: logAnalyticsRetentionInDays
  }
}

module firewall './modules/firewall/firewall.bicep' = {
  name: 'firewall'
  scope: networkRG
  params: {
    location: location
    tagValues: tagValues
    firewallSubnetID: vnet.outputs.firewallSubnetID
    firewallPublicIPName: firewallPublicIPName
    firewallPolicyName: firewallPolicyName
    firewallName: firewallName
    availabilityZones: availabilityZones
  }
}

module vm './modules/vm/vm.bicep' = {
  name: 'vm'
  scope: managementRG
  params: {
    location: location
    tagValues: tagValues
    managementSubnetID: vnet.outputs.managementSubnetID
    vmName: vmName
    vmSize: vmSize
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}

module recoveryServiceVault './modules/recoveryServiceVault/recoveryServiceVault.bicep' = {
  name: 'recoveryServiceVault'
  scope: backupRG
  params: {
    location: location
    tagValues: tagValues
    vaultName: recoveryServiceVaultName
  }
}

module managedIdentity './modules/managedIdentity/managedIdentity.bicep' = {
  name: 'managedIdentity'
  scope: managementRG
  params: {
    location: location
    tagValues: tagValues
    managedIdentityName: managedIdentityName
  }
}

module keyVault './modules/keyVault/keyVault.bicep' = {
  name: 'keyVault'
  scope: networkRG
  params: {
    location: location
    tagValues: tagValues
    keyVaultName: keyVaultName
    keyVaultSKU: keyVaultSKU
    objectID: managedIdentity.outputs.managedIdentityPrincipalID
  }
}

module applicationGateway './modules/applicationGateway/applicationGateway.bicep' = {
    name: applicationGatewayName
    
    scope: networkRG
    params: {
      location: location 
      tagValues: tagValues
      applicationGatewayName: applicationGatewayName
      appGatewayWAFPolicyName: appGatewayWAFPolicyName
      appGwPublicIPName: applicationGatewayPublicIPName
      appGwSubnetId: vnet.outputs.appGwSubnetID
      availabilityZones: availabilityZones
    }
}
