resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_mssql_server" {
  for_each = { for index, value in var.diagnostics_configurations :
    index => {
      log_analytics_workspace_id = value.log_analytics_workspace_id,
      storage_account_id         = value.storage_account_id
    }
  }
  name                       = "applicationLogs-${each.key}"
  target_resource_id         = azurerm_mssql_server.mssql_server.id
  log_analytics_workspace_id = each.value.log_analytics_workspace_id == "" ? null : each.value.log_analytics_workspace_id
  storage_account_id         = each.value.storage_account_id == "" ? null : each.value.storage_account_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_mssql_server.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "enabled_metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_mssql_server.metrics
    content {
      category = entry.value
    }
  }
}
