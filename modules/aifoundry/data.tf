data "azurerm_client_config" "current" {}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_ai_services" {
  resource_id = azurerm_ai_services.ai_services.id
}
