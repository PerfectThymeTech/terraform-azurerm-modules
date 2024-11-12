output "data_factory_id" {
  description = "Specifies the id of the data factory."
  value       = azurerm_data_factory.data_factory.id
  sensitive   = false
}

output "data_factory_name" {
  description = "Specifies the name of the data factory."
  value       = azurerm_data_factory.data_factory.name
  sensitive   = false
}

output "data_factory_principal_id" {
  description = "Specifies the principal id of the data factory."
  value       = azurerm_data_factory.data_factory.identity[0].principal_id
  sensitive   = false
}
