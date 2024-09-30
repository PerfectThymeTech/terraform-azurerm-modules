output "fabric_capacity_id" {
  description = "Specifies the id of the fabric capacity."
  value       = azapi_resource.fabric_capacity.id
  sensitive   = false
}
