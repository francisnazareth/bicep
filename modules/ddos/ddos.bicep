param ddosProtectionPlanName string
param location string

resource ddosProtectionPlan 'Microsoft.Network/ddosProtectionPlans@2021-05-01' = {
  name: ddosProtectionPlanName
  location: location
}

output ddosProtectionPlanId string = ddosProtectionPlan.id
