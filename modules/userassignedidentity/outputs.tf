output "user_assigned_identity_id" {
  description = "Specifies the resource id of the user assigned identity."
  value       = azurerm_user_assigned_identity.user_assigned_identity.id
  sensitive   = false
}

output "user_assigned_identity_name" {
  description = "Specifies the name of the user assigned identity."
  value       = azurerm_user_assigned_identity.user_assigned_identity.name
  sensitive   = false
}
