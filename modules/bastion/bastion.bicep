param location string
param bastionPublicIPName string
param bastionName string
param vnetName string
param bastionSku string

//create a public IP address for the bastion
resource bastionPublicIpAddress 'Microsoft.Network/publicIPAddresses@2020-08-01' = {
  name: bastionPublicIPName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource bastion 'Microsoft.Network/bastionHosts@2023-04-01' = {
  name: bastionName
  location: location
  sku: {
    name: bastionSku
  }

  properties: {
    disableCopyPaste: false
    enableFileCopy: true
    ipConfigurations: [
      {
        name: 'bastionIpconfig'
        properties: {
          publicIPAddress: {
            id: resourceId('Microsoft.Network/publicIPAddresses', bastionPublicIPName)
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, 'AzureBastionSubnet')
          }
        }
      }
    ]
  }
}
