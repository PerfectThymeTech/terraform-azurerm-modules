# Key Vault Role Assignments
resource "azurerm_role_assignment" "role_assignment_key_vault_crypto_encryption_user_databricks_managed_disk_identity" {
  count = var.customer_managed_key == null ? 0 : 1

  description          = "Role assignment to allow key read operations."
  scope                = module.key_vault.key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_databricks_workspace.databricks_workspace.managed_disk_identity[0].principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "role_assignment_key_vault_crypto_encryption_user_databricks_storage_account_identity" {
  count = var.customer_managed_key == null ? 0 : 1

  description          = "Role assignment to allow key read operations."
  scope                = module.key_vault.key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_databricks_workspace.databricks_workspace.storage_account_identity[0].principal_id
  principal_type       = "ServicePrincipal"
}
