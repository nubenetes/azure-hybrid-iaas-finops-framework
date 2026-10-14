resource "azurerm_virtual_network" "spoke_db" {
  name                = "vnet-spoke-db-prod"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["10.2.0.0/16"]
  tags                = var.tags
}

resource "azurerm_subnet" "db" {
  name                 = "snet-database-tier"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke_db.name
  address_prefixes     = ["10.2.1.0/24"]

  # FinOps Best Practice: Service Endpoints for Storage Accounts (automated SQL backups)
  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.KeyVault"
  ]
}

# Bidirectional VNet Peering
resource "azurerm_virtual_network_peering" "db_to_hub" {
  name                         = "peer-spoke-db-to-hub"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.spoke_db.name
  remote_virtual_network_id    = var.hub_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "hub_to_db" {
  name                         = "peer-hub-to-spoke-db"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = var.hub_vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.spoke_db.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_network_interface" "sql_nic" {
  name                = "nic-sql-prod-01"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  ip_configuration {
    name                          = "ipconfig-sql"
    subnet_id                     = azurerm_subnet.db.id
    private_ip_address_allocation = "Dynamic"
  }
}

# FinOps Masterpiece: Constrained vCPU Size (Standard_E32-8s_v5)
# Physical base: 32 cores, 256 GiB RAM, 80,000 IOPS, 1,200 MB/s.
# Masked by hypervisor to 8 vCPUs -> Saves 75% on SQL Server Enterprise Core licenses!
resource "azurerm_windows_virtual_machine" "sql_vm" {
  name                = "vm-sql-prod-01"
  resource_group_name = var.resource_group_name
  location            = var.location
  zone                = var.zone
  size                = "Standard_E32-8s_v5"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.sql_nic.id
  ]

  # FinOps License Optimization: Azure Hybrid Benefit (AHB) for Windows Server
  license_type = "Windows_Server"

  source_image_reference {
    publisher = "MicrosoftSQLServer"
    offer     = "sql2022-ws2022"
    sku       = "enterprise-gen2"
    version   = "latest"
  }

  os_disk {
    name                 = "osdisk-sql-prod-01"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  tags = var.tags
}

# FinOps Storage Revolution: Premium SSD v2 Managed Disk
# Decouples Capacity (512 GiB), IOPS (13,500), and Throughput (250 MB/s)
# Eliminates Windows Storage Spaces / RAID 0 striping anti-pattern!
resource "azurerm_managed_disk" "sql_data_v2" {
  name                 = "disk-sql-data-v2"
  resource_group_name  = var.resource_group_name
  location             = var.location
  zone                 = var.zone
  storage_account_type = "PremiumV2_LRS"
  create_option        = "Empty"
  disk_size_gb         = 512
  disk_iops_read_write = 13500
  disk_mbps_read_write = 250
  tags                 = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "sql_data_attach" {
  managed_disk_id    = azurerm_managed_disk.sql_data_v2.id
  virtual_machine_id = azurerm_windows_virtual_machine.sql_vm.id
  lun                = 10
  caching            = "None" # Premium SSD v2 requires None (No host caching)
}

# Azure SQL VM IaaS Agent Extension: Enables automated patch management and SQL AHB
resource "azurerm_mssql_virtual_machine" "sql_iaas" {
  virtual_machine_id = azurerm_windows_virtual_machine.sql_vm.id
  sql_license_type   = "AHUB" # Azure Hybrid Benefit for SQL Server (Free license fee with SA!)

  storage_configuration {
    disk_type             = "NEW"
    storage_workload_type = "OLTP"
    data_settings {
      default_file_path = "F:\\SQLData"
      luns              = [10]
    }
  }
}
