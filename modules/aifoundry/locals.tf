locals {
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
}
