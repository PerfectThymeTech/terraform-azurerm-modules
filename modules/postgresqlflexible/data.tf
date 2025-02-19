data "azurerm_client_config" "current" {}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_postgresql_flexible_server" {
  resource_id = azurerm_postgresql_flexible_server.postgresql_flexible_server.id
}
