output "cognitive_account_id" {
  description = "The ID of the cognitive service account."
  value       = azurerm_cognitive_account.cognitive_account.id
  sensitive   = false
}

output "cognitive_account_name" {
  description = "The name of the cognitive service account."
  value       = azurerm_cognitive_account.cognitive_account.name
  sensitive   = false
}

output "cognitive_account_principal_id" {
  description = "The principal id of the cognitive service account."
  value       = azurerm_cognitive_account.cognitive_account.identity[0].principal_id
  sensitive   = false
}

output "cognitive_account_endpoint" {
  description = "The base URL of the cognitive service account."
  value       = azurerm_cognitive_account.cognitive_account.endpoint
  sensitive   = false
}

output "cognitive_account_primary_access_key" {
  description = "The primary access key of the cognitive service account."
  value       = azurerm_cognitive_account.cognitive_account.primary_access_key
  sensitive   = true
}

output "cognitive_account_setup_completed" {
  description = "Specifies whether the connectivity and identity has been successfully configured."
  value       = true
  sensitive   = false

  depends_on = [
    time_sleep.sleep_connectivity,
  ]
}
