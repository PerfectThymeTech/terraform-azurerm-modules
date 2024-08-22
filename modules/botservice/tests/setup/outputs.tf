output "application_insights_id" {
  description = "Specifies the resource id of application insights."
  value       = module.application_insights.application_insights_id
  sensitive   = false
}

output "user_assigned_identity_id" {
  description = "Specifies the resource id of the user assigned identity."
  value       = module.user_assigned_identity.user_assigned_identity_id
  sensitive   = false
}

output "user_assigned_identity_client_id" {
  description = "Specifies the client id of the user assigned identity."
  value       = module.user_assigned_identity.user_assigned_identity_client_id
  sensitive   = false
}

output "user_assigned_identity_tenant_id" {
  description = "Specifies the tenant id of the user assigned identity."
  value       = module.user_assigned_identity.user_assigned_identity_tenant_id
  sensitive   = false
}
