output "search_service_id" {
  description = "Specifies the resource id of the ai search service."
  value       = azurerm_search_service.search_service.id
  sensitive   = false
}

output "search_service_name" {
  description = "Specifies the name of the ai search service."
  value       = azurerm_search_service.search_service.name
  sensitive   = false
}

output "search_service_principal_id" {
  description = "Specifies the principal id of the ai search service."
  value       = azurerm_search_service.search_service.identity[0].principal_id
  sensitive   = false
}

output "search_service_primary_key" {
  description = "Specifies the primary key of the ai search service."
  value       = azurerm_search_service.search_service.primary_key
  sensitive   = true
}

output "search_service_setup_completed" {
  description = "Specifies whether the connectivity and identity has been successfully configured."
  value       = true
  sensitive   = false

  depends_on = [
    time_sleep.sleep_connectivity,
  ]
}
