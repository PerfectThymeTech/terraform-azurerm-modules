resource "azurerm_postgresql_flexible_server" "postgresql_flexible_server" {
  name                = var.postgresql_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  dynamic "identity" {
    for_each = var.customer_managed_key != null ? [1] : []
    content {
      type = "UserAssigned"
      identity_ids = [
        var.customer_managed_key.user_assigned_identity_id
      ]
    }
  }

  administrator_login    = var.postgresql_administrator_login
  administrator_password = var.postgresql_administrator_password
  authentication {
    active_directory_auth_enabled = true
    password_auth_enabled         = true
    tenant_id                     = data.azurerm_client_config.current.tenant_id
  }
  auto_grow_enabled     = var.postgresql_auto_grow_enabled
  backup_retention_days = var.postgresql_backup_retention_days
  create_mode           = "Default"
  dynamic "customer_managed_key" {
    for_each = var.customer_managed_key != null ? [1] : []
    content {
      key_vault_key_id                  = var.customer_managed_key.key_vault_id
      primary_user_assigned_identity_id = var.customer_managed_key.user_assigned_identity_id
    }
  }
  delegated_subnet_id          = null
  geo_redundant_backup_enabled = var.postgresql_geo_redundant_backup_enabled
  dynamic "high_availability" {
    for_each = var.postgresql_zone_redundancy_enabled ? [1] : []
    content {
      mode = var.postgresql_high_availability_mode
    }
  }
  maintenance_window {
    day_of_week  = var.postgresql_maintenance_window.day_of_week
    start_hour   = var.postgresql_maintenance_window.start_hour
    start_minute = var.postgresql_maintenance_window.start_minute
  }
  public_network_access_enabled = false
  replication_role              = null
  sku_name                      = var.postgresql_sku_name
  storage_mb                    = var.postgresql_storage_mb
  storage_tier                  = var.postgresql_storage_tier
  version                       = var.postgresql_version
  zone                          = null

  lifecycle {
    ignore_changes = [
      zone,
      high_availability[0].standby_availability_zone,
    ]
  }
}

resource "azurerm_postgresql_flexible_server_database" "postgresql_flexible_server_database" {
  for_each = var.postgresql_databases

  server_id = azurerm_postgresql_flexible_server.postgresql_flexible_server.id
  name      = each.key

  charset   = each.value.charset
  collation = each.value.collation
}

resource "azurerm_postgresql_flexible_server_active_directory_administrator" "postgresql_flexible_server_active_directory_administrator" {
  count = var.postgresql_active_directory_administrator.object_id != "" && var.postgresql_active_directory_administrator.group_name != "" ? 1 : 0

  server_name         = azurerm_postgresql_flexible_server.postgresql_flexible_server.name
  resource_group_name = azurerm_postgresql_flexible_server.postgresql_flexible_server.resource_group_name

  object_id      = var.postgresql_active_directory_administrator.object_id
  principal_name = var.postgresql_active_directory_administrator.group_name
  principal_type = "Group"
  tenant_id      = data.azurerm_client_config.current.tenant_id
}

resource "azurerm_postgresql_flexible_server_configuration" "postgresql_flexible_server_configuration" {
  for_each = var.postgresql_configuration

  server_id = azurerm_postgresql_flexible_server.postgresql_flexible_server.id
  name      = each.key

  value = each.value
}
