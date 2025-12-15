resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_ai_services" {
  for_each = { for index, value in var.diagnostics_configurations :
    index => {
      log_analytics_workspace_id = value.log_analytics_workspace_id,
      storage_account_id         = value.storage_account_id
    }
  }
  name                       = "applicationLogs-${each.key}"
  target_resource_id         = azurerm_cognitive_account.cognitive_account.id
  log_analytics_workspace_id = each.value.log_analytics_workspace_id == "" ? null : each.value.log_analytics_workspace_id
  storage_account_id         = each.value.storage_account_id == "" ? null : each.value.storage_account_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_ai_services.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "enabled_metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_ai_services.metrics
    content {
      category = entry.value
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_ai_services_project" {
  for_each = merge([
    for key_ai_services_project, value_ai_services_project in var.ai_services_projects : {
      for index, value in var.diagnostics_configurations :
      "${key_ai_services_project}-${index}" =>
      {
        ai_services_project_key    = key_ai_services_project,
        log_analytics_workspace_id = value.log_analytics_workspace_id,
        storage_account_id         = value.storage_account_id
      }
    }
  ]...)

  name                       = "applicationLogs-${each.key}"
  target_resource_id         = azurerm_cognitive_account_project.cognitive_account_project[each.value.ai_services_project_key].id
  log_analytics_workspace_id = each.value.log_analytics_workspace_id == "" ? null : each.value.log_analytics_workspace_id
  storage_account_id         = each.value.storage_account_id == "" ? null : each.value.storage_account_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_ai_services_project[each.value.ai_services_project_key].log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "enabled_metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_ai_services_project[each.value.ai_services_project_key].metrics
    content {
      category = entry.value
    }
  }
}
