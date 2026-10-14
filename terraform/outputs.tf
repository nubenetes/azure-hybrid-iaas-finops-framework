output "hub_vnet_id" {
  value       = module.hub_network.hub_vnet_id
  description = "Resource ID of the Hub VNet"
}

output "firewall_private_ip" {
  value       = module.hub_network.firewall_private_ip
  description = "Private IP of the central Azure Firewall"
}

output "spoke_web_vnet_id" {
  value       = module.spoke_web.spoke_web_vnet_id
  description = "Resource ID of Web Spoke VNet"
}

output "spoke_db_vnet_id" {
  value       = module.spoke_db.spoke_db_vnet_id
  description = "Resource ID of DB Spoke VNet"
}

output "sql_vm_private_ip" {
  value       = module.spoke_db.sql_vm_private_ip
  description = "Private IP of the SQL Server VM"
}

output "log_analytics_workspace_id" {
  value       = module.observability_dcr.workspace_id
  description = "Resource ID of the FinOps Log Analytics Workspace"
}
