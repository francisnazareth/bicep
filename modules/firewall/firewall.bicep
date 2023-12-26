param location string
param firewallPublicIPName string
param firewallPolicyName string
param vnetName string
param firewallName string
@description('Zone numbers e.g. 1,2,3.')
param availabilityZones array = []
param tagValues object

resource publicIpAddress 'Microsoft.Network/publicIPAddresses@2022-01-01' =  {
  name: firewallPublicIPName
  location: location
  zones: availabilityZones
  tags: tagValues
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}


resource firewallPolicy 'Microsoft.Network/firewallPolicies@2022-01-01'= {
  name: firewallPolicyName
  location: location
  tags: tagValues

  properties: {
    sku: {
      tier: 'Premium'
    }
    threatIntelMode: 'Deny'
    intrusionDetection: {
      mode: 'Deny'
    }
  }
}

output firewallPolicyId string = firewallPolicy.id

resource networkRuleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2022-01-01' = {
  parent: firewallPolicy
  name: 'DefaultNetworkRuleCollectionGroup'
  properties: {
    priority: 200
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        name: 'azure-global-services-nrc'
        priority: 1250
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'time-windows'
            ipProtocols: [
              'UDP'
            ]
            destinationAddresses: [
              '13.86.101.172'
            ]
            sourceAddresses: [
             '13.86.101.173'
            ]
            destinationPorts: [
              '123'
            ]
          }
        ]
      }
    ]
  }
}

resource applicationRuleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2022-01-01' = {
  parent: firewallPolicy
  name: 'DefaultApplicationRuleCollectionGroup'
  dependsOn: [
    networkRuleCollectionGroup
  ]
  properties: {
    priority: 300
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'global-rule-url-arc'
        priority: 1000
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'winupdate-rule-01'
            protocols: [
              {
                protocolType: 'Https'
                port: 443
              }
              {
                protocolType: 'Http'
                port: 80
              }
            ]
            fqdnTags: [
              'WindowsUpdate'
            ]
            terminateTLS: false
            sourceAddresses: [
              '10.1.2.3'
            ]
          }
        ]
      }
    ]
  }
}

var azureFirewallSubnetId = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, 'AzureFirewallSubnet')

var azureFirewallIpConfigurations = [{
  name: 'IpConf1'
    properties: {
    subnet:  json('{"id": "${azureFirewallSubnetId}"}')
    publicIPAddress: {
      id: publicIpAddress.id
    }
  }
}]

resource firewall 'Microsoft.Network/azureFirewalls@2021-03-01' = {
  name: firewallName
  location: location
  zones: availabilityZones
  tags: tagValues

  dependsOn: [
    networkRuleCollectionGroup
    applicationRuleCollectionGroup
  ]
  properties: {
    sku: {
      name: 'AZFW_VNet'
      tier: 'Premium'
    }
    ipConfigurations: azureFirewallIpConfigurations
    firewallPolicy: {
      id: firewallPolicy.id
    }
  }
}