resource "azurerm_private_endpoint" "data_factory_private_endpoint_data_factory" {
  name                = "${azurerm_data_factory.data_factory.name}-datafactory-pe"
  location            = var.location
  resource_group_name = azurerm_data_factory.data_factory.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_data_factory.data_factory.name}-datafactory-nic"
  private_service_connection {
    name                           = "${azurerm_data_factory.data_factory.name}-datafactory-svc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_data_factory.data_factory.id
    subresource_names              = ["dataFactory"]
  }
  subnet_id = var.subnet_id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_data_factory == "" ? [] : [1]
    content {
      name = "${azurerm_data_factory.data_factory.name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_data_factory
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
    azurerm_private_endpoint.data_factory_private_endpoint_data_factory,
  ]
}
