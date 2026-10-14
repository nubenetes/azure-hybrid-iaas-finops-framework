variable "resource_group_name" {
  type        = string
  description = "Resource Group for Database Spoke"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "zone" {
  type        = string
  default     = "1"
  description = "Availability Zone (Required for Premium SSD v2)"
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
  default     = "sqladmin"
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
  description = "Tags applied to database spoke resources"
}
