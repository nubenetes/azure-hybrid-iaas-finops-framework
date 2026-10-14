output "spoke_db_vnet_id" {
  value       = azurerm_virtual_network.spoke_db.id
  description = "Resource ID of Database Spoke VNet"
}

output "sql_vm_id" {
  value       = azurerm_windows_virtual_machine.sql_vm.id
  description = "Resource ID of the SQL Server VM"
}

output "sql_vm_private_ip" {
  value       = azurerm_network_interface.sql_nic.private_ip_address
  description = "Private IP address of the SQL Server VM"
}
