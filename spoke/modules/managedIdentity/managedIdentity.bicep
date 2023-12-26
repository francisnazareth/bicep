param aksManagedIdentityName string
param location string
param tagValues object

resource aksManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: aksManagedIdentityName
  location: location
  tags: tagValues
}

output aksManagedIdentityResourceID string = aksManagedIdentity.id
output aksManagedIdentityPrincipalID string = aksManagedIdentity.properties.principalId
