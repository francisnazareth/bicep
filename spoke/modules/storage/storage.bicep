param location string 
param tagValues object
param storageAccountName string
param peSubnetID string 

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  location: location
  tags: tagValues
  name: storageAccountName
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'None'
      defaultAction: 'Deny'
      ipRules: []
      virtualNetworkRules: []
    }
    supportsHttpsTrafficOnly: true
  }
} 

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: 'pe-${storageAccountName}'
  location: location
  properties: {
    subnet: {
      id: peSubnetID
    }
    privateLinkServiceConnections: [
      {
        name: 'pe-${storageAccountName}'
        properties: {
          privateLinkServiceId: storageAccount.id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
}
