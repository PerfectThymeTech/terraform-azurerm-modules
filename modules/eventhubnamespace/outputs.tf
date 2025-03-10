output "eventhub_namespace_id" {
  description = "Specifies the resource id of the eventhub namespace."
  value       = azurerm_eventhub_namespace.eventhub_namespace.id
  sensitive   = false
}

output "eventhub_namespace_name" {
  description = "Specifies the resource name of the eventhub namespace."
  value       = azurerm_eventhub_namespace.eventhub_namespace.name
  sensitive   = false
}

output "eventhub_namespace_default_primary_connection_string" {
  description = "Specifies the default primary connection string of the eventhub namespace."
  value       = azurerm_eventhub_namespace.eventhub_namespace.default_primary_connection_string
  sensitive   = true
}

output "eventhub_namespace_default_primary_key" {
  description = "Specifies the default primary key of the eventhub namespace."
  value       = azurerm_eventhub_namespace.eventhub_namespace.default_primary_key
  sensitive   = true
}

output "eventhub_namespace_default_primary_connection_string_alias" {
  description = "Specifies the default primary connection string alias of the eventhub namespace."
  value       = azurerm_eventhub_namespace.eventhub_namespace.default_primary_connection_string_alias
  sensitive   = false
}

output "eventhub_namespace_default_secondary_connection_string" {
  description = "Specifies the default secondary connection string of the eventhub namespace."
  value       = azurerm_eventhub_namespace.eventhub_namespace.default_secondary_connection_string
  sensitive   = true
}

output "eventhub_namespace_default_secondary_key" {
  description = "Specifies the default secondary key of the eventhub namespace."
  value       = azurerm_eventhub_namespace.eventhub_namespace.default_secondary_key
  sensitive   = true
}

output "eventhub_namespace_default_secondary_connection_string_alias" {
  description = "Specifies the default secondary connection string alias of the eventhub namespace."
  value       = azurerm_eventhub_namespace.eventhub_namespace.default_secondary_connection_string_alias
  sensitive   = false
}

output "eventhub_namespace_principal_id" {
  description = "Specifies the principal id of the eventhub namespace."
  value       = azurerm_eventhub_namespace.eventhub_namespace.identity[0].principal_id
  sensitive   = false
}

output "eventhub_namespace_setup_completed" {
  description = "Specifies whether the connectivity and identity has been successfully configured."
  value       = true
  sensitive   = false

  depends_on = [
    time_sleep.sleep_connectivity,
  ]
}
