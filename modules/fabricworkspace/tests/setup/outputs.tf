output "fabric_capacity_id" {
  description = "Specifies the id of the fabric capacity."
  value       = module.fabric_capacity.fabric_capacity_id
  sensitive   = false
}

output "fabric_capacity_name" {
  description = "Specifies the name of the fabric capacity."
  value       = module.fabric_capacity.fabric_capacity_name
  sensitive   = false
}

output "client_config_object_id" {
  description = "Specifies the object id of the client."
  value       = data.azurerm_client_config.current.object_id
  sensitive   = false
}
