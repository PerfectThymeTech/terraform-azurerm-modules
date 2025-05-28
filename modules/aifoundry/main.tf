resource "azurerm_ai_services" "ai_services" {
  name                = var.ai_services_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }

  custom_subdomain_name = var.ai_services_name
  fqdns = var.customer_managed_key != null && var.ai_services_outbound_network_access_restricted ? setunion([
    "${reverse(split("/", var.customer_managed_key.key_vault_id))[0]}.vault.azure.net",
  ], var.ai_services_outbound_network_access_allowed_fqdns) : setunion([], var.ai_services_outbound_network_access_allowed_fqdns)
  local_authentication_enabled = var.ai_services_local_auth_enabled
  network_acls {
    bypass         = var.ai_services_firewall_bypass_azure_services ? "AzureServices" : null
    default_action = "Allow" # "Deny"
    ip_rules       = []
  }
  outbound_network_access_restricted = var.ai_services_outbound_network_access_restricted
  public_network_access              = "Enabled" # "Disabled"
  sku_name                           = var.ai_services_sku

  lifecycle {
    ignore_changes = [
      customer_managed_key
    ]
  }
}

resource "azapi_resource" "ai_services_project" {
  for_each = var.ai_services_projects

  type      = "Microsoft.CognitiveServices/accounts/projects@2025-04-01-preview"
  name      = each.key
  location  = var.location
  parent_id = azurerm_ai_services.ai_services.id
  tags      = var.tags
  identity {
    type = "SystemAssigned"
  }

  body = {
    properties = {
      description = each.value.description == "" ? "Azure AI Foundry Project - ${each.key}" : each.value.description
      displayName = each.value.display_name == "" ? "AI Foundry Project - ${var.ai_services_name}-${each.key}" : each.value.display_name
    }
  }

  response_export_values    = []
  schema_validation_enabled = true
  locks                     = []
  ignore_casing             = false
  ignore_missing_property   = true
}

resource "azapi_resource" "ai_services_capability_hosts" {
  type      = "Microsoft.CognitiveServices/accounts/capabilityHosts@2025-04-01-preview"
  name      = "capability-host-account"
  parent_id = azurerm_ai_services.ai_services.id

  body = {
    properties = {
      aiServicesConnections = []
      capabilityHostKind = "Agents"
      # customerSubnet = ""
      description = "Capability host - account"
      storageConnections = []
      # tags = var.tags
      threadStorageConnections = []
      vectorStoreConnections = []
    }
  }

  response_export_values    = []
  schema_validation_enabled = false
  locks                     = []
  ignore_casing             = false
  ignore_missing_property   = true
}

resource "azurerm_cognitive_deployment" "ai_services_deployments" {
  for_each = var.ai_services_deployments

  name                 = each.value.model_name
  cognitive_account_id = azurerm_ai_services.ai_services.id

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

resource "azurerm_cognitive_account_customer_managed_key" "ai_services_customer_managed_key" {
  count = var.customer_managed_key != null ? 1 : 0

  cognitive_account_id = azurerm_ai_services.ai_services.id
  key_vault_key_id     = var.customer_managed_key.key_vault_key_id

  depends_on = [
    azurerm_role_assignment.role_assignment_key_vault_crypto_encryption_user_ai_services,
  ]
}
