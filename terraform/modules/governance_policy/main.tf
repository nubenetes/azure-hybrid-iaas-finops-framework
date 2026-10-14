# Azure Policy Definition: Enforce FinOps Mandatory Tags
resource "azurerm_policy_definition" "enforce_tags" {
  name         = "finops-enforce-mandatory-tags"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "FinOps: Enforce mandatory financial tags (CostCenter)"
  description  = "Denies resource creation if CostCenter tag is missing."

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "tags['CostCenter']"
          exists = "false"
        }
      ]
    }
    then = {
      effect = "deny"
    }
  })
}

# Azure Policy Definition: Audit Windows Server AHB
resource "azurerm_policy_definition" "audit_ahb" {
  name         = "finops-audit-azure-hybrid-benefit"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "FinOps: Audit Azure Hybrid Benefit on Windows VMs"
  description  = "Audits Windows Server VMs missing the licenseType = Windows_Server tag."

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          equals = "Microsoft.Compute/virtualMachines"
        },
        {
          field  = "Microsoft.Compute/virtualMachines/storageProfile.osDisk.osType"
          equals = "Windows"
        },
        {
          field = "Microsoft.Compute/virtualMachines/licenseType"
          notIn = ["Windows_Server", "Windows_Client"]
        }
      ]
    }
    then = {
      effect = "audit"
    }
  })
}

# Assign Enforce Tags Policy to Scope if resource_group_id is provided
resource "azurerm_resource_group_policy_assignment" "enforce_tags" {
  count                = var.resource_group_id != "" ? 1 : 0
  name                 = "assign-finops-enforce-tags"
  resource_group_id    = var.resource_group_id
  policy_definition_id = azurerm_policy_definition.enforce_tags.id
  display_name         = "FinOps Tagging Enforcement Assignment"
}
