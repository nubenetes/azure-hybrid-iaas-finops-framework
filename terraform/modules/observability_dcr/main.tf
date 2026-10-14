resource "azurerm_log_analytics_workspace" "core" {
  name                = "law-finops-core"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_in_days
  tags                = var.tags
}

# FinOps Data Collection Rule (DCR) with Edge XPath Filtering
# Eliminates Runaway Telemetry: Intercepts events inside Windows guest OS kernel before transmission
resource "azurerm_monitor_data_collection_rule" "finops_edge_filter" {
  name                = "dcr-finops-windows-filtered"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.core.id
      name                  = "law-destination"
    }
  }

  data_flow {
    streams      = ["Microsoft-WindowsEvent", "Microsoft-Perf"]
    destinations = ["law-destination"]
  }

  data_sources {
    # Windows Event Log: Filter out noise, ingest actionable security events only
    windows_event_log {
      streams = ["Microsoft-WindowsEvent"]
      name    = "security-filtered-source"
      x_path_queries = [
        # Event 4625: Failed Logon (Brute force detection)
        # Event 4672: Special Privileges Assigned
        # Event 4720: User Account Created
        "Security!*[System[(EventID=4625 or EventID=4672 or EventID=4720 or EventID=4726 or EventID=4738)]]"
      ]
    }

    # Performance Counters: Extended sampling interval (60 seconds) to avoid micro-ingestion bloat
    performance_counter {
      streams                       = ["Microsoft-Perf"]
      sampling_frequency_in_seconds = 60
      counter_specifiers = [
        "\\Processor Information(_Total)\\% Processor Time",
        "\\Memory\\Available MBytes",
        "\\PhysicalDisk(_Total)\\Avg. Disk sec/Read",
        "\\PhysicalDisk(_Total)\\Avg. Disk sec/Write"
      ]
      name = "perf-counter-source"
    }
  }
}
