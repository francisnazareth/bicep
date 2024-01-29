using './vm.bicep'
param location = 'eastus'
param tagValues = {
    Environment: 'PROD'
    CostCenter: 'IT'
    Project: 'App1'
    CreatedBy: 'bicep'
    CreationDate: '2024-JAN-03'
}

param vmName = 'relaylinuxvm'
param vmSize = 'Standard_D2s_v3'
param adminUsername = 'adminuser'
param adminPassword = 'P@ssw0rd123!'
param managementSubnetID = '/subscriptions/cb56ce60-e634-4951-8ac8-ec94c671d4e8/resourcegroups/rg-superapp/providers/Microsoft.Network/virtualNetworks/vnet-superapp/subnets/default'
