output "databricks_access_connector_id" {
  description = "Specifies the id of the databricks access connector."
  value       = module.databricks_access_connector.databricks_access_connector_id
  sensitive   = false
}

output "databricks_private_subnet_name" {
  description = "Specifies the name of the databricks private subnets."
  value       = azapi_resource.databricks_private_subnet.name
  sensitive   = false
}

output "databricks_private_subnet_network_security_group_association_id" {
  description = "Specifies the id of the databricks private subnets nsg association."
  value       = azapi_resource.databricks_private_subnet.id
  sensitive   = false
}

output "databricks_public_subnet_name" {
  description = "Specifies the name of the databricks public subnets."
  value       = azapi_resource.databricks_public_subnet.name
  sensitive   = false
}

output "databricks_public_subnet_network_security_group_association_id" {
  description = "Specifies the id of the databricks public subnets nsg association."
  value       = azapi_resource.databricks_public_subnet.id
  sensitive   = false
}
