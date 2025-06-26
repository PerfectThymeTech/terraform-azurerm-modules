resource "azapi_resource" "ai_services_connection_cosmosdb_project" {
  for_each = local.map_projects_cosmosdb_accounts

  type      = "Microsoft.CognitiveServices/accounts/projects/connections@2025-04-01-preview"
  name      = "cosmosdb-${each.key}"
  parent_id = azapi_resource.ai_services_project[each.value.project_key].id

  body = {
    properties = {
      authType      = "AAD"
      category      = "CosmosDb"
      error         = null
      expiryTime    = null
      isSharedToAll = false
      metadata = {
        ApiType    = "Azure"
        ResourceId = each.value.cosmosdb_account_value.resource_id
        location   = each.value.cosmosdb_account_value.location
      }
      peRequirement               = "NotRequired" # "Required"
      target                      = each.value.cosmosdb_account_value.target
      useWorkspaceManagedIdentity = true
      # peStatus                    = "Active"
      # sharedUserList              = []
    }
  }

  response_export_values    = []
  schema_validation_enabled = false
  locks                     = []
  ignore_casing             = false
  ignore_missing_property   = true

  depends_on = [
    time_sleep.sleep_ai_services_capability_hosts_account,
  ]
}

resource "azapi_resource" "ai_services_connection_storage_project" {
  for_each = local.map_projects_storage_accounts

  type      = "Microsoft.CognitiveServices/accounts/projects/connections@2025-04-01-preview"
  name      = "azurestorageaccount-${each.key}"
  parent_id = azapi_resource.ai_services_project[each.value.project_key].id

  body = {
    properties = {
      authType      = "AAD"
      category      = "AzureStorageAccount"
      error         = null
      expiryTime    = null
      isSharedToAll = false
      metadata = {
        ApiType    = "Azure"
        ResourceId = each.value.storage_account_value.resource_id
        location   = each.value.storage_account_value.location
      }
      peRequirement               = "NotRequired" # "Required"
      target                      = each.value.storage_account_value.target
      useWorkspaceManagedIdentity = true
      # peStatus                    = "Active"
      # sharedUserList              = []
    }
  }

  response_export_values    = []
  schema_validation_enabled = false
  locks                     = []
  ignore_casing             = false
  ignore_missing_property   = true

  depends_on = [
    time_sleep.sleep_ai_services_capability_hosts_account,
  ]
}

resource "azapi_resource" "ai_services_connection_aisearch_project" {
  for_each = local.map_projects_aisearch_accounts

  type      = "Microsoft.CognitiveServices/accounts/projects/connections@2025-04-01-preview"
  name      = "cognitivesearch-${each.key}"
  parent_id = azapi_resource.ai_services_project[each.value.project_key].id

  body = {
    properties = {
      authType      = "AAD"
      category      = "CognitiveSearch"
      error         = null
      expiryTime    = null
      isSharedToAll = false
      metadata = {
        ApiType    = "Azure"
        ResourceId = each.value.aisearch_account_value.resource_id
        location   = each.value.aisearch_account_value.location
      }
      peRequirement               = "NotRequired" # "Required"
      target                      = each.value.aisearch_account_value.target
      useWorkspaceManagedIdentity = true
      # peStatus                    = "Active"
      # sharedUserList              = []
    }
  }

  response_export_values    = []
  schema_validation_enabled = false
  locks                     = []
  ignore_casing             = false
  ignore_missing_property   = true

  depends_on = [
    time_sleep.sleep_ai_services_capability_hosts_account,
  ]
}
