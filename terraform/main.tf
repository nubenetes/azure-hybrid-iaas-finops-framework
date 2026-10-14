# Azure Resource Groups per Tier
resource "azurerm_resource_group" "hub" {
  name     = "rg-finops-hub-${var.environment}"
  location = var.location
  tags = merge(var.tags, {
    SharedService = "true"
    Tier          = "Hub-Security"
  })
}

resource "azurerm_resource_group" "spoke_web" {
  name     = "rg-finops-spoke-web-${var.environment}"
  location = var.location
  tags = merge(var.tags, {
    Tier = "Spoke-Web"
  })
}

resource "azurerm_resource_group" "spoke_db" {
  name     = "rg-finops-spoke-db-${var.environment}"
  location = var.location
  tags = merge(var.tags, {
    Tier = "Spoke-Database"
  })
}

resource "azurerm_resource_group" "observability" {
  name     = "rg-finops-observability-${var.environment}"
  location = var.location
  tags = merge(var.tags, {
    Tier = "Shared-Observability"
  })
}

# 1. Hub Network & Central Azure Firewall
module "hub_network" {
  source              = "./modules/hub_network"
  resource_group_name = azurerm_resource_group.hub.name
  location            = var.location
  firewall_sku_tier   = var.firewall_sku_tier
  tags                = azurerm_resource_group.hub.tags
}

# 2. Spoke Web Tier (VMSS IIS with Spot Priority Mix & Service Endpoints)
module "spoke_web" {
  source              = "./modules/spoke_web"
  resource_group_name = azurerm_resource_group.spoke_web.name
  location            = var.location
  hub_vnet_id         = module.hub_network.hub_vnet_id
  hub_vnet_name       = module.hub_network.hub_vnet_name
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  tags                = azurerm_resource_group.spoke_web.tags
}

# 3. Spoke DB Tier (SQL Server with Constrained vCPU & Premium SSD v2)
module "spoke_db" {
  source              = "./modules/spoke_db"
  resource_group_name = azurerm_resource_group.spoke_db.name
  location            = var.location
  hub_vnet_id         = module.hub_network.hub_vnet_id
  hub_vnet_name       = module.hub_network.hub_vnet_name
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  tags                = azurerm_resource_group.spoke_db.tags
}

# 4. Observability Tier (AMA + DCR Edge Filtering)
module "observability_dcr" {
  source              = "./modules/observability_dcr"
  resource_group_name = azurerm_resource_group.observability.name
  location            = var.location
  tags                = azurerm_resource_group.observability.tags
}

# 5. Governance & Policy Tier
module "governance_policy" {
  source            = "./modules/governance_policy"
  resource_group_id = azurerm_resource_group.hub.id
}
