resource "azurerm_private_endpoint" "private_endpoint_postgresql_flexible_server" {
  name                = "${azurerm_postgresql_flexible_server.postgresql_flexible_server.name}-pe"
  location            = var.location
  resource_group_name = azurerm_postgresql_flexible_server.postgresql_flexible_server.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_postgresql_flexible_server.postgresql_flexible_server.name}-nic"
  private_service_connection {
    name                           = "${azurerm_postgresql_flexible_server.postgresql_flexible_server.name}-svc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_postgresql_flexible_server.postgresql_flexible_server.id
    subresource_names              = ["postgresqlServer"]
  }
  subnet_id = var.subnet_id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_postrgesql == "" ? [] : [1]
    content {
      name = "${azurerm_postgresql_flexible_server.postgresql_flexible_server.name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_postrgesql
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
    azurerm_private_endpoint.private_endpoint_postgresql_flexible_server
  ]
}
