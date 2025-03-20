resource "azurerm_private_endpoint" "private_endpoint_eventhub_namespace_namespace" {
  count = var.subnet_id == "" ? 0 : 1

  name                = "${azurerm_eventhub_namespace.eventhub_namespace.name}-datafactory-pe"
  location            = var.location
  resource_group_name = azurerm_eventhub_namespace.eventhub_namespace.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_eventhub_namespace.eventhub_namespace.name}-datafactory-nic"
  private_service_connection {
    name                           = "${azurerm_eventhub_namespace.eventhub_namespace.name}-datafactory-svc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_eventhub_namespace.eventhub_namespace.id
    subresource_names              = ["namespace"]
  }
  subnet_id = var.subnet_id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_servicebus == "" ? [] : [1]
    content {
      name = "${azurerm_eventhub_namespace.eventhub_namespace.name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_servicebus
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
    azurerm_private_endpoint.private_endpoint_eventhub_namespace_namespace,
  ]
}
