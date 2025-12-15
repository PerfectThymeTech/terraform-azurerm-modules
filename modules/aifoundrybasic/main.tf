resource "azurerm_cognitive_account" "cognitive_account" {
  name                = var.ai_services_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }

  custom_subdomain_name      = var.ai_services_name
  dynamic_throttling_enabled = false
  fqdns = var.customer_managed_key != null && var.ai_services_outbound_network_access_restricted ? setunion([
    "${reverse(split("/", var.customer_managed_key.key_vault_id))[0]}.vault.azure.net",
  ], var.ai_services_outbound_network_access_allowed_fqdns) : setunion([], var.ai_services_outbound_network_access_allowed_fqdns)
  kind               = "AIServices"
  local_auth_enabled = !var.ai_services_local_auth_enabled
  network_acls {
    bypass         = var.ai_services_firewall_bypass_azure_services ? "AzureServices" : null
    default_action = "Deny"
    ip_rules       = []
  }
  outbound_network_access_restricted = var.ai_services_outbound_network_access_restricted
  public_network_access_enabled      = false
  sku_name                           = var.ai_services_sku

  lifecycle {
    ignore_changes = [
      customer_managed_key
    ]
  }
}

resource "azurerm_cognitive_account_project" "cognitive_account_project" {
  for_each = var.ai_services_projects

  cognitive_account_id = azurerm_cognitive_account.cognitive_account.id
  name                 = each.key
  location             = var.location
  tags                 = var.tags
  identity {
    type = "SystemAssigned"
  }

  description  = each.value.description == "" ? "Azure AI Foundry Project - ${each.key}" : each.value.description
  display_name = each.value.display_name == "" ? "Azure AI Foundry Project - ${var.ai_services_name}-${each.key}" : each.value.display_name
}

resource "azurerm_cognitive_deployment" "cognitive_deployments" {
  for_each = var.ai_services_deployments

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

resource "azurerm_cognitive_account_customer_managed_key" "cognitive_account_customer_managed_key" {
  count = var.customer_managed_key != null ? 1 : 0

  cognitive_account_id = azurerm_cognitive_account.cognitive_account.id
  key_vault_key_id     = var.customer_managed_key.key_vault_key_id

  depends_on = [
    azurerm_role_assignment.role_assignment_key_vault_crypto_encryption_user_cognitive_account,
  ]
}
