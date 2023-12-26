param location string = resourceGroup().location
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

targetScope = 'subscription'

resource backupRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-backup-moi-hub-qc-01'
  location: location
  tags: tagValues
}

resource managementRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-management-moi-hub-qc-01'
  location: location
  tags: tagValues
}

resource monitoringRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-monitoring-moi-hub-qc-01'
  location: location
  tags: tagValues
}

resource networkRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-network-moi-hub-qc-01'
  location: location
  tags: tagValues
}

resource securityRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-security-moi-hub-qc-01'
  location: location
  tags: tagValues
}

module ddosProtectionPlan 'modules/ddos/ddos.bicep' = {
  name: 'ddosProtectionPlan'
  scope: securityRG
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
    vnetName: vnetName
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
  scope: securityRG
  params: {
    location: location
    tagValues: tagValues
    vnetName: vnetName
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
    virtualNetworkName: vnetName
    subnetName: managementSubnetName
    vmName: vmName
    vmSize: vmSize
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}
