output "policy_enforce_tags_id" {
  value       = azurerm_policy_definition.enforce_tags.id
  description = "Resource ID of the Tag Enforcement Policy Definition"
}

output "policy_audit_ahb_id" {
  value       = azurerm_policy_definition.audit_ahb.id
  description = "Resource ID of the AHB Audit Policy Definition"
}
