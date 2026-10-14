variable "location" {
  type        = string
  default     = "westeurope"
  description = "Primary Azure region"
}

variable "environment" {
  type        = string
  default     = "prod"
  description = "Environment name (prod, staging, dev)"
}

variable "firewall_sku_tier" {
  type        = string
  default     = "Standard"
  description = "Azure Firewall SKU Tier: 'Basic', 'Standard', or 'Premium'"
}

variable "admin_username" {
  type        = string
  default     = "finopsadmin"
  description = "Administrator username for virtual machines"
}

variable "admin_password" {
  type        = string
  sensitive   = true
  default     = "P@ssw0rdFinOps2026!#"
  description = "Administrator password for virtual machines"
}

variable "tags" {
  type = map(string)
  default = {
    CostCenter    = "CC-FIN-4010"
    Department    = "Platform-Engineering"
    Environment   = "Production"
    Owner         = "finops-lead@company.com"
    Workload      = "Hybrid-IaaS-Reference"
    SharedService = "false"
  }
  description = "Baseline tags applied across all deployed resources"
}
