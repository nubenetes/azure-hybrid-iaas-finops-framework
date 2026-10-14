targetScope = 'subscription'

@description('FinOps Mandatory Tag Policy Definition')
resource policyEnforceTags 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'finops-enforce-mandatory-tags'
  properties: {
    displayName: 'FinOps: Enforce mandatory financial tags (CostCenter)'
    policyType: 'Custom'
    mode: 'Indexed'
    description: 'Denies resource creation if CostCenter tag is missing.'
    policyRule: {
      if: {
        allOf: [
          {
            field: 'tags[\'CostCenter\']'
            exists: 'false'
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

output policyEnforceTagsId string = policyEnforceTags.id
