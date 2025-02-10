resource "azapi_resource" "purview_account" {
  type      = "Microsoft.Purview/accounts@2024-04-01-preview"
  name      = var.purview_account_name
  location  = var.location
  parent_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"
  tags      = var.tags
  identity {
    type         = "SystemAssigned"
    identity_ids = []
  }

  body = {
    sku = {
      name     = "Standard"
      capacity = 1
    }
    properties = {
      # cloudConnectors = null # Causes plan issues
      ingestionStorage = {
        publicNetworkAccess = "Disabled"
      }
      managedEventHubState                = "Disabled"
      managedResourceGroupName            = "${var.purview_account_name}-rg"
      managedResourcesPublicNetworkAccess = "Disabled"
      publicNetworkAccess                 = "Enabled"
      tenantEndpointState                 = "Enabled"
    }
  }

  response_export_values    = ["*"]
  schema_validation_enabled = true
  locks                     = []
  ignore_casing             = false
  ignore_missing_property   = true
}
