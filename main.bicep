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
