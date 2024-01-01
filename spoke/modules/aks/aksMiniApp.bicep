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

resource miniAppAKS 'Microsoft.ContainerService/managedClusters@2022-05-02-preview' = {
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

output controlPlaneFQDN string = miniAppAKS.properties.fqdn
output aksObject object = miniAppAKS

resource miniappNodePool 'Microsoft.ContainerService/managedClusters/agentPools@2023-10-02-preview' = {
  name: 'npminiapp'
  parent: miniAppAKS
  properties: {
    availabilityZones: availabilityZones 
    count: 4
    maxCount: 10
    minCount: 4
    enableAutoScaling: true
    mode: 'User'
    tags: tagValues
    vmSize: 'Standard_D4s_v4'
    osSKU: 'Ubuntu'
    osType: 'Linux'
    maxPods: 10
    nodeLabels: {
      workload: 'miniapp'
    }
  }
}

