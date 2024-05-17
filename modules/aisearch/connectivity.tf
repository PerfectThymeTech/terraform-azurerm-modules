resource "azurerm_private_endpoint" "private_endpoint_search_service" {
  name                = "${azurerm_search_service.search_service.name}-search-pe"
  location            = azurerm_search_service.search_service.location
  resource_group_name = azurerm_search_service.search_service.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_search_service.search_service.name}-search-nic"
  private_service_connection {
    name                           = "${azurerm_search_service.search_service.name}-search-svc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_search_service.search_service.id
    subresource_names              = ["searchService"]
  }
  subnet_id = var.subnet_id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_search_service == "" ? [] : [1]
    content {
      name = "${azurerm_search_service.search_service.name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_search_service
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
    azurerm_private_endpoint.private_endpoint_search_service
  ]
}
