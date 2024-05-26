output "log_analytics_workspace_id" {
  value       = azurerm_log_analytics_workspace.log_analytics_workspace.id
  description = "Specifies the resource ID of the log analytics workspace."
  sensitive   = false
}

output "log_analytics_workspace_name" {
  value       = azurerm_log_analytics_workspace.log_analytics_workspace.name
  description = "Specifies the name of the log analytics workspace."
  sensitive   = true
}
