output "data_factory_id" {
  description = "Specifies the id of the data factory."
  value       = azurerm_data_factory.data_factory.id
  sensitive   = false
}

output "fabric_capacity_name" {
  description = "Specifies the name of the data factory."
  value       = azurerm_data_factory.data_factory.name
  sensitive   = false
}
