using './main.bicep'

param vnetName = 'vnet-moi-hub-qc-01'
param vnetAddressPrefix = '10.0.0.0/22'
param fwSubnetAddressPrefix = '10.0.0.0/26'
param bastionSubnetAddressPrefix = '10.0.0.64/26'
param vpnSubnetAddressPrefix = '10.0.0.128/27'
param appGwSubnetName = 'snet-agw-hub-qc-01'
param appGwSubnetAddressPrefix = '10.0.0.160/27'
param managementSubnetName = 'snet-management-hub-qc-01'
param managementSubnetAddressPrefix = '10.0.0.192/28'
param sharedServicesSubnetName = 'snet-sharedservices-hub-qc-01'
param sharedServicesSubnetAddressPrefix = '10.0.0.208/28'
param bastionName  = 'bastion-moi-hub-qc-01'
param bastionPublicIPName  = 'publicip-bastion-moi-hub-qc-01'
param bastionSku  = 'Standard'
param logAnalyticsRetentionInDays  = 60
param logAnalyticsWorkspaceName  = 'law-moi-hub-qc-01'
param logAnalyticsSku = 'PerGB2018'
param ddosProtectionPlanName = 'ddosplan-moi-hub-qc-01'
param ddosProtectionPlanEnabled = true
param firewallPublicIPName = 'publicip-fw-moi-hub-qc-01' 
param firewallPolicyName = 'fwpolicy-moi-hub-qc-01'
param firewallName = 'firewall-moi-hub-qc-01'
param availabilityZones = [1,2,3]
param vmName = 'moiwinvm'
param vmSize = 'Standard_D2s_v3'
param adminUsername = 'adminuser'
param adminPassword = 'P@ssw0rd123!'
param tagValues = {
    Environment: 'PoC'
    CostCenter: 'IT'
    Project: 'super app'
    CreatedBy: 'bicep'
    CreationDate: '2023-26-12'
}

param backupRGName = 'rg-backup-moi-hub-qc-01'
param managementRGName = 'rg-management-moi-hub-qc-01'
param monitoringRGName = 'rg-monitoring-moi-hub-qc-01'
param networkRGName = 'rg-network-moi-hub-qc-01'
