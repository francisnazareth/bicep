param vnetName string
param vnetAddressPrefix string
param location string = resourceGroup().location
param aksSubnetName string
param aksSubnetAddressPrefix string
param peSubnetName string
param peSubnetAddressPrefix string
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
        name: aksSubnetName
        properties: {
          addressPrefix: aksSubnetAddressPrefix
        }
      }
      {
        name: peSubnetName
        properties: {
          addressPrefix: peSubnetAddressPrefix
        }
      }      
    ]
  }

  resource aksSubnet 'subnets' existing = {
      name: aksSubnetName
  }

  resource peSubnet 'subnets' existing = {
      name: peSubnetName
  }
}

output vnetId string = vnet.id
output aksSubnetID string = vnet::aksSubnet.id
output peSubnetID string = vnet::peSubnet.id
