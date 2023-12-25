param location string = resourceGroup().location

module vnet './modules/vnet/vnet.bicep' = {
  name: 'vnet'
  params: {
    vnetName: 'vnet'
    location: location
    vnetAddressPrefix: '10.0.0.0/22'
    fwSubnetAddressPrefix: '10.0.0.0/26'
    bastionSubnetAddressPrefix: '10.0.0.64/26'
    vpnSubnetAddressPrefix: '10.0.0.128/27'
    appGwSubnetName: 'snet-agw-hub-qc-01'
    appGwSubnetAddressPrefix: '10.0.0.160/27'
    managementSubnetName: 'snet-mgmt-hub-qc-01'
    managementSubnetAddressPrefix: '10.0.0.192/28'
    sharedServicesSubnetName: 'snet-sharedsvc-hub-qc-01'
    sharedServicesSubnetAddressPrefix: '10.0.0.208/28'
  }
}
