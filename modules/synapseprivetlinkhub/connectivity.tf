resource "azurerm_private_endpoint" "private_endpoint_synapse_private_link_hub_web" {
  name                = "${azurerm_synapse_private_link_hub.synapse_private_link_hub.name}-web-pe"
  location            = azurerm_synapse_private_link_hub.synapse_private_link_hub.location
  resource_group_name = azurerm_synapse_private_link_hub.synapse_private_link_hub.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_synapse_private_link_hub.synapse_private_link_hub.name}-web-nic"
  private_service_connection {
    name                           = "${azurerm_synapse_private_link_hub.synapse_private_link_hub.name}-web-svc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_synapse_private_link_hub.synapse_private_link_hub.id
    subresource_names              = ["web"]
  }
  subnet_id = var.subnet_id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_synapse_portal == "" ? [] : [1]
    content {
      name = "${azurerm_synapse_private_link_hub.synapse_private_link_hub.name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_synapse_portal
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
    azurerm_private_endpoint.private_endpoint_synapse_private_link_hub_web,
  ]
}
