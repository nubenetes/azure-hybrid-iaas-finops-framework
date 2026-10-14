variable "resource_group_name" {
  type        = string
  description = "Resource Group for Observability"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "retention_in_days" {
  type        = number
  default     = 30
  description = "Retention period for Log Analytics workspace"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags applied to observability resources"
}
