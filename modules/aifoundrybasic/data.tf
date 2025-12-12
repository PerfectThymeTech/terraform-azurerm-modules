data "azurerm_client_config" "current" {}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_ai_services" {
  resource_id = azapi_resource.ai_services.id
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_ai_services_project" {
  for_each = var.ai_services_projects

  resource_id = azapi_resource.ai_services_project[each.key].id
}

data "azurerm_cognitive_account" "ai_services" {
  resource_group_name = var.resource_group_name
  name                = azapi_resource.ai_services.name
}
