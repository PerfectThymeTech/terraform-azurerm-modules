output "key_vault" {
  description = "Specifies the key vault resource."
  value       = azurerm_key_vault.kv
  sensitive   = false
}

output "key_vault_id" {
  description = "Specifies the key vault resource id."
  value       = azurerm_key_vault.kv.id
  sensitive   = false
}

output "key_vault_name" {
  description = "Specifies the key vault resource name."
  value       = azurerm_key_vault.kv.name
  sensitive   = false
}

output "key_vault_uri" {
  description = "Specifies the key vault resource vault uri."
  value       = azurerm_key_vault.kv.vault_uri
  sensitive   = false
}

output "key_vault_setup_completed" {
  value       = true
  description = "Specifies whether the connectivity and identity has been successfully configured."
  sensitive   = false

  depends_on = [
    azurerm_role_assignment.current_roleassignment_key_vault,
    time_sleep.sleep_connectivity,
  ]
}
