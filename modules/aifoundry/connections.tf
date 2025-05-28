resource "azapi_resource" "ai_services_connection_cosmosdb_account" {
  for_each = var.ai_services_cosmosdb_accounts

  type      = "Microsoft.CognitiveServices/accounts/connections@2025-04-01-preview"
  name      = "cosmosdb-${each.key}"
  parent_id = azurerm_ai_services.ai_services.id

  body = {
    properties = {
      authType      = "AAD"
      category      = "CosmosDb"
      error         = null
      expiryTime    = null
      isSharedToAll = true
      metadata = {
        ApiType    = "Azure"
        ResourceId = each.value.resource_id
        location   = each.value.location
      }
      peRequirement               = "Required"
      target                      = each.value.target
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
}

resource "azapi_resource" "ai_services_connection_storage_account" {
  for_each = var.ai_services_storage_accounts

  type      = "Microsoft.CognitiveServices/accounts/connections@2025-04-01-preview"
  name      = "azurestorageaccount-${each.key}"
  parent_id = azurerm_ai_services.ai_services.id

  body = {
    properties = {
      authType      = "AAD"
      category      = "AzureStorageAccount"
      error         = null
      expiryTime    = null
      isSharedToAll = true
      metadata = {
        ApiType    = "Azure"
        ResourceId = each.value.resource_id
        location   = each.value.location
      }
      peRequirement               = "Required"
      target                      = each.value.target
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
}

resource "azapi_resource" "ai_services_connection_aisearch_accounts" {
  for_each = var.ai_services_aisearch_accounts

  type      = "Microsoft.CognitiveServices/accounts/connections@2025-04-01-preview"
  name      = "cognitivesearch-${each.key}"
  parent_id = azurerm_ai_services.ai_services.id

  body = {
    properties = {
      authType      = "AAD"
      category      = "CognitiveSearch"
      error         = null
      expiryTime    = null
      isSharedToAll = true
      metadata = {
        ApiType    = "Azure"
        ResourceId = each.value.resource_id
        location   = each.value.location
      }
      peRequirement               = "Required"
      target                      = each.value.target
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
}

resource "azapi_resource" "ai_services_connections_account" {
  for_each = var.ai_services_connections_account

  type      = "Microsoft.CognitiveServices/accounts/connections@2025-04-01-preview"
  name      = each.key
  parent_id = azurerm_ai_services.ai_services.id

  body = {
    properties = {
      authType = each.value.auth_type
      credentials = each.value.auth_type == "AAD" || each.value.auth_type == "None" ? null : {
        accessKeyId     = each.value.auth_type == "AccessKey" ? each.value.credentials.access_key_id : null
        secretAccessKey = each.value.auth_type == "AccessKey" ? each.value.credentials.secret_access_key : null
        key             = each.value.auth_type == "AccountKey" || each.value.auth_type == "ApiKey" ? each.value.credentials.key : null
        clientId        = each.value.auth_type == "ManagedIdentity" || each.value.auth_type == "ServicePrincipal" ? each.value.credentials.client_id : null
        clientSecret    = each.value.auth_type == "ServicePrincipal" ? each.value.credentials.client_secret : null
        tenantId        = each.value.auth_type == "ServicePrincipal" ? each.value.credentials.tenant_id : null
        resourceId      = each.value.auth_type == "ManagedIdentity" ? each.value.credentials.resource_id : null
        pat             = each.value.auth_type == "PAT" ? each.value.credentials.pat : null
        sas             = each.value.auth_type == "SAS" ? each.value.credentials.sas : null
      }
      category                    = each.value.category
      error                       = null
      expiryTime                  = null
      isSharedToAll               = true
      metadata                    = each.value.metadata
      peRequirement               = each.value.private_endpoint_requirement
      target                      = each.value.target
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
}
