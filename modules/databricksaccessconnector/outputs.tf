output "databricks_access_connector_id" {
  description = "Specifies the resource id of the Azure Databricks access connector."
  value       = azurerm_databricks_access_connector.databricks_access_connector.id
  sensitive   = false
}

output "databricks_access_connector_name" {
  description = "Specifies the resource name of the Azure Databricks access connector."
  value       = azurerm_databricks_access_connector.databricks_access_connector.name
  sensitive   = false
}

output "databricks_access_connector_principal_id" {
  description = "Specifies the principal id of the Azure Databricks access connector."
  value       = azurerm_databricks_access_connector.databricks_access_connector.identity[0].principal_id
  sensitive   = true
}
