resource "azapi_update_resource" "ai_studio_hub_outbound_rules" {
  type        = "Microsoft.MachineLearningServices/workspaces@2024-04-01"
  resource_id = var.ai_studio_hub_id

  body = jsonencode({
    properties = {
      managedNetwork = {
        isolationMode = "AllowOnlyApprovedOutbound"
        outboundRules = local.ai_studio_hub_outbound_rules
        status = {
          sparkReady = true
          status     = "Active"
        }
      }
    }
  })

  response_export_values  = []
  locks                   = []
  ignore_casing           = false
  ignore_missing_property = false
}

resource "azapi_resource_action" "ai_studio_hub_provision_managed_network" {
  count = var.ai_studio_hub_provision_managed_network ? 1 : 0

  type        = "Microsoft.MachineLearningServices/workspaces@2024-04-01"
  resource_id = var.ai_studio_hub_id

  action = "provisionManagedNetwork"
  method = "POST"
  body = jsonencode({
    includeSpark = true
  })

  response_export_values = []
  depends_on             = []
}
