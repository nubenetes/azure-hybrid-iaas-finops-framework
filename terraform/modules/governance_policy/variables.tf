variable "subscription_id" {
  type        = string
  description = "Target subscription ID for policy assignment"
  default     = ""
}

variable "resource_group_id" {
  type        = string
  description = "Target resource group ID for scoped policy assignment"
  default     = ""
}
