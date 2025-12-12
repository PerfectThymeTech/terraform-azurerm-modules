output "ai_services_id" {
  description = "The ID of the cognitive service account."
  value       = azapi_resource.ai_services.id
  sensitive   = false
}

output "ai_services_name" {
  description = "The name of the cognitive service account."
  value       = azapi_resource.ai_services.name
  sensitive   = false
}

output "ai_services_principal_id" {
  description = "The principal id of the cognitive service account."
  value       = azapi_resource.ai_services.identity[0].principal_id
  sensitive   = false
}

output "ai_services_endpoint" {
  description = "The base URL of the cognitive service account."
  value       = data.azurerm_cognitive_account.ai_services.endpoint
  sensitive   = false
}

output "ai_services_primary_access_key" {
  description = "The primary access key of the cognitive service account."
  value       = data.azurerm_cognitive_account.ai_services.primary_access_key
  sensitive   = true
}

output "ai_services_setup_completed" {
  description = "Specifies whether the connectivity and identity has been successfully configured."
  value       = true
  sensitive   = false

  depends_on = [
    time_sleep.sleep_connectivity,
    azurerm_cosmosdb_sql_role_assignment.cosmosdb_sql_role_assignment_agent_entity_store_ai_services_project,
    azurerm_cosmosdb_sql_role_assignment.cosmosdb_sql_role_assignment_thread_message_store_ai_services_project,
    azurerm_cosmosdb_sql_role_assignment.cosmosdb_sql_role_assignment_system_thread_message_store_ai_services_project,
  ]
}
