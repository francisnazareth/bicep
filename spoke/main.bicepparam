using './main.bicep'
param spokeRGName = 'rg-moi-poc-qc-01'
param location = 'qatarcentral'
param tagValues = {
    Environment: 'PoC'
    CostCenter: 'IT'
    Project: 'super app'
    CreatedBy: 'bicep'
    CreationDate: '2023-26-12'
}

param vnetName = 'vnet-moi-poc-qc-01'
param vnetAddressPrefix = '10.0.4.0/22'
param aksSubnetName = 'snet-aks-moi-poc-qc-01'
param aksSubnetAddressPrefix = '10.0.4.0/23'
param aksAPISubnetName = 'snet-aks-api-moi-poc-qc-01'
param aksAPISubnetAddressPrefix = '10.0.6.0/28'
param peSubnetName = 'snet-pe-moi-poc-qc-01'
param peSubnetAddressPrefix = '10.0.6.32/27'
param aksRouteTableName = 'rt-aks-firewall'
param firewallPrivateIP = '10.0.0.4'
param aksManagedIdentityName = 'mi-aks-moi-poc-qc-01'
param aksClusterName = 'aks-moi-poc-qc-01'
param agentVMSize = 'Standard_D2s_v3'
param aksSystemNodeCount = 3
param aksSystemNodeMinCount = 3
param aksSystemNodeMaxCount = 6
param aksSystemNodepoolMaxPods = 30
param logAnalyticsWorkspaceID = '/subscriptions/cb56ce60-e634-4951-8ac8-ec94c671d4e8/resourceGroups/rg-monitoring-moi-hub-qc-01/providers/Microsoft.OperationalInsights/workspaces/law-moi-hub-qc-01'
