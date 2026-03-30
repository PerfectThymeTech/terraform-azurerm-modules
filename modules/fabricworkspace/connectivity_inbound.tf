resource "azapi_resource" "fabric_private_link_service" {
  count = var.workspace_private_endpoint_enabled ? 1 : 0

  type      = "Microsoft.Fabric/privateLinkServicesForFabric@2024-06-01"
  name      = "${fabric_workspace.workspace.id}-pls"
  location  = "global"
  parent_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"
  tags      = var.tags

  body = {
    properties = {
      tenantId    = data.azurerm_client_config.current.tenant_id
      workspaceId = fabric_workspace.workspace.id
    }
  }

  response_export_values    = []
  schema_validation_enabled = false
  locks                     = []
  ignore_casing             = false
  ignore_missing_property   = true
}

resource "azurerm_private_endpoint" "private_endpoint_workspace" {
  count = var.workspace_private_endpoint_enabled ? 1 : 0

  name                = "${one(azapi_resource.fabric_private_link_service[*].id)}-workspace-pe"
  location            = var.location
  resource_group_name = azurerm_data_factory.data_factory.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${one(azapi_resource.fabric_private_link_service[*].id)}-workspace-nic"
  private_service_connection {
    name                           = "${one(azapi_resource.fabric_private_link_service[*].id)}-workspace-svc"
    is_manual_connection           = false
    private_connection_resource_id = one(azapi_resource.fabric_private_link_service[*].id)
    subresource_names              = ["workspace"]
  }
  subnet_id = var.subnet_id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_workspace == "" ? [] : [1]
    content {
      name = "${one(azapi_resource.fabric_private_link_service[*].id)}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_workspace
      ]
    }
  }

  lifecycle {
    ignore_changes = [
      private_dns_zone_group
    ]
  }
}

resource "time_sleep" "sleep_connectivity" {
  count = var.workspace_private_endpoint_enabled ? 1 : 0

  create_duration = "${var.connectivity_delay_in_seconds}s"

  depends_on = [
    azurerm_private_endpoint.private_endpoint_workspace,
  ]
}
