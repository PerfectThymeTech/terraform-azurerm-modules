resource "azurerm_private_endpoint" "private_endpoint_ai_services" {
  name                = "${azapi_resource.ai_services.name}-account-pe"
  location            = var.location_private_endpoint != null ? var.location_private_endpoint : var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azapi_resource.ai_services.name}-account-nic"
  private_service_connection {
    name                           = "${azapi_resource.ai_services.name}-account-svc"
    is_manual_connection           = false
    private_connection_resource_id = azapi_resource.ai_services.id
    subresource_names              = ["account"]
  }
  subnet_id = var.subnet_id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_ai_services != "" && var.private_dns_zone_id_cognitive_account != "" && var.private_dns_zone_id_open_ai != "" ? [1] : [0]
    content {
      name = "${azapi_resource.ai_services.name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_ai_services,
        var.private_dns_zone_id_cognitive_account,
        var.private_dns_zone_id_open_ai,
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
    # azurerm_private_endpoint.private_endpoint_ai_services
  ]
}
