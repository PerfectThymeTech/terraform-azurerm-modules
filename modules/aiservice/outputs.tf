output "cognitive_account_id" {
  description = "The ID of the cognitive service account."
  value       = azurerm_cognitive_account.cognitive_account.id
}

output "cognitive_account_endpoint" {
  description = "The base URL of the cognitive service account."
  value       = azurerm_cognitive_account.cognitive_account.endpoint
}

output "cognitive_account_setup_completed" {
  description = "Specifies whether the connectivity and identity has been successfully configured."
  value       = true
  sensitive   = false

  depends_on = [
    time_sleep.sleep_connectivity,
  ]
}
