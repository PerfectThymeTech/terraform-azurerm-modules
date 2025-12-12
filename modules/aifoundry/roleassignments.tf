# Key Vault Role Assignments
resource "azurerm_role_assignment" "role_assignment_key_vault_crypto_encryption_user_ai_services" {
  count = var.customer_managed_key == null ? 0 : 1

  description          = "Role assignment to allow key read operations."
  scope                = var.customer_managed_key.key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azapi_resource.ai_services.identity[0].principal_id
  principal_type       = "ServicePrincipal"
}

# Storage Account Role Assignments
resource "azurerm_role_assignment" "role_assignment_storage_account_blob_data_contributor_ai_services_project" {
  for_each = local.map_projects_storage_accounts

  description          = "Role assignment for storage write operations."
  scope                = each.value.storage_account_value.resource_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = each.value.project_principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "role_assignment_storage_account_blob_data_owner_ai_services_project" {
  for_each = local.map_projects_storage_accounts

  description          = "Role assignment for storage write operations."
  scope                = each.value.storage_account_value.resource_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = each.value.project_principal_id
  principal_type       = "ServicePrincipal"
  condition_version    = "2.0"
  condition            = <<-EOT
  (
    (
      !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/tags/read'})
      AND
      !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/filter/action'})
      AND
      !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/tags/write'})
    )
    OR
    (
      @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:name] StringStartsWithIgnoreCase '${local.project_workspace_ids[each.value.project_key]}'
      AND
      @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:name] StringLikeIgnoreCase '*-azureml-agent'
    )
  )
  EOT
}

# Cosmos DB Role Assignments
resource "azurerm_role_assignment" "role_assignment_cosmosdb_account_operator_ai_services_project" {
  for_each = local.map_projects_cosmosdb_accounts

  description          = "Role assignment for cosmos write operations."
  scope                = each.value.cosmosdb_account_value.resource_id
  role_definition_name = "Cosmos DB Operator"
  principal_id         = each.value.project_principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_cosmosdb_sql_role_assignment" "cosmosdb_sql_role_assignment_thread_message_store_ai_services_project" {
  for_each = local.map_projects_cosmosdb_accounts

  resource_group_name = split("/", each.value.cosmosdb_account_value.resource_id)[4]
  account_name        = reverse(split("/", each.value.cosmosdb_account_value.resource_id))[0]
  role_definition_id  = data.azurerm_cosmosdb_sql_role_definition.cosmosdb_sql_role_definition[each.value.cosmosdb_account_key].id
  principal_id        = each.value.project_principal_id
  scope               = "${each.value.cosmosdb_account_value.resource_id}/dbs/${local.cosmosdb_account_database_name}/colls/${local.project_workspace_ids[each.value.project_key]}-${local.cosmosdb_account_database_container_thread_message_name}"

  depends_on = [
    azapi_resource.ai_services_capability_hosts_project,
  ]
}

resource "azurerm_cosmosdb_sql_role_assignment" "cosmosdb_sql_role_assignment_system_thread_message_store_ai_services_project" {
  for_each = local.map_projects_cosmosdb_accounts

  resource_group_name = split("/", each.value.cosmosdb_account_value.resource_id)[4]
  account_name        = reverse(split("/", each.value.cosmosdb_account_value.resource_id))[0]
  role_definition_id  = data.azurerm_cosmosdb_sql_role_definition.cosmosdb_sql_role_definition[each.value.cosmosdb_account_key].id
  principal_id        = each.value.project_principal_id
  scope               = "${each.value.cosmosdb_account_value.resource_id}/dbs/${local.cosmosdb_account_database_name}/colls/${local.project_workspace_ids[each.value.project_key]}-${local.cosmosdb_account_database_container_system_thread_message_name}"

  depends_on = [
    azapi_resource.ai_services_capability_hosts_project,
  ]
}

resource "azurerm_cosmosdb_sql_role_assignment" "cosmosdb_sql_role_assignment_agent_entity_store_ai_services_project" {
  for_each = local.map_projects_cosmosdb_accounts

  resource_group_name = split("/", each.value.cosmosdb_account_value.resource_id)[4]
  account_name        = reverse(split("/", each.value.cosmosdb_account_value.resource_id))[0]
  role_definition_id  = data.azurerm_cosmosdb_sql_role_definition.cosmosdb_sql_role_definition[each.value.cosmosdb_account_key].id
  principal_id        = each.value.project_principal_id
  scope               = "${each.value.cosmosdb_account_value.resource_id}/dbs/${local.cosmosdb_account_database_name}/colls/${local.project_workspace_ids[each.value.project_key]}-${local.cosmosdb_account_database_container_agent_entity_store_name}"

  depends_on = [
    azapi_resource.ai_services_capability_hosts_project,
  ]
}

# AI Search Role Assignments
resource "azurerm_role_assignment" "role_assignment_aisearch_account_search_index_data_contributor_ai_services_project" {
  for_each = local.map_projects_aisearch_accounts

  description          = "Role assignment for ai search write operations."
  scope                = each.value.aisearch_account_value.resource_id
  role_definition_name = "Search Index Data Contributor"
  principal_id         = each.value.project_principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "role_assignment_aisearch_account_search_service_contributor_ai_services_project" {
  for_each = local.map_projects_aisearch_accounts

  description          = "Role assignment for ai search write operations."
  scope                = each.value.aisearch_account_value.resource_id
  role_definition_name = "Search Service Contributor"
  principal_id         = each.value.project_principal_id
  principal_type       = "ServicePrincipal"
}
