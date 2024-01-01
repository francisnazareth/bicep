param tagValues object
param aksManagedIdentityID string
param aksManagedIdentityPrincipalID string
param location string 
param availabilityZones array

@description('Disk size (in GB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 will apply the default disk size for that agentVMSize.')
@minValue(0)
@maxValue(1023)
param osDiskSizeGB int = 0

@description('The number of nodes for the cluster.')
@minValue(1)
@maxValue(50)
param aksSystemNodeCount int
param aksSystemNodeMinCount int
param aksSystemNodeMaxCount int 
param aksSystemNodepoolMaxPods int 

@description('The size of the Virtual Machine.')
param agentVMSize string 

param aksClusterName string 
param aksAPISubnetID string
param aksSubnetID string

param logAnalyticsWorkspaceID string

resource privateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.qatarcentral.azmk8s.io'
  location: 'global'
  tags: tagValues
}

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
  scope: privateDNSZone
  properties: {
    roleDefinitionId: privateDNSZoneContributorRoleDefinition.id
    principalId: aksManagedIdentityPrincipalID
    principalType: 'ServicePrincipal'
  }
}

param aksSKUName string = 'Basic'
param aksSKUTier string = 'Paid'
param aksUpgradeChannel string = 'stable'

resource aks 'Microsoft.ContainerService/managedClusters@2022-05-02-preview' = {
  name: aksClusterName
  location: location
  tags: tagValues

  sku: {
    name: aksSKUName
    tier: aksSKUTier
  }

  identity: {
    type: 'UserAssigned'
    userAssignedIdentities:{
      '${aksManagedIdentityID}': {}
    }
  }
  properties: {
    dnsPrefix: aksClusterName

    autoUpgradeProfile: {
      upgradeChannel: aksUpgradeChannel
    }

    addonProfiles: {
      azurePolicy: {
        enabled: true
      }
      httpApplicationRouting: {
        enabled: false
      }
      kubeDashboard: {
        enabled: false
      }
      omsagent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: logAnalyticsWorkspaceID
        }
      }
    }

    networkProfile:{
      loadBalancerSku: 'Standard'
      networkPlugin: 'azure'
      networkPluginMode: 'Overlay'
      networkPolicy: 'calico'
      serviceCidr: '10.8.0.0/24'
      dnsServiceIP: '10.8.0.10'
      outboundType: 'userDefinedRouting'
    }

    apiServerAccessProfile:{
      enablePrivateCluster: true
      enableVnetIntegration: true
      privateDNSZone: privateDNSZone.id
      subnetId: aksAPISubnetID
    }

    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: osDiskSizeGB
        count: aksSystemNodeCount
        minCount: aksSystemNodeMinCount
        maxCount: aksSystemNodeMaxCount
        maxPods: aksSystemNodepoolMaxPods
        enableAutoScaling: true
        availabilityZones: availabilityZones
        vmSize: agentVMSize
        osType: 'Linux'
        mode: 'System'
        vnetSubnetID: aksSubnetID
      }
    ]
  }
}

output controlPlaneFQDN string = aks.properties.fqdn
output aksObject object = aks

resource voipNodePool 'Microsoft.ContainerService/managedClusters/agentPools@2023-10-02-preview' = {
  name: 'npvoipsvc'
  parent: aks
  properties: {
    availabilityZones: availabilityZones 
    count: 8
    maxCount: 20
    minCount: 8
    enableAutoScaling: true
    mode: 'User'
    tags: tagValues
    vmSize: 'Standard_D4s_v4'
    osSKU: 'Ubuntu'
    osType: 'Linux'
    maxPods: 10
    nodeLabels: {
      workload: 'voipservice'
    }
  }
}

resource appServiceNodePool 'Microsoft.ContainerService/managedClusters/agentPools@2023-10-02-preview' = {
  name: 'npappsvc'
  parent: aks
  properties: {
    availabilityZones: availabilityZones 
    count: 8
    maxCount: 20
    minCount: 8
    enableAutoScaling: true
    mode: 'User'
    tags: tagValues
    vmSize: 'Standard_D8s_v4'
    osSKU: 'Ubuntu'
    osType: 'Linux'
    maxPods: 10
    nodeLabels: {
      workload: 'appservice'
    }
  }
}

resource imServiceNodePool 'Microsoft.ContainerService/managedClusters/agentPools@2023-10-02-preview' = {
  name: 'npimsvc'
  parent: aks
  properties: {
    availabilityZones: availabilityZones 
    count: 10
    maxCount: 20
    minCount: 10
    enableAutoScaling: true
    mode: 'User'
    tags: tagValues
    vmSize: 'Standard_D4s_v4'
    osSKU: 'Ubuntu'
    osType: 'Linux'
    maxPods: 10
    nodeLabels: {
      workload: 'imservice'
    }
  }
}

resource miniappOpenPlatformNodePool 'Microsoft.ContainerService/managedClusters/agentPools@2023-10-02-preview' = {
  name: 'npminiappop'
  parent: aks
  properties: {
    availabilityZones: availabilityZones 
    count: 2
    maxCount: 5
    minCount: 2
    enableAutoScaling: true
    mode: 'User'
    tags: tagValues
    vmSize: 'Standard_D4s_v4'
    osSKU: 'Ubuntu'
    osType: 'Linux'
    maxPods: 10
    nodeLabels: {
      workload: 'miniappopenplatform'
    }
  }
}

resource kafkaNodePool 'Microsoft.ContainerService/managedClusters/agentPools@2023-10-02-preview' = {
  name: 'npkafka'
  parent: aks
  properties: {
    availabilityZones: availabilityZones 
    count: 3
    maxCount: 6
    minCount: 3
    enableAutoScaling: true
    mode: 'User'
    tags: tagValues
    vmSize: 'Standard_D4s_v4'
    osSKU: 'Ubuntu'
    osType: 'Linux'
    maxPods: 10
    nodeLabels: {
      workload: 'kafka'
    }
  }
}

resource zookeeperNodePool 'Microsoft.ContainerService/managedClusters/agentPools@2023-10-02-preview' = {
  name: 'npzookeeper'
  parent: aks
  properties: {
    availabilityZones: availabilityZones 
    count: 3
    maxCount: 6
    minCount: 3
    enableAutoScaling: true
    mode: 'User'
    tags: tagValues
    vmSize: 'Standard_D4s_v4'
    osSKU: 'Ubuntu'
    osType: 'Linux'
    maxPods: 10
    nodeLabels: {
      workload: 'zookeeper'
    }
  }
}

resource rabbitmqNodePool 'Microsoft.ContainerService/managedClusters/agentPools@2023-10-02-preview' = {
  name: 'nprabbitmq'
  parent: aks
  properties: {
    availabilityZones: availabilityZones 
    count: 3
    maxCount: 6
    minCount: 3
    enableAutoScaling: true
    mode: 'User'
    tags: tagValues
    vmSize: 'Standard_D4s_v4'
    osSKU: 'Ubuntu'
    osType: 'Linux'
    maxPods: 10
    nodeLabels: {
      workload: 'rabbitmq'
    }
  }
}

resource elasticsearchNodePool 'Microsoft.ContainerService/managedClusters/agentPools@2023-10-02-preview' = {
  name: 'npelastic'
  parent: aks
  properties: {
    availabilityZones: availabilityZones 
    count: 3
    maxCount: 6
    minCount: 3
    enableAutoScaling: true
    mode: 'User'
    tags: tagValues
    vmSize: 'Standard_D4s_v4'
    osSKU: 'Ubuntu'
    osType: 'Linux'
    maxPods: 10
    nodeLabels: {
      workload: 'elasticsearch'
    }
  }
}
