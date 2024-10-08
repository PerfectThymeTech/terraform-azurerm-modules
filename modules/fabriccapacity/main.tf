resource "azapi_resource" "fabric_capacity" {
  type      = "Microsoft.Fabric/capacities@2023-11-01"
  name      = var.fabric_capacity_name
  location  = var.location
  parent_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"
  tags      = var.tags

  body = {
    properties = {
      administration = {
        members = setunion([data.azurerm_client_config.current.object_id], var.fabric_capacity_admin_emails)
      }
    }
    sku = {
      name = var.fabric_capacity_sku
      tier = "Fabric"
    }
  }

  response_export_values    = []
  schema_validation_enabled = true
  locks                     = []
  ignore_casing             = false
  ignore_missing_property   = true
}
