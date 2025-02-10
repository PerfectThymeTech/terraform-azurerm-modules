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
  sensitive   = false
}

output "databricks_workspace_workspace_url" {
  description = "Specifies the workspace url of the Azure Databricks workspace."
  value       = azurerm_databricks_workspace.databricks_workspace.workspace_url
  sensitive   = false
}

output "databricks_workspace_managed_resource_group_id" {
  description = "Specifies the id of the managed resource group of the Azure Databricks workspace."
  value       = azurerm_databricks_workspace.databricks_workspace.managed_resource_group_id
  sensitive   = false
}

output "databricks_workspace_managed_resource_group_name" {
  description = "Specifies the name of the managed resource group of the Azure Databricks workspace."
  value       = azurerm_databricks_workspace.databricks_workspace.managed_resource_group_name
  sensitive   = false
}

output "databricks_workspace_managed_storage_account_name" {
  description = "Specifies the name of the managed dbfs storage account of the Azure Databricks workspace."
  value       = azurerm_databricks_workspace.databricks_workspace.custom_parameters[0].storage_account_name
  sensitive   = false
}

output "databricks_workspace_storage_account_identity_principal_id" {
  description = "Specifies the principal id of the managed dbfs storage account of the Azure Databricks workspace."
  value       = try(azurerm_databricks_workspace.databricks_workspace.storage_account_identity[0].principal_id, "")
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
