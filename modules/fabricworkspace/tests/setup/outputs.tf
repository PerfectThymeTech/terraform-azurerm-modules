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
