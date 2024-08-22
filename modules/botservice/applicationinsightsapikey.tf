resource "azurerm_application_insights_api_key" "application_insights_api_key" {
  name                    = "appi-key-bot-framework-${var.bot_service_name}"
  application_insights_id = var.bot_service_application_insights_id
  read_permissions = [
    "aggregate",
    "api",
    "draft",
    "extendqueries",
    "search",
  ]
}
