variable "resource_group_name" {
  type        = string
  description = "Resource Group for Web Spoke"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "hub_vnet_id" {
  type        = string
  description = "Resource ID of the Hub VNet for peering"
}

variable "hub_vnet_name" {
  type        = string
  description = "Name of the Hub VNet"
}

variable "admin_username" {
  type        = string
  default     = "azureadmin"
  description = "Local administrator username"
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "Local administrator password"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags applied to web spoke resources"
}
