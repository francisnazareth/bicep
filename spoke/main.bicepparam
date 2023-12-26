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
param peSubnetName = 'snet-pe-moi-poc-qc-01'
param peSubnetAddressPrefix = '10.0.6.0/27'
