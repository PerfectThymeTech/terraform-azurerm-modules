output "databricks_workspace_id" {
  description = "Specifies the resource id of the Azure Databricks workspace."
  value       = azurerm_databricks_workspace.databricks_workspace.id
  sensitive   = false
}

output "databricks_workspace_name" {
  description = "Specifies the resource name of the Azure Databricks workspace."
  value       = azurerm_databricks_workspace.databricks_workspace.name
  sensitive   = false
}

output "databricks_workspace_workspace_id" {
  description = "Specifies the workspace id of the Azure Databricks workspace."
  value       = azurerm_databricks_workspace.databricks_workspace.workspace_id
  sensitive   = true
}

output "databricks_workspace_workspace_url" {
  description = "Specifies the workspace url of the Azure Databricks workspace."
  value       = azurerm_databricks_workspace.databricks_workspace.workspace_url
  sensitive   = false
}

output "databricks_workspace_completed" {
  description = "Specifies whether the connectivity and identity has been successfully configured."
  value       = true
  sensitive   = false

  depends_on = [
    time_sleep.sleep_connectivity,
  ]
}
