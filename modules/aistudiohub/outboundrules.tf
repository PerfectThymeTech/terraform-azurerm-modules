# resource "azapi_resource" "ai_studio_hub_outbound_rules_private_endpoints" { # Will be managed using a separate module due to service limitations: https://github.com/PerfectThymeTech/terraform-azurerm-modules/tree/main/modules/aistudiooutboundrules
#   for_each = local.ai_studio_hub_outbound_rules_private_endpoints

#   type      = "Microsoft.MachineLearningServices/workspaces/outboundRules@2024-04-01"
#   name      = "pe-${each.key}"
#   parent_id = azapi_resource.ai_studio_hub.id

#   body = {
#     properties = {
#       type     = each.value.type
#       category = each.value.category
#       status   = each.value.status
#       destination = {
#         serviceResourceId = each.value.destination.serviceResourceId
#         subresourceTarget = each.value.destination.subresourceTarget
#         sparkEnabled      = each.value.destination.sparkEnabled
#         sparkStatus       = each.value.destination.sparkStatus
#       }
#     }
#   }

#   response_export_values    = []
#   schema_validation_enabled = false # Can be reverted once this is closed: https://github.com/Azure/terraform-provider-azapi/issues/524
#   locks                     = []
#   ignore_casing             = false
#   ignore_missing_property   = true
# }

# resource "azapi_resource" "ai_studio_hub_outbound_rules_service_endpoints" { # Will be managed using a separate module due to service limitations: https://github.com/PerfectThymeTech/terraform-azurerm-modules/tree/main/modules/aistudiooutboundrules
#   for_each = local.ai_studio_hub_outbound_rules_service_endpoints

#   type      = "Microsoft.MachineLearningServices/workspaces/outboundRules@2024-04-01"
#   name      = "se-${each.key}"
#   parent_id = azapi_resource.ai_studio_hub.id

#   body = {
#     properties = {
#       type     = each.value.type
#       category = each.value.category
#       destination = {
#         serviceTag = each.value.destination.serviceTag
#         protocol   = each.value.destination.protocol
#         portRanges = each.value.destination.portRanges
#         action     = each.value.destination.action
#       }
#     }
#   }

#   response_export_values    = []
#   schema_validation_enabled = false # Can be reverted once this is closed: https://github.com/Azure/terraform-provider-azapi/issues/524
#   locks                     = []
#   ignore_casing             = false
#   ignore_missing_property   = true
# }

# resource "azapi_resource" "ai_studio_hub_outbound_rules_fqdns" { # Will be managed using a separate module due to service limitations: https://github.com/PerfectThymeTech/terraform-azurerm-modules/tree/main/modules/aistudiooutboundrules
#   for_each = local.ai_studio_hub_outbound_rules_fqdns

#   type      = "Microsoft.MachineLearningServices/workspaces/outboundRules@2024-04-01"
#   name      = "fq-${each.key}"
#   parent_id = azapi_resource.ai_studio_hub.id

#   body = {
#     properties = {
#       type        = each.value.type
#       category    = each.value.category
#       destination = each.value.destination
#       status      = each.value.status
#     }
#   }

#   response_export_values    = []
#   schema_validation_enabled = false # Can be reverted once this is closed: https://github.com/Azure/terraform-provider-azapi/issues/524
#   locks                     = []
#   ignore_casing             = false
#   ignore_missing_property   = true
# }

resource "azapi_resource_action" "ai_studio_hub_provision_managed_network" {
  count = var.ai_studio_hub_provision_managed_network ? 1 : 0

  type        = "Microsoft.MachineLearningServices/workspaces@2024-04-01"
  resource_id = azapi_resource.ai_studio_hub.id

  action = "provisionManagedNetwork"
  method = "POST"
  body = {
    includeSpark = true
  }

  response_export_values = []
  # depends_on = [
  #   azapi_resource.ai_studio_hub_outbound_rules_private_endpoints,
  #   azapi_resource.ai_studio_hub_outbound_rules_service_endpoints,
  #   azapi_resource.ai_studio_hub_outbound_rules_fqdns,
  # ]

  timeouts {
    create = "60m"
  }
}
