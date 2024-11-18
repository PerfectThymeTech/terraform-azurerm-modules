data "azurerm_client_config" "current" {}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_purview_account" {
  resource_id = azapi_resource.purview_account.id
}
