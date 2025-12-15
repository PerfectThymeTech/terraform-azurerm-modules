data "azurerm_client_config" "current" {}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_ai_services" {
  resource_id = azurerm_cognitive_account.cognitive_account.id
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_ai_services_project" {
  for_each = var.ai_services_projects

  resource_id = azurerm_cognitive_account_project.cognitive_account_project[each.key].id
}
