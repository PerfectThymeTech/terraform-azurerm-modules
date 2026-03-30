data "azurerm_client_config" "current" {}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_eventgrid_namespace" {
  resource_id = azurerm_eventgrid_namespace.eventgrid_namespace.id
}
