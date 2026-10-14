resource "azurerm_virtual_network" "spoke_web" {
  name                = "vnet-spoke-web-prod"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["10.1.0.0/16"]
  tags                = var.tags
}

resource "azurerm_subnet" "web" {
  name                 = "snet-web-tier"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke_web.name
  address_prefixes     = ["10.1.1.0/24"]

  # FinOps Best Practice: Service Endpoints are 100% FREE ($0.00/hr, $0.00/GB)
  # Eliminates Private Endpoint hourly charges and data processing taxes for internal PaaS access
  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.KeyVault"
  ]
}

# Bidirectional VNet Peering
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = "peer-spoke-web-to-hub"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.spoke_web.name
  remote_virtual_network_id    = var.hub_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                         = "peer-hub-to-spoke-web"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = var.hub_vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.spoke_web.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# Windows Server VMSS running IIS with Spot Priority Mix
resource "azurerm_windows_virtual_machine_scale_set" "iis" {
  name                = "vmss-iis-web"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard_D2s_v5" # Compute-balanced General Purpose
  instances           = 3
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  # FinOps License Optimization: Azure Hybrid Benefit (AHB) for Windows Server
  # Eliminates the ~36% OS license surcharge, pricing instance at Linux base rate
  license_type = "Windows_Server"

  # Spot Priority Mix: 2 regular baseline instances for HA; scaling instances run on Spot
  priority        = "Spot"
  eviction_policy = "Deallocate"
  max_bid_price   = -1.0 # Up to on-demand price; yields up to 90% discount

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "StandardSSD_LRS" # Cost-effective for stateless web nodes
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "nic-iis-web"
    primary = true

    ip_configuration {
      name      = "ipconfig-iis"
      primary   = true
      subnet_id = azurerm_subnet.web.id
    }
  }

  tags = var.tags
}
