data "azurerm_client_config" "current" {}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_storage_account" {
  resource_id = azurerm_storage_account.storage_account.id
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_storage_account_blob" {
  resource_id = local.resource_id_blob
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_storage_account_file" {
  resource_id = local.resource_id_file
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_storage_account_table" {
  resource_id = local.resource_id_table
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_storage_account_queue" {
  resource_id = local.resource_id_queue
}
