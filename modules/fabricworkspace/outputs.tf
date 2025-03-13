output "fabric_workspace_id" {
  description = "Specifies the id of the fabric workspace."
  value       = fabric_workspace.workspace.id
  sensitive   = false
}

output "fabric_workspace_name" {
  description = "Specifies the name of the fabric workspace."
  value       = fabric_workspace.workspace.display_name
  sensitive   = false
}

output "fabric_workspace_principal_id" {
  description = "Specifies the principal id of the fabric workspace."
  value       = fabric_workspace.workspace.identity.service_principal_id
  sensitive   = false
}

output "fabric_workspace_application_id" {
  description = "Specifies the application id of the fabric workspace."
  value       = fabric_workspace.workspace.identity.application_id
  sensitive   = false
}

output "fabric_workspace_blob_endpoint" {
  description = "Specifies the blob enpoint of the fabric workspace."
  value       = fabric_workspace.workspace.onelake_endpoints.blob_endpoint
  sensitive   = false
}

output "fabric_workspace_dfs_endpoint" {
  description = "Specifies the dfs enpoint of the fabric workspace."
  value       = fabric_workspace.workspace.onelake_endpoints.dfs_endpoint
  sensitive   = false
}
