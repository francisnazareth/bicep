@minLength(5)
@maxLength(50)
@description('Provide a globally unique name of your Azure Container Registry')
param acrName string 
param tagValues object 
param peSubnetID string 
@description('Provide a location for the registry.')
param location string = resourceGroup().location

@description('Provide a tier of your Azure Container Registry.')
param acrSku string = 'Premium'

resource acrResource 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: acrName
  tags: tagValues
  location: location
  sku: {
    name: acrSku
  }
  properties: {
    adminUserEnabled: false
    publicNetworkAccess: 'Disabled'
  }
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: 'pe-${acrName}'
  location: location
  properties: {
    subnet: {
      id: peSubnetID
    }
    privateLinkServiceConnections: [
      {
        name: 'pe-${acrName}'
        properties: {
          privateLinkServiceId: acrResource.id
          groupIds: [
            'registry'
          ]
        }
      }
    ]
  }
}

@description('Output the login server property for later use')
output loginServer string = acrResource.properties.loginServer
