resource "azurerm_cognitive_account" "cognitive_account" {
  name                = var.cognitive_account_name
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

  custom_subdomain_name = var.cognitive_account_name
  dynamic "customer_managed_key" {
    for_each = var.customer_managed_key != null ? [1] : []
    content {
      identity_client_id = var.customer_managed_key.user_assigned_identity_client_id
      key_vault_key_id   = var.customer_managed_key.key_vault_key_versionless_id
    }
  }
  dynamic_throttling_enabled = false
  fqdns = var.customer_managed_key != null && var.cognitive_account_outbound_network_access_restricted ? setunion([
    "${reverse(split(var.customer_managed_key.key_vault_id, "/"))[0]}.vault.azure.net",
  ], var.cognitive_account_outbound_network_access_allowed_fqdns) : setunion([], var.cognitive_account_outbound_network_access_allowed_fqdns)
  kind               = var.cognitive_account_kind
  local_auth_enabled = false
  network_acls {
    default_action = "Deny"
    ip_rules       = []
  }
  outbound_network_access_restricted = var.cognitive_account_outbound_network_access_restricted
  public_network_access_enabled      = false
  sku_name                           = var.cognitive_account_sku
}

resource "azapi_update_resource" "cognitive_account_bypass_azureservices" {
  count       = var.cognitive_account_firewall_bypass_azure_services ? 1 : 0
  type        = "Microsoft.CognitiveServices/accounts@2023-05-01"
  resource_id = azurerm_cognitive_account.cognitive_account.id

  body = jsonencode({
    properties = {
      networkAcls = {
        bypass              = "AzureServices"
        defaultAction       = "Deny"
        ipRules             = []
        virtualNetworkRules = []
      }
      publicNetworkAccess = "Disabled"
    }
  })

  response_export_values  = []
  locks                   = []
  ignore_casing           = false
  ignore_missing_property = false
}

resource "azurerm_cognitive_deployment" "cognitive_deployments" {
  for_each = var.cognitive_account_deployments

  name                 = each.value.model_name
  cognitive_account_id = azurerm_cognitive_account.cognitive_account.id

  model {
    format  = "OpenAI"
    name    = each.value.model_name
    version = each.value.model_version
  }
  sku {
    name     = each.value.sku_name
    tier     = each.value.sku_tier
    size     = each.value.sku_size
    family   = each.value.sku_family
    capacity = each.value.sku_capacity
  }
}
