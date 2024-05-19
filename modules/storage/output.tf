output "storage_account_id" {
  description = "Resource of the storage account"
  value       = azurerm_storage_account.storage_account.id
  sensitive   = false
}

output "storage_account_name" {
  description = "Name"
  value       = azurerm_storage_account.storage_account.name
  sensitive   = false
}

output "storage_account_primary_blob_endpoint" {
  description = "Primary blob endpoint"
  value       = azurerm_storage_account.storage_account.primary_blob_endpoint
  sensitive   = false
}

output "storage_account_primary_file_endpoint" {
  description = "Primary file endpoint"
  value       = azurerm_storage_account.storage_account.primary_file_endpoint
  sensitive   = false
}

output "storage_account_primary_queue_endpoint" {
  description = "Primary queue endpoint"
  value       = azurerm_storage_account.storage_account.primary_queue_endpoint
  sensitive   = false
}

output "storage_account_primary_table_endpoint" {
  description = "Primary table endpoint"
  value       = azurerm_storage_account.storage_account.primary_table_endpoint
  sensitive   = false
}

output "storage_account_primary_web_endpoint" {
  description = "Primary web endpoint"
  value       = azurerm_storage_account.storage_account.primary_web_endpoint
  sensitive   = false
}

output "storage_setup_completed" {
  value       = true
  description = "Specifies whether the connectivity and identity has been successfully configured."
  sensitive   = false

  depends_on = [
    azurerm_role_assignment.current_roleassignment_storage,
    time_sleep.sleep,
  ]
}
