output "communication_service_id" {
  description = "Specifies the communication service resource id."
  value       = azurerm_communication_service.communication_service.id
  sensitive   = false
}

output "communication_service_name" {
  description = "Specifies the communication service resource name."
  value       = azurerm_communication_service.communication_service.name
  sensitive   = false
}

output "communication_service_hostname" {
  description = "Specifies the communication service hostname."
  value       = azurerm_communication_service.communication_service.hostname
  sensitive   = false
}

output "communication_service_primary_key" {
  description = "Specifies the communication service primary key."
  value       = azurerm_communication_service.communication_service.primary_key
  sensitive   = true
}

output "communication_service_primary_connection_string" {
  description = "Specifies the communication service primary connection string."
  value       = azurerm_communication_service.communication_service.primary_connection_string
  sensitive   = true
}

output "communication_service_secondary_key" {
  description = "Specifies the communication service secondary key."
  value       = azurerm_communication_service.communication_service.secondary_key
  sensitive   = true
}

output "communication_service_secondary_connection_string" {
  description = "Specifies the communication service secondary connection string."
  value       = azurerm_communication_service.communication_service.secondary_connection_string
  sensitive   = true
}
