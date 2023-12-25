using './main.bicep'

param vnetName = 'vnet-hub-qc-01'
param vnetAddressPrefix = '10.0.0.0/22'
param fwSubnetAddressPrefix = '10.0.0.0/26'
param bastionSubnetAddressPrefix = '10.0.0.64/26'
param vpnSubnetAddressPrefix = '10.0.0.128/27'
param appGwSubnetName = 'snet-agw-hub-qc-01'
param appGwSubnetAddressPrefix = '10.0.0.160/27'
param managementSubnetName = 'snet-management-hub-qc-01'
param managementSubnetAddressPrefix = '10.0.0.192/28'
param sharedServicesSubnetName = 'snet-sharedservices-hub-qc-01'
param sharedServicesSubnetAddressPrefix = '10.0.0.208/28'

