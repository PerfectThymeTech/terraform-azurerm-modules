run "create_postgresql_flexible_server" {
  command = apply

  variables {
    location            = "northeurope"
    resource_group_name = "tfmodule-test-rg"
    tags = {
      test = "postgresqlflexibleserver"
    }
    postgresql_name                         = "tftstr-001"
    postgresql_administrator_login          = "DbMainUser"
    postgresql_administrator_password       = "g!7hVLy$Yq~82`4SU6<w+C"
    postgresql_auto_grow_enabled            = false
    postgresql_backup_retention_days        = 30
    postgresql_geo_redundant_backup_enabled = true
    postgresql_zone_redundancy_enabled      = false
    postgresql_high_availability_mode       = "ZoneRedundant"
    postgresql_maintenance_window = {
      day_of_week  = 6
      start_hour   = 0
      start_minute = 0
    }
    postgresql_sku_name     = "B_Standard_B1ms"
    postgresql_storage_mb   = 32768
    postgresql_storage_tier = null
    postgresql_version      = 16
    postgresql_active_directory_administrator = {
      object_id  = ""
      group_name = ""
    }
    postgresql_configuration = {}
    postgresql_databases = {
      testdb001 = {
        charset   = "UTF8"
        collation = "en_US.utf8"
      }
    }
    diagnostics_configurations     = []
    subnet_id                      = "/subscriptions/1fdab118-1638-419a-8b12-06c9543714a0/resourceGroups/ptt-dev-networking-rg/providers/Microsoft.Network/virtualNetworks/spoke-ptt-dev-vnet001/subnets/TerraformTestSubnet"
    connectivity_delay_in_seconds  = 0
    private_dns_zone_id_postrgesql = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.postgres.database.azure.com"
    customer_managed_key           = null
  }

  assert {
    condition     = azurerm_postgresql_flexible_server.postgresql_flexible_server.resource_group_name == "tfmodule-test-rg"
    error_message = "Failed to deploy."
  }
}
