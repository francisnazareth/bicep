using './main.bicep'

param vnetName = 'vnet-cust-hub-qc-01'
param vnetAddressPrefix = '10.0.0.0/22'
param fwSubnetAddressPrefix = '10.0.0.0/26'
param bastionSubnetAddressPrefix = '10.0.0.64/26'
param vpnSubnetAddressPrefix = '10.0.0.128/27'
param peSubnetName = 'snet-pe-hub-qc-01'
param peSubnetAddressPrefix = '10.0.0.160/27'
param appGwSubnetName = 'snet-agw-hub-qc-01'
param appGwSubnetAddressPrefix = '10.0.1.0/24'
param managementSubnetName = 'snet-management-hub-qc-01'
param managementSubnetAddressPrefix = '10.0.0.192/28'
param sharedServicesSubnetName = 'snet-sharedservices-hub-qc-01'
param sharedServicesSubnetAddressPrefix = '10.0.0.208/28'
param bastionName  = 'bastion-cust-hub-qc-01'
param bastionPublicIPName  = 'publicip-bastion-cust-hub-qc-01'
param bastionSku  = 'Standard'
param logAnalyticsRetentionInDays  = 60
param logAnalyticsWorkspaceName  = 'law-cust-hub-qc-01'
param logAnalyticsSku = 'PerGB2018'
param ddosProtectionPlanName = 'ddosplan-cust-hub-qc-01'
param ddosProtectionPlanEnabled = true
param firewallPublicIPName = 'publicip-fw-cust-hub-qc-01' 
param firewallPolicyName = 'fwpolicy-cust-hub-qc-01'
param firewallName = 'firewall-cust-hub-qc-01'
param availabilityZones = [1,2,3]
param vmName = 'custwinvm'
param vmSize = 'Standard_D2s_v3'
param vmNSGName = 'nsg-jumpserver-cust-hub-qc-01'
param adminUsername = 'adminuser'
param adminPassword = 'P@ssw0rd123!'
param tagValues = {
    Environment: 'Hub'
    CostCenter: 'IT'
    Project: 'project name'
    CreatedBy: 'bicep'
    CreationDate: '2024-02-JAN'
}
param backupRGName = 'rg-backup-cust-hub-qc-01'
param managementRGName = 'rg-management-cust-hub-qc-01'
param monitoringRGName = 'rg-monitoring-cust-hub-qc-01'
param networkRGName = 'rg-network-cust-hub-qc-01'
param recoveryServiceVaultName = 'vault-cust-poc-qc-01'
param managedIdentityName = 'mi-kvaccess-cust-poc-qc-01'
param keyVaultName = 'kv-cust-poc-qc-01'
param keyVaultSKU = 'premium'
param applicationGatewayName = 'agw-cust-hub-qc-01'
param applicationGatewayPublicIPName = 'publicip-agw-cust-hub-qc-01'
param appGatewayWAFPolicyName = 'wafpolicy-agw-cust-hub-qc-01'
param vpnGatewayName = 'vgw-cust-hub-qc-01'
param vpnGatewayPublicIP = 'publicip-vgw-cust-hub-qc-01'
param vpnGatewayTier = 'VpnGw2AZ'
param vmRouteTableName = 'rt-jumpserver-cust-hub-qc-01'
param aksAddressRange = ['10.0.4.0/23', '10.0.6.0/28', '10.0.7.0/24', '10.0.8.0/28']
