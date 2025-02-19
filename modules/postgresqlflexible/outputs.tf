output "postgresql_flexible_server_id" {
  description = "Specifies the resource id of the postgres flexible server."
  value       = azurerm_postgresql_flexible_server.postgresql_flexible_server.id
  sensitive   = false
}

output "postgresql_flexible_server_name" {
  description = "Specifies the resource name of the postgres flexible server."
  value       = azurerm_postgresql_flexible_server.postgresql_flexible_server.name
  sensitive   = false
}

output "postgresql_flexible_server_fqdn" {
  description = "Specifies the fqdn of the postgres flexible server."
  value       = azurerm_postgresql_flexible_server.postgresql_flexible_server.fqdn
  sensitive   = true
}

output "postgresql_flexible_server_setup_completed" {
  description = "Specifies whether the connectivity and identity has been successfully configured."
  value       = true
  sensitive   = false

  depends_on = [
    azurerm_postgresql_flexible_server_active_directory_administrator.postgresql_flexible_server_active_directory_administrator,
    time_sleep.sleep_connectivity,
  ]
}
