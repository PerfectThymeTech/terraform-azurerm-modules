resource "azurerm_mssql_server_extended_auditing_policy" "mssql_server_extended_auditing_policy" {
  server_id = azurerm_mssql_server.mssql_server.id

  enabled                = true
  log_monitoring_enabled = true
}
