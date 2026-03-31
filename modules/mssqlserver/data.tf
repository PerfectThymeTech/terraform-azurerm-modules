data "azurerm_client_config" "current" {}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_mssql_server" {
  resource_id = azurerm_mssql_server.mssql_server.id
}
