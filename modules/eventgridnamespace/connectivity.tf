resource "azurerm_private_endpoint" "private_endpoint_topic" {
  name                = "${azurerm_eventgrid_namespace.eventgrid_namespace.name}-topic-pe"
  location            = azurerm_eventgrid_namespace.eventgrid_namespace.location
  resource_group_name = azurerm_eventgrid_namespace.eventgrid_namespace.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_eventgrid_namespace.eventgrid_namespace.name}-topic-nic"
  private_service_connection {
    name                           = "${azurerm_eventgrid_namespace.eventgrid_namespace.name}-topic-svc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_eventgrid_namespace.eventgrid_namespace.id
    subresource_names              = ["topic"]
  }
  subnet_id = var.subnet_id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_topic == "" ? [] : [1]
    content {
      name = "${azurerm_eventgrid_namespace.eventgrid_namespace.name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_topic
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
    azurerm_private_endpoint.private_endpoint_topic
  ]
}
