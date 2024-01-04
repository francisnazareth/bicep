param tagValues object 
param aksManagedIdentityID string
param aksManagedIdentityPrincipalID string
param hubVNETID string
param spokeVNETID string 

resource aksPrivateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.qatarcentral.azmk8s.io'
  location: 'global'
  tags: tagValues
}

resource mysqlPrivateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.mysql.database.azure.com'
  location: 'global'
  tags: tagValues
}

resource acrPrivateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.azurecr.io'
  location: 'global'
  tags: tagValues
}

resource mongodbPrivateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.mongo.cosmos.azure.com'
  location: 'global'
  tags: tagValues
}

resource redisPrivateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.redis.cache.windows.net'
  location: 'global'
  tags: tagValues
}

resource blobPrivateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.blob.core.windows.net'
  location: 'global'
  tags: tagValues
}

resource aksHubPrivateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: aksPrivateDNSZone
  name: 'aks-privatednszone-hub-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: hubVNETID
    }
  }
}

resource aksSpokePrivateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: aksPrivateDNSZone
  name: 'aks-privatednszone-prod-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: spokeVNETID
    }
  }
}

resource mysqlHubPrivateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: mysqlPrivateDNSZone
  name: 'mysql-privatednszone-hub-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: hubVNETID
    }
  }
}

resource mysqlSpokePrivateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: mysqlPrivateDNSZone
  name: 'mysql-privatednszone-prod-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: spokeVNETID
    }
  }
}

resource acrHubPrivateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: acrPrivateDNSZone
  name: 'acr-privatednszone-hub-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: hubVNETID
    }
  }
}

resource acrSpokePrivateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: acrPrivateDNSZone
  name: 'acr-privatednszone-prod-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: spokeVNETID
    }
  }
}

resource mongodbHubPrivateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: mongodbPrivateDNSZone
  name: 'mongodb-privatednszone-hub-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: hubVNETID
    }
  }
}

resource mongodbSpokePrivateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: mongodbPrivateDNSZone
  name: 'mongodb-privatednszone-prod-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: spokeVNETID
    }
  }
}

resource redisHubPrivateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: redisPrivateDNSZone
  name: 'redis-privatednszone-hub-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: hubVNETID
    }
  }
}

resource redisSpokePrivateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: redisPrivateDNSZone
  name: 'redis-privatednszone-prod-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: spokeVNETID
    }
  }
}

resource blobHubPrivateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: blobPrivateDNSZone
  name: 'blob-privatednszone-hub-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: hubVNETID
    }
  }
}

resource blobSpokePrivateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: blobPrivateDNSZone
  name: 'blob-privatednszone-prod-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: spokeVNETID
    }
  }
}

output aksPrivateDNSZoneID string = aksPrivateDNSZone.id
output mysqlPrivateDNSZoneID string = mysqlPrivateDNSZone.id
output acrPrivateDNSZoneID string = acrPrivateDNSZone.id
output mongodbPrivateDNSZoneID string = mongodbPrivateDNSZone.id
output redisPrivateDNSZoneID string = redisPrivateDNSZone.id
output blobPrivateDNSZoneID string = blobPrivateDNSZone.id

resource contributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: resourceGroup()
  name: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
}

resource privateDNSZoneContributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: resourceGroup()
  name: 'b12aa53e-6015-4669-85d0-8515ebb3ae7f'
}

resource rgContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, aksManagedIdentityID, contributorRoleDefinition.id)
  scope: resourceGroup()
  properties: {
    roleDefinitionId: contributorRoleDefinition.id
    principalId: aksManagedIdentityPrincipalID
    principalType: 'ServicePrincipal'
  }
}

resource privateDNSZoneContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, aksManagedIdentityID, privateDNSZoneContributorRoleDefinition.id)
  scope: aksPrivateDNSZone
  properties: {
    roleDefinitionId: privateDNSZoneContributorRoleDefinition.id
    principalId: aksManagedIdentityPrincipalID
    principalType: 'ServicePrincipal'
  }
}
