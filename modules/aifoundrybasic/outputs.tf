output "ai_services_id" {
  description = "The ID of the cognitive service account."
  value       = azurerm_cognitive_account.cognitive_account.id
  sensitive   = false
}

output "ai_services_name" {
  description = "The name of the cognitive service account."
  value       = azurerm_cognitive_account.cognitive_account.name
  sensitive   = false
}

output "ai_services_principal_id" {
  description = "The principal id of the cognitive service account."
  value       = azurerm_cognitive_account.cognitive_account.identity[0].principal_id
  sensitive   = false
}

output "ai_services_endpoint" {
  description = "The base URL of the cognitive service account."
  value       = azurerm_cognitive_account.cognitive_account.endpoint
  sensitive   = false
}

output "ai_services_openai_endpoint" {
  description = "The base URL of the open ai endpoint."
  value       = "https://${azurerm_cognitive_account.cognitive_account.name}.openai.azure.com/"
  sensitive   = false
}

output "ai_services_cognitive_endpoint" {
  description = "The base URL of the cognitive service endpoint."
  value       = "https://${azurerm_cognitive_account.cognitive_account.name}.services.ai.azure.com/"
  sensitive   = false
}

output "ai_services_foundry_endpoint" {
  description = "The base URL of the foundry endpoint."
  value       = "https://${azurerm_cognitive_account.cognitive_account.name}.services.ai.azure.com/"
  sensitive   = false
}

output "ai_services_foundry_project_endpoints" {
  description = "The endpoints of the ai foundry projects."
  value       = {
    for key, value in var.ai_services_projects:
    key => azurerm_cognitive_account_project.cognitive_account_project[key].endpoints
  }
  sensitive   = false
}

output "ai_services_primary_access_key" {
  description = "The primary access key of the cognitive service account."
  value       = azurerm_cognitive_account.cognitive_account.primary_access_key
  sensitive   = true
}

output "ai_services_setup_completed" {
  description = "Specifies whether the connectivity and identity has been successfully configured."
  value       = true
  sensitive   = false

  depends_on = [
    time_sleep.sleep_connectivity,
  ]
}
