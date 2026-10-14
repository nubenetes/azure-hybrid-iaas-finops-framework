output "hub_vnet_id" {
  value       = azurerm_virtual_network.hub.id
  description = "Resource ID of the Hub VNet"
}

output "hub_vnet_name" {
  value       = azurerm_virtual_network.hub.name
  description = "Name of the Hub VNet"
}

output "firewall_private_ip" {
  value       = azurerm_firewall.hub.ip_configuration[0].private_ip_address
  description = "Private IP of the central Azure Firewall"
}
