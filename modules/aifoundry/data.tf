data "azurerm_client_config" "current" {}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_ai_services" {
  resource_id = azurerm_ai_services.ai_services.id
}

data "azurerm_cosmosdb_sql_role_definition" "cosmosdb_sql_role_definition" {
  for_each = var.ai_services_cosmosdb_accounts

  resource_group_name = split("/", each.value.resource_id)[4]
  account_name        = reverse(split("/", each.value.resource_id))[0]
  role_definition_id  = "00000000-0000-0000-0000-000000000002"
}
