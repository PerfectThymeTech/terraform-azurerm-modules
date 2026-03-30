output "eventgrid_namespace_id" {
  description = "Specifies the Event Grid Namespace resource id."
  value       = azurerm_eventgrid_namespace.eventgrid_namespace.id
  sensitive   = false
}

output "eventgrid_namespace_name" {
  description = "Specifies the Event Grid Namespace resource name."
  value       = azurerm_eventgrid_namespace.eventgrid_namespace.name
  sensitive   = false
}

output "eventgrid_namespace_setup_completed" {
  description = "Specifies whether the connectivity and identity has been successfully configured."
  value       = true
  sensitive   = false

  depends_on = [
    time_sleep.sleep_connectivity,
  ]
}
