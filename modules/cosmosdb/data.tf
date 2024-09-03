data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_cosmosdb_account" {
  resource_id = azurerm_cosmosdb_account.cosmosdb_account.id
}
