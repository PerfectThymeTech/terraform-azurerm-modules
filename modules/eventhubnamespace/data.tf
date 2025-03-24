data "azurerm_client_config" "current" {}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_eventhub_namespace" {
  resource_id = azurerm_eventhub_namespace.eventhub_namespace.id
}
