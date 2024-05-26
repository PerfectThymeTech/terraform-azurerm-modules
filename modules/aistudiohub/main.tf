resource "azapi_resource" "ai_studio_hub" {
  type      = "Microsoft.MachineLearningServices/workspaces@2023-10-01"
  name      = var.ai_studio_name
  location  = var.location
  parent_id = "/szbscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"
  tags      = var.tags
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

  body = jsonencode({
    kind = "Hub"
    properties = {
      applicationInsights = var.application_insights_id
      containerRegistry   = var.container_registry_id
      keyVault            = var.key_vault_id
      storageAccount      = var.storage_account_id

      allowPublicAccessWhenBehindVnet = false
      description                     = "Azure AI Studio Hub"
      # encryption = {
      #   keyVaultProperties = {
      #     keyIdentifier = ""
      #     keyVaultArmId = ""
      #     identityClientId = ""
      #   }
      #   status = "Enabled"
      #   identity = {
      #     userAssignedIdentity = ""
      #   }
      # }
      # featureStoreSettings = {
      #   computeRuntime = {
      #     sparkRuntimeVersion = "3.4"
      #   }
      #   offlineStoreConnectionName = ""
      #   onlineStoreConnectionName = ""
      # }
      friendlyName      = title(replace(var.ai_studio_name, "-", " "))
      hbiWorkspace      = true
      imageBuildCompute = null
      managedNetwork = {
        isolationMode = "AllowOnlyApprovedOutbound"
        outboundRules = {
          # TODO
        }
        status = {
          sparkReady = true
          status     = "Active"
        }
      }
      primaryUserAssignedIdentity = null
      publicNetworkAccess         = "Disabled"
      v1LegacyMode                = false
    }
    sku = {
      name = "Basic"
      tier = "Basic"
    }
  })

  response_export_values    = ["*"]
  schema_validation_enabled = true
  locks                     = []
  ignore_body_changes       = []
  ignore_casing             = false
  ignore_missing_property   = false
}
