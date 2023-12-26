param aksManagedIdentityName string
param location string
param tagValues object

resource aksManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: aksManagedIdentityName
  location: location
  tags: tagValues
}

output aksManagedIdentityResourceId string = aksManagedIdentity.id

resource privateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.qatarcentral.azmk8s.io'
  location: 'global'
  tags: tagValues
}

