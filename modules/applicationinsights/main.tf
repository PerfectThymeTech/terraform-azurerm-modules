resource "azurerm_application_insights" "application_insights" {
  name                = var.application_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  application_type                      = var.application_insights_application_type
  daily_data_cap_notifications_disabled = false
  disable_ip_masking                    = false
  force_customer_storage_for_profiler   = false
  internet_ingestion_enabled            = var.application_insights_internet_ingestion_enabled
  internet_query_enabled                = var.application_insights_internet_query_enabled
  local_authentication_disabled         = var.application_insights_local_authentication_disabled
  retention_in_days                     = var.application_insights_retention_in_days
  sampling_percentage                   = var.application_insights_sampling_percentage
  workspace_id                          = var.application_insights_log_analytics_workspace_id
}
