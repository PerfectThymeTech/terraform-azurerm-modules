output "search_service_id" {
  description = "The id of the ai search service."
  value       = azurerm_search_service.search_service.id
}

output "search_service_name" {
  description = "The name of the ai search service."
  value       = azurerm_search_service.search_service.name
}

output "search_service_setup_completed" {
  description = "Specifies whether the connectivity and identity has been successfully configured."
  value       = true
  sensitive   = false

  depends_on = [
    time_sleep.sleep_connectivity,
  ]
}
