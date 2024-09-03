output "cosmosdb_account_id" {
  description = "Specifies the resource id of the cosmos db account."
  value       = azurerm_cosmosdb_account.cosmosdb_account.id
  sensitive   = false
}

output "cosmosdb_account_name" {
  description = "Specifies the resource name of the cosmos db account."
  value       = azurerm_cosmosdb_account.cosmosdb_account.name
  sensitive   = false
}

output "cosmosdb_account_endpoint" {
  description = "Specifies the endpoint of the cosmos db account."
  value       = azurerm_cosmosdb_account.cosmosdb_account.endpoint
  sensitive   = false
}

output "cosmosdb_account_read_endpoints" {
  description = "Specifies the list of read endpoints of the cosmos db account."
  value       = azurerm_cosmosdb_account.cosmosdb_account.read_endpoints
  sensitive   = false
}

output "cosmosdb_account_write_endpoints" {
  description = "Specifies the list of write endpoints of the cosmos db account."
  value       = azurerm_cosmosdb_account.cosmosdb_account.write_endpoints
  sensitive   = false
}

output "cosmosdb_account_completed" {
  description = "Specifies whether the connectivity and identity has been successfully configured."
  value       = true
  sensitive   = false

  depends_on = [
    time_sleep.sleep_connectivity,
  ]
}
