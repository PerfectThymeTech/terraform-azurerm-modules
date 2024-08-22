data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_bot_service_azure_bot" {
  resource_id = azurerm_bot_service_azure_bot.bot_service_azure_bot.id
}

data "azurerm_application_insights" "application_insights" {
  name                = local.application_insights.name
  resource_group_name = local.application_insights.resource_group_name
}
