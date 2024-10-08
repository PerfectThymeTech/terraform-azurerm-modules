output "fabric_capacity_id" {
  description = "Specifies the id of the fabric capacity."
  value       = azapi_resource.fabric_capacity.id
  sensitive   = false
}

output "fabric_capacity_name" {
  description = "Specifies the name of the fabric capacity."
  value       = azapi_resource.fabric_capacity.name
  sensitive   = false
}
