output "spoke_web_vnet_id" {
  value       = azurerm_virtual_network.spoke_web.id
  description = "Resource ID of the Web Spoke VNet"
}

output "vmss_id" {
  value       = azurerm_windows_virtual_machine_scale_set.iis.id
  description = "Resource ID of the IIS VMSS"
}
