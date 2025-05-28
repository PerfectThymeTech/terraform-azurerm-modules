resource "azapi_resource" "ai_services_capability_hosts_account" {
  type      = "Microsoft.CognitiveServices/accounts/capabilityHosts@2025-04-01-preview"
  name      = "default"
  parent_id = azurerm_ai_services.ai_services.id

  body = {
    properties = {
      capabilityHostKind = "Agents"
      description        = "Default capability host - account"
    }
  }

  response_export_values    = []
  schema_validation_enabled = false
  locks                     = []
  ignore_casing             = false
  ignore_missing_property   = true

  depends_on = [
    azurerm_role_assignment.role_assignment_aisearch_account_search_index_data_contributor_ai_services_project,
    azurerm_role_assignment.role_assignment_aisearch_account_search_service_contributor_ai_services_project,
    azurerm_role_assignment.role_assignment_cosmosdb_account_operator_ai_services_project,
    azurerm_role_assignment.role_assignment_storage_account_blob_data_contributor_ai_services_project,
  ]
}

resource "azapi_resource" "ai_services_capability_hosts_project" {
  for_each = var.ai_services_projects

  type      = "Microsoft.CognitiveServices/accounts/projects/capabilityHosts@2025-04-01-preview"
  name      = "default-${each.key}"
  parent_id = azapi_resource.ai_services_project[each.key].id

  body = {
    properties = {
      # aiServicesConnections = []
      capabilityHostKind = "Agents"
      description        = "Default capability host - project - ${each.key}"
      storageConnections = local.connections_storage_account
      # tags = var.tags
      threadStorageConnections = local.connections_cosmosdb_account
      vectorStoreConnections   = local.connections_aisearch_account
    }
  }

  response_export_values    = []
  schema_validation_enabled = false
  locks                     = []
  ignore_casing             = false
  ignore_missing_property   = true

  depends_on = [
    azapi_resource.ai_services_capability_hosts_account,
  ]
}
