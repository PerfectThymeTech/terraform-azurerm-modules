data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_bot_service_azure_bot" {
  resource_id = azurerm_bot_service_azure_bot.bot_service_azure_bot.id
}
