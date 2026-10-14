variable "resource_group_name" {
  type        = string
  description = "Name of the resource group for Hub resources"
}

variable "location" {
  type        = string
  description = "Azure region (e.g. westeurope, eastus)"
}

variable "hub_vnet_address_space" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "Address space for Hub VNet"
}

variable "firewall_sku_tier" {
  type        = string
  default     = "Standard"
  description = "Azure Firewall SKU Tier: 'Basic', 'Standard', or 'Premium'"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.firewall_sku_tier)
    error_message = "firewall_sku_tier must be Basic, Standard, or Premium."
  }
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags applied to all hub resources"
}
