param tagValues object
param aksManagedIdentityID string
param privateDNSZoneID string 
param location string 
param availabilityZones array

@description('Disk size (in GB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 will apply the default disk size for that agentVMSize.')
@minValue(0)
@maxValue(1023)
param osDiskSizeGB int = 0

@description('The number of nodes for the cluster.')
@minValue(1)
@maxValue(50)
param aksSystemNodeCount int = 3
param aksSystemNodeMinCount int = 3
param aksSystemNodeMaxCount int = 6 
param aksSystemNodepoolMaxPods int = 30

@description('The size of the Virtual Machine.')
param agentVMSize string 

param aksClusterName string 
param aksAPISubnetID string
param aksSubnetID string

param logAnalyticsWorkspaceID string


param aksSKUName string = 'Basic'
param aksSKUTier string = 'Paid'
param aksUpgradeChannel string = 'stable'
param serviceCIDR string = '10.8.0.0/24'
param dnsServiceIP string = '10.8.0.10'

resource superAppAKS 'Microsoft.ContainerService/managedClusters@2022-05-02-preview' = {
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
      serviceCidr: serviceCIDR
      dnsServiceIP: dnsServiceIP
      outboundType: 'userDefinedRouting'
    }

    apiServerAccessProfile:{
      enablePrivateCluster: true
      enableVnetIntegration: true
      privateDNSZone: privateDNSZoneID
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

output controlPlaneFQDN string = superAppAKS.properties.fqdn
output aksObject object = superAppAKS


resource voipNodePool 'Microsoft.ContainerService/managedClusters/agentPools@2023-10-02-preview' = {
  name: 'npvoipsvc'
  parent: superAppAKS
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
  parent: superAppAKS
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
  parent: superAppAKS
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
  parent: superAppAKS
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
  parent: superAppAKS
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
  parent: superAppAKS
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
  parent: superAppAKS
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
  parent: superAppAKS
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
    osDiskSizeGB: 256
    maxPods: 10
    nodeLabels: {
      workload: 'elasticsearch'
    }
  }
}

