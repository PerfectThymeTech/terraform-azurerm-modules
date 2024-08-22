resource "azurerm_application_insights_api_key" "application_insights_api_key" {
  name                    = "appi-key-bot-framework-${var.bot_service_name}"
  application_insights_id = data.azurerm_application_insights.application_insights.id
  read_permissions = [
    "aggregate",
    "api",
    "draft",
    "extendqueries",
    "search",
  ]
  write_permissions = []
}
