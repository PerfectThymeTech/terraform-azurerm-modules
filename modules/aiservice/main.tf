resource "azurerm_cognitive_account" "cognitive_account" {
  name                = var.cognitive_account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }

  custom_subdomain_name      = var.cognitive_account_name
  dynamic_throttling_enabled = false
  fqdns = var.customer_managed_key != null && var.cognitive_account_outbound_network_access_restricted ? setunion([
    "${reverse(split("/", var.customer_managed_key.key_vault_id))[0]}.vault.azure.net",
  ], var.cognitive_account_outbound_network_access_allowed_fqdns) : setunion([], var.cognitive_account_outbound_network_access_allowed_fqdns)
  kind               = var.cognitive_account_kind
  local_auth_enabled = var.cognitive_account_local_auth_enabled
  network_acls {
    bypass         = var.cognitive_account_firewall_bypass_azure_services ? "AzureServices" : null
    default_action = "Deny"
    ip_rules       = []
  }
  outbound_network_access_restricted = var.cognitive_account_outbound_network_access_restricted
  public_network_access_enabled      = false
  sku_name                           = var.cognitive_account_sku

  lifecycle {
    ignore_changes = [
      customer_managed_key
    ]
  }
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

resource "azurerm_cognitive_account_customer_managed_key" "cognitive_account_customer_managed_key" {
  count = var.customer_managed_key != null ? 1 : 0

  cognitive_account_id = azurerm_cognitive_account.cognitive_account.id
  key_vault_key_id     = var.customer_managed_key.key_vault_key_id

  depends_on = [
    azurerm_role_assignment.role_assignment_key_vault_crypto_encryption_user_cognitive_account,
  ]
}

# variable "cognitive_account_rai_blocklist_items" {
#   type = map(object({
#     is_regex = bool
#     pattern  = string
#   }))
# }

# resource "azapi_resource" "cognitive_account_rai_policy" {
#   type      = "Microsoft.CognitiveServices/cognitiveAccounts/raiPolicies@2025-09-01"
#   name      = "DefaultRaiPolicy"
#   parent_id = azurerm_cognitive_account.cognitive_account.id

#   body = {
#     properties = {
#       basePolicyName = "Microsoft.DefaultV2"
#       contentFilters = [
#         {
#           name              = "Violence"
#           blockEnabled      = false
#           filterEnabled     = false
#           severityThreshold = "Medium"
#           source            = "Prompt"
#         },
#         {
#           name              = "Hate"
#           blockEnabled      = false
#           filterEnabled     = false
#           severityThreshold = "Medium"
#           source            = "Prompt"
#         },
#         {
#           name              = "Sexual"
#           blockEnabled      = false
#           filterEnabled     = false
#           severityThreshold = "Medium"
#           source            = "Prompt"
#         },
#         {
#           name              = "Selfharm"
#           blockEnabled      = false
#           filterEnabled     = false
#           severityThreshold = "Medium"
#           source            = "Prompt"
#         },
#         {
#           name          = "Jailbreak"
#           blockEnabled  = true
#           filterEnabled = true
#           source        = "Prompt"
#         },
#         {
#           name          = "Indirect Attack"
#           blockEnabled  = true
#           filterEnabled = true
#           source        = "Prompt"
#         },
#         {
#           name          = "Indirect Attack Spotlighting"
#           blockEnabled  = true
#           filterEnabled = true
#           source        = "Prompt"
#         },
#         {
#           name              = "Violence"
#           blockEnabled      = true
#           filterEnabled     = true
#           severityThreshold = "Medium"
#           source            = "Completion"
#         },
#         {
#           name              = "Hate"
#           blockEnabled      = true
#           filterEnabled     = true
#           severityThreshold = "Medium"
#           source            = "Completion"
#         },
#         {
#           name              = "Sexual"
#           blockEnabled      = true
#           filterEnabled     = true
#           severityThreshold = "Medium"
#           source            = "Completion"
#         },
#         {
#           name              = "Selfharm"
#           blockEnabled      = true
#           filterEnabled     = true
#           severityThreshold = "Medium"
#           source            = "Completion"
#         },
#         {
#           name          = "Protected Material Text"
#           blockEnabled  = true
#           filterEnabled = true
#           source        = "Completion"
#         },
#         {
#           name          = "Protected Material Code"
#           blockEnabled  = true
#           filterEnabled = true
#           source        = "Completion"
#         }
#       ]
#       customBlocklists = [
#         {
#           blocking      = true
#           blocklistName = "string"
#           source        = "Completion"
#         }
#       ]
#       customTopics = []
#       mode         = "Asynchronous_filter"
#     }
#   }

#   response_export_values    = []
#   schema_validation_enabled = true
#   locks                     = []
#   ignore_casing             = false
#   ignore_missing_property   = true
# }

# resource "azapi_resource" "cognitive_account_rai_blocklist" {
#   type      = "Microsoft.CognitiveServices/cognitiveAccounts/raiBlocklists@2025-09-01"
#   name      = "DefaultRaiBlocklist"
#   parent_id = azurerm_cognitive_account.cognitive_account.id

#   body = {
#     properties = {
#       description = "Default RAI Blocklist"
#     }
#   }

#   response_export_values    = []
#   schema_validation_enabled = true
#   locks                     = []
#   ignore_casing             = false
#   ignore_missing_property   = true
# }

# resource "azapi_resource" "cognitive_account_rai_blocklist_items" {
#   for_each = var.cognitive_account_rai_blocklist_items

#   type      = "Microsoft.CognitiveServices/cognitiveAccounts/raiBlocklists/raiBlocklistItems@2025-09-01"
#   name      = each.key
#   parent_id = azapi_resource.cognitive_account_rai_blocklist.id

#   body = {
#     properties = {
#       isRegex = each.value.is_regex
#       pattern = each.value.pattern
#     }
#   }

#   response_export_values    = []
#   schema_validation_enabled = true
#   locks                     = []
#   ignore_casing             = false
#   ignore_missing_property   = true
# }
