@description('Server Name for Azure database for MySQL')
param serverName string

//param peSubnetID string

param tagValues object
@description('Database administrator login name')
@minLength(1)
param administratorLogin string

@description('Database administrator password')
@minLength(8)
@secure()
param administratorLoginPassword string

@description('Azure database for MySQL sku name ')
param skuName string 

param mysqlSubnetID string 

@description('Azure database for MySQL pricing tier')
@allowed([
  'Basic'
  'GeneralPurpose'
  'MemoryOptimized'
])
param SkuTier string = 'GeneralPurpose'

@description('Provide Server version')
@allowed([
  '5.7'
  '8.0.21'
])
param serverVersion string = '8.0.21'

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Provide the availability zone information of the server. (Leave blank for No Preference).')
param availabilityZone string = '1'

@description('Provide the high availability mode for a server : Disabled, SameZone, or ZoneRedundant')
@allowed([
  'Disabled'
  'SameZone'
  'ZoneRedundant'
])
param haEnabled string = 'ZoneRedundant'

@description('Provide the availability zone of the standby server.')
param standbyAvailabilityZone string = '2'

param storageSizeGB int = 20
param storageIops int = 360
@allowed([
  'Enabled'
  'Disabled'
])
param storageAutogrow string = 'Enabled'

param backupRetentionDays int = 7

@allowed([
  'Disabled'
  'Enabled'
])

param geoRedundantBackup string = 'Disabled'


resource mysqlDbServer 'Microsoft.DBforMySQL/flexibleServers@2022-09-30-preview' = {
  name: serverName
  location: location
  tags: tagValues
  sku: {
    name: skuName
    tier: SkuTier
  }
  properties: {
    createMode: 'Default'
    version: serverVersion
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    availabilityZone: availabilityZone

    highAvailability: {
      mode: haEnabled
      standbyAvailabilityZone: standbyAvailabilityZone
    }

    storage: {
      storageSizeGB: storageSizeGB
      iops: storageIops
      autoGrow: storageAutogrow
    }

    network:{
      publicNetworkAccess: 'Disabled'
      delegatedSubnetResourceId: mysqlSubnetID
    }

    backup: {
      backupRetentionDays: backupRetentionDays
      geoRedundantBackup: geoRedundantBackup
    }
  }
}

/*resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: 'pe-${serverName}'
  location: location
  properties: {
    subnet: {
      id: peSubnetID
    }
    privateLinkServiceConnections: [
      {
        name: 'pe-${serverName}'
        properties: {
          privateLinkServiceId: mysqlDbServer.id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
}
*/
