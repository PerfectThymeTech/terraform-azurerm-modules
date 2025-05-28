# Key Vault Role Assignments
resource "azurerm_role_assignment" "role_assignment_key_vault_crypto_encryption_user_ai_services" {
  count = var.customer_managed_key == null ? 0 : 1

  description          = "Role assignment to allow key read operations."
  scope                = var.customer_managed_key.key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_ai_services.ai_services.identity[0].principal_id
  principal_type       = "ServicePrincipal"
}

# Storage Account Role Assignments
resource "azurerm_role_assignment" "role_assignment_storage_account_blob_data_contributor_ai_services_project" {
  for_each = local.map_projects_storage_accounts

  description          = "Role assignment for storage write operations."
  scope                = each.value.storage_account_resource_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = each.value.project_principal_id
  principal_type       = "ServicePrincipal"
}

# Cosmos DB Role Assignments
resource "azurerm_role_assignment" "role_assignment_cosmosdb_account_operator_ai_services_project" {
  for_each =local.map_projects_cosmosdb_accounts

  description          = "Role assignment for cosmos write operations."
  scope                = each.value.cosmosdb_account_resource_id
  role_definition_name = "Cosmos DB Operator"
  principal_id         = each.value.project_principal_id
  principal_type       = "ServicePrincipal"
}

# AI Search Role Assignments
resource "azurerm_role_assignment" "role_assignment_aisearch_account_search_index_data_contributor_ai_services_project" {
  for_each = local.map_projects_aisearch_accounts

  description          = "Role assignment for ai search write operations."
  scope                = each.value.aisearch_account_resource_id
  role_definition_name = "Search Index Data Contributor"
  principal_id         = each.value.project_principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "role_assignment_aisearch_account_search_service_contributor_ai_services_project" {
  for_each = local.map_projects_aisearch_accounts

  description          = "Role assignment for ai search write operations."
  scope                = each.value.aisearch_account_resource_id
  role_definition_name = "Search Service Contributor"
  principal_id         = each.value.project_principal_id
  principal_type       = "ServicePrincipal"
}
