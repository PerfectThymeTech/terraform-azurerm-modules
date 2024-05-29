output "application_insights_id" {
  description = "Specifies the resource id of application insights."
  value       = module.application_insights.application_insights_id
  sensitive   = false
}

output "container_registry_id" {
  description = "Specifies the resource id of the container registry."
  value       = module.container_registry.container_registry_id
  sensitive   = false
}

output "key_vault_id" {
  description = "Specifies the resource id of the key vault."
  value       = module.key_vault.key_vault_id
  sensitive   = false
}

output "storage_account_id" {
  description = "Specifies the resource id of the storage account."
  value       = module.storage_account.storage_account_id
  sensitive   = false
}
