param location string = resourceGroup().location

module vnet './modules/vnet/vnet.bicep' = {
  name: 'vnet'
  params: {
    vnetName: 'vnet'
    location: location
    vnetAddressPrefix: '10.0.0.0/22'
    fwSubnetAddressPrefix: '10.0.0.0/26'
    bastionSubnetAddressPrefix: '10.0.0.64/26'
    appGwSubnetName: 'snet-agw-hub-qc-01'
    appGwSubnetAddressPrefix: '10.0.0.128/27'
  }
}
