data "azurerm_client_config" "current" {}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_communication_service" {
  resource_id = azurerm_communication_service.communication_service.id
}
