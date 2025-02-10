output "purview_account_id" {
  description = "Specifies the purview account id."
  value       = azapi_resource.purview_account.id
  sensitive   = false
}

output "purview_account_name" {
  description = "Specifies the purview account name."
  value       = azapi_resource.purview_account.name
  sensitive   = false
}

output "purview_account_principal_id" {
  description = "Specifies the purview account name."
  value       = azapi_resource.purview_account.identity[0].principal_id
  sensitive   = false
}

output "purview_account_endpoints_catalog" {
  description = "Specifies the purview account catalog endpoint."
  value       = azapi_resource.purview_account.output.properties.endpoints.catalog
  sensitive   = false
}

output "purview_account_endpoints_scan" {
  description = "Specifies the purview account scan endpoint."
  value       = azapi_resource.purview_account.output.properties.endpoints.scan
  sensitive   = false
}

output "purview_account_ingestion_storage_id" {
  description = "Specifies the purview account ingestion storage id."
  value       = azapi_resource.purview_account.output.properties.ingestionStorage.id
  sensitive   = false
}

output "purview_account_ingestion_storage_primary_endpoint" {
  description = "Specifies the purview account ingestion storage id."
  value       = azapi_resource.purview_account.output.properties.ingestionStorage.primaryEndpoint
  sensitive   = false
}

output "purview_account_setup_completed" {
  description = "Specifies whether the connectivity and identity has been successfully configured."
  value       = true
  sensitive   = false

  depends_on = [
    time_sleep.sleep_connectivity,
  ]
}
