resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  allow_resource_only_permissions         = true
  cmk_for_query_forced                    = false
  daily_quota_gb                          = -1
  immediate_data_purge_on_30_days_enabled = false
  internet_ingestion_access_type          = "Enabled"
  internet_query_access_type              = "Enabled"
  local_authentication_enabled            = false
  retention_in_days                       = var.log_analytics_workspace_retention_in_days
  reservation_capacity_in_gb_per_day      = null
  sku                                     = "PerGB2018"
}
