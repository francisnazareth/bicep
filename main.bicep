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
param bastionName string = 'bastion-hub-qc-01'
param bastionPublicIPName string = 'bastion-hub-qc-01-ip'
param bastionSku string = 'Standard'
param logAnalyticsRetentionInDays int = 60
param logAnalyticsWorkspaceName string = 'hub-qc-01-law'
param logAnalyticsSku string = 'PerGB2018'

module vnet './modules/vnet/vnet.bicep' = {
  name: 'vnet'
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
  }
}

module bastion './modules/bastion/bastion.bicep' = {
  name: 'bastion'
  params: {
    location: location
    vnetName: vnetName
    bastionName: bastionName
    bastionPublicIPName: bastionPublicIPName
    bastionSku: bastionSku
  }
}

module logAnalytics './modules/logAnalytics/logAnalytics.bicep' = {
  name: 'logAnalytics'
  params: {
    location: location
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    logAnalyticsSku: logAnalyticsSku
    logAnalyticsRetentionInDays: logAnalyticsRetentionInDays
  }
}
