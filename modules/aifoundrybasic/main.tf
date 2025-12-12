resource "azapi_resource" "ai_services" {
  type      = "Microsoft.CognitiveServices/accounts@2025-09-01"
  name      = var.ai_services_name
  location  = var.location
  parent_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"
  tags      = var.tags
  identity {
    type = "SystemAssigned"
  }

  body = {
    kind = "AIServices"
    properties = {
      allowedFqdnList = var.customer_managed_key != null && var.ai_services_outbound_network_access_restricted ? setunion([
        "${reverse(split("/", var.customer_managed_key.key_vault_id))[0]}.vault.azure.net",
      ], var.ai_services_outbound_network_access_allowed_fqdns) : setunion([], var.ai_services_outbound_network_access_allowed_fqdns)
      allowProjectManagement     = true
      customSubDomainName        = var.ai_services_name
      disableLocalAuth           = !var.ai_services_local_auth_enabled
      dynamic_throttling_enabled = false
      networkAcls = {
        bypass              = var.ai_services_firewall_bypass_azure_services ? "AzureServices" : null
        defaultAction       = "Deny"
        ipRules             = []
        virtualNetworkRules = []
      }
      publicNetworkAccess           = "Disabled"
      restrictOutboundNetworkAccess = false # var.ai_services_outbound_network_access_restricted # Not yet supported and causes deployment failures
    }
    sku = {
      name = "S0"
    }
  }

  response_export_values    = []
  schema_validation_enabled = false
  locks                     = []
  ignore_casing             = false
  ignore_missing_property   = true
  lifecycle {
    ignore_changes = [
      body.properties.associatedProjects,
      body.properties.defaultProject,
      body.properties.encryption,
    ]
  }
}

resource "azapi_resource" "ai_services_project" {
  for_each = var.ai_services_projects

  type      = "Microsoft.CognitiveServices/accounts/projects@2025-06-01"
  name      = each.key
  location  = var.location
  parent_id = azapi_resource.ai_services.id
  # tags      = var.tags
  identity {
    type = "SystemAssigned"
  }

  body = {
    properties = {
      description = each.value.description == "" ? "Azure AI Foundry Project - ${each.key}" : each.value.description
      displayName = each.value.display_name == "" ? "Azure AI Foundry Project - ${var.ai_services_name}-${each.key}" : each.value.display_name
    }
  }

  response_export_values    = ["properties.internalId"]
  schema_validation_enabled = false
  locks                     = []
  ignore_casing             = false
  ignore_missing_property   = true
}

resource "azurerm_cognitive_deployment" "ai_services_deployments" {
  for_each = var.ai_services_deployments

  name                 = each.value.model_name
  cognitive_account_id = azapi_resource.ai_services.id

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

  cognitive_account_id = azapi_resource.ai_services.id
  key_vault_key_id     = var.customer_managed_key.key_vault_key_id

  depends_on = [
    azurerm_role_assignment.role_assignment_key_vault_crypto_encryption_user_ai_services,
  ]
}
