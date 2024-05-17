data "azurerm_client_config" "current" {}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_cognitive_account" {
  resource_id = azurerm_cognitive_account.cognitive_account.id
}
