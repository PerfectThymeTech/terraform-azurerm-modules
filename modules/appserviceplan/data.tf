data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_service_plan" {
  resource_id = azurerm_service_plan.service_plan.id
}
