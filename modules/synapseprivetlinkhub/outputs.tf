output "synapse_private_link_hub_id" {
  description = "Specifies the key vault resource id."
  value       = azurerm_synapse_private_link_hub.synapse_private_link_hub.id
  sensitive   = false
}

output "synapse_private_link_hub_name" {
  description = "Specifies the key vault resource name."
  value       = azurerm_synapse_private_link_hub.synapse_private_link_hub.name
  sensitive   = false
}

output "synapse_private_link_hub_setup_completed" {
  description = "Specifies whether the connectivity and identity has been successfully configured."
  value       = true
  sensitive   = false

  depends_on = [
    time_sleep.sleep_connectivity,
  ]
}
