
param tagValues object 
param aksManagedIdentityID string
param aksManagedIdentityPrincipalID string

resource aksPrivateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.qatarcentral.azmk8s.io'
  location: 'global'
  tags: tagValues
}

output aksPrivateDNSZoneID string = aksPrivateDNSZone.id

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
