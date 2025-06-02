locals {
  # Project workspace guids
  project_internal_ids = {
    for key, value in var.ai_services_projects :
    key => azapi_resource.ai_services_project[key].output.properties.internalId
  }
  project_workspace_ids = {
    for key, value in var.ai_services_projects :
    key => "${substr(local.project_internal_ids[key], 0, 8)}-${substr(local.project_internal_ids[key], 8, 4)}-${substr(local.project_internal_ids[key], 12, 4)}-${substr(local.project_internal_ids[key], 16, 4)}-${substr(local.project_internal_ids[key], 20, 12)}"
  }

  # Cosmos DB - SQL database containers
  cosmosdb_account_database_name                                 = "enterprise_memory"
  cosmosdb_account_database_container_thread_message_name        = "thread-message-store"
  cosmosdb_account_database_container_system_thread_message_name = "system-thread-message-store"
  cosmosdb_account_database_container_agent_entity_store_name    = "agent-entity-store"

  # Project - connection map
  map_projects_storage_accounts = merge([
    for project_key, project_value in var.ai_services_projects : {
      for storage_account_key, storage_account_value in var.ai_services_storage_accounts :
      "${project_key}-${storage_account_key}" => {
        project_key                 = project_key
        project_principal_id        = azapi_resource.ai_services_project[project_key].identity[0].principal_id
        storage_account_key         = storage_account_key
        storage_account_resource_id = storage_account_value.resource_id
      }
    }
  ]...)

  map_projects_cosmosdb_accounts = merge([
    for project_key, project_value in var.ai_services_projects : {
      for cosmosdb_account_key, cosmosdb_account_value in var.ai_services_cosmosdb_accounts :
      "${project_key}-${cosmosdb_account_key}" => {
        project_key                  = project_key
        project_principal_id         = azapi_resource.ai_services_project[project_key].identity[0].principal_id
        cosmosdb_account_key         = cosmosdb_account_key
        cosmosdb_account_resource_id = cosmosdb_account_value.resource_id
      }
    }
  ]...)

  map_projects_aisearch_accounts = merge([
    for project_key, project_value in var.ai_services_projects : {
      for aisearch_account_key, aisearch_account_value in var.ai_services_aisearch_accounts :
      "${project_key}-${aisearch_account_key}" => {
        project_key                  = project_key
        project_principal_id         = azapi_resource.ai_services_project[project_key].identity[0].principal_id
        aisearch_account_key         = aisearch_account_key
        aisearch_account_resource_id = aisearch_account_value.resource_id
      }
    }
  ]...)

  # Connection name list
  connections_cosmosdb_account = [
    for key, value in var.ai_services_cosmosdb_accounts :
    azapi_resource.ai_services_connection_cosmosdb_account[key].name
  ]

  connections_storage_account = [
    for key, value in var.ai_services_storage_accounts :
    azapi_resource.ai_services_connection_storage_account[key].name
  ]

  connections_aisearch_account = [
    for key, value in var.ai_services_aisearch_accounts :
    azapi_resource.ai_services_connection_aisearch_accounts[key].name
  ]
}
