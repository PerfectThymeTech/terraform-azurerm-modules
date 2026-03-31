resource "azurerm_mssql_server" "mssql_server" {
  name                = var.mssql_server_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  dynamic "identity" {
    for_each = var.customer_managed_key != null ? [{
      type = "SystemAssigned, UserAssigned"
      identity_ids = [
        var.customer_managed_key.user_assigned_identity_id
      ]
      }] : [{
      type         = "SystemAssigned"
      identity_ids = null
    }]
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  azuread_administrator {
    azuread_authentication_only = true
    login_username              = data.azurerm_client_config.current.client_id
    object_id                   = data.azurerm_client_config.current.object_id
    tenant_id                   = data.azurerm_client_config.current.tenant_id
  }
  connection_policy                            = var.mssql_server_connection_policy
  express_vulnerability_assessment_enabled     = true
  minimum_tls_version                          = "1.2"
  outbound_network_restriction_enabled         = true
  primary_user_assigned_identity_id            = var.customer_managed_key != null ? var.customer_managed_key.user_assigned_identity_id : null
  public_network_access_enabled                = false
  transparent_data_encryption_key_vault_key_id = var.customer_managed_key != null ? var.customer_managed_key.key_vault_key_id : null
  version                                      = var.mssql_server_version
}
