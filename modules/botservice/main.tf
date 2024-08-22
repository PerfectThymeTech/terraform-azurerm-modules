resource "azurerm_bot_service_azure_bot" "bot_service_azure_bot" {
  name                = var.bot_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  cmk_key_vault_key_url                 = var.customer_managed_key == null ? null : var.customer_managed_key.key_vault_key_versionless_id
  developer_app_insights_api_key        = azurerm_application_insights_api_key.application_insights_api_key.api_key
  developer_app_insights_application_id = data.azurerm_application_insights.application_insights.app_id
  developer_app_insights_key            = null
  display_name                          = "Azure Bot Service - ${title(replace(var.bot_service_name, "-", " "))}"
  endpoint                              = var.bot_service_endpoint
  icon_url                              = var.bot_service_icon_url
  local_authentication_enabled          = false
  luis_app_ids                          = var.bot_service_luis.app_ids
  luis_key                              = var.bot_service_luis.key
  microsoft_app_id                      = var.bot_service_microsoft_app.app_id
  microsoft_app_msi_id                  = var.bot_service_microsoft_app.app_msi_id
  microsoft_app_tenant_id               = var.bot_service_microsoft_app.app_tenant_id
  microsoft_app_type                    = var.bot_service_microsoft_app.app_type
  public_network_access_enabled         = var.bot_service_public_network_access_enabled
  sku                                   = var.bot_service_sku
  streaming_endpoint_enabled            = var.bot_service_streaming_endpoint_enabled
}
