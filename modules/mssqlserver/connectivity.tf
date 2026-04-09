resource "azurerm_private_endpoint" "private_endpoint_mssql_server" {
  name                = "${azurerm_mssql_server.mssql_server.name}-sqlserver-pe"
  location            = azurerm_mssql_server.mssql_server.location
  resource_group_name = azurerm_mssql_server.mssql_server.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_mssql_server.mssql_server.name}-sqlserver-nic"
  private_service_connection {
    name                           = "${azurerm_mssql_server.mssql_server.name}-sqlserver-svc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mssql_server.mssql_server.id
    subresource_names              = ["sqlServer"]
  }
  subnet_id = var.subnet_id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_sqlserver == "" ? [] : [1]
    content {
      name = "${azurerm_mssql_server.mssql_server.name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_sqlserver
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
    azurerm_private_endpoint.private_endpoint_mssql_server
  ]
}
