resource "azurerm_private_endpoint" "private_endpoint_databricks_workspace" {
  for_each = var.private_endpoint_subresource_names

  name                = "${azurerm_databricks_workspace.databricks_workspace.name}-${each.value}-pe"
  location            = var.location
  resource_group_name = azurerm_databricks_workspace.databricks_workspace.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_databricks_workspace.databricks_workspace.name}-${each.value}-nic"
  private_service_connection {
    name                           = "${azurerm_databricks_workspace.databricks_workspace.name}-${each.value}-svc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_databricks_workspace.databricks_workspace.id
    subresource_names              = [each.value]
  }
  subnet_id = var.subnet_id
  dynamic "private_dns_zone_group" {
    for_each = local.private_dns_zones_map[each.value] == "" ? [] : [1]
    content {
      name = "${azurerm_databricks_workspace.databricks_workspace.name}-arecord"
      private_dns_zone_ids = [
        local.private_dns_zones_map[each.value]
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
  create_duration = "${var.connectivity_delay_in_seconds}s"

  depends_on = [
    azurerm_private_endpoint.private_endpoint_databricks_workspace
  ]
}
