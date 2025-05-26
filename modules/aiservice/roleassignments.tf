# Key Vault Role Assignments
resource "azurerm_role_assignment" "role_assignment_key_vault_crypto_encryption_user_cognitive_account" {
  count = var.customer_managed_key == null ? 0 : 1

  description          = "Role assignment to allow key read operations."
  scope                = var.customer_managed_key.key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_cognitive_account.cognitive_account.identity[0].principal_id
  principal_type       = "ServicePrincipal"
}
