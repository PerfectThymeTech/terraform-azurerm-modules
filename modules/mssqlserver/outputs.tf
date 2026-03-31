output "mssql_server_id" {
  description = "Specifies the SQL Server resource id."
  value       = azurerm_mssql_server.mssql_server.id
  sensitive   = false
}

output "mssql_server_name" {
  description = "Specifies the SQL Server resource name."
  value       = azurerm_mssql_server.mssql_server.name
  sensitive   = false
}

output "mssql_server_fqdn" {
  description = "Specifies the SQL Server fully qualified domain name."
  value       = azurerm_mssql_server.mssql_server.fully_qualified_domain_name
  sensitive   = false
}

output "mssql_server_setup_completed" {
  description = "Specifies whether the connectivity and identity has been successfully configured."
  value       = true
  sensitive   = false

  depends_on = [
    time_sleep.sleep_connectivity,
  ]
}
