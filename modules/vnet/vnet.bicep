param vnetName string
param vnetAddressPrefix string
param fwSubnetAddressPrefix string
param bastionSubnetAddressPrefix string
param location string = resourceGroup().location
param appGwSubnetName string
param appGwSubnetAddressPrefix string
param vpnSubnetAddressPrefix string
param managementSubnetName string
param managementSubnetAddressPrefix string
param sharedServicesSubnetName string
param sharedServicesSubnetAddressPrefix string
param ddosProtectionPlanId string
param ddosProtectionPlanEnabled bool = true
param tagValues object

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnetName
  location: location
  tags: tagValues
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }

    subnets: [
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: fwSubnetAddressPrefix
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: bastionSubnetAddressPrefix
        }
      }      
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: vpnSubnetAddressPrefix
        }
      }
      {
        name: appGwSubnetName
        properties: {
          addressPrefix: appGwSubnetAddressPrefix
        }
      }
      {
        name: managementSubnetName
        properties: {
          addressPrefix: managementSubnetAddressPrefix
        }
      }
      {
        name: sharedServicesSubnetName
        properties: {
          addressPrefix: sharedServicesSubnetAddressPrefix
        }
      }
    ]

    enableDdosProtection: ddosProtectionPlanEnabled
    ddosProtectionPlan: {
      id: ddosProtectionPlanId
    }
  }
}

output vnetId string = vnet.id
