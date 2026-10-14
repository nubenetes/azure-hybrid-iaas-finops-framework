output "workspace_id" {
  value       = azurerm_log_analytics_workspace.core.id
  description = "Resource ID of the Log Analytics workspace"
}

output "dcr_id" {
  value       = azurerm_monitor_data_collection_rule.finops_edge_filter.id
  description = "Resource ID of the FinOps Data Collection Rule"
}
