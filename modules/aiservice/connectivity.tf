resource "azurerm_private_endpoint" "private_endpoint_cognitive_account" {
  name                = "${azurerm_cognitive_account.cognitive_account.name}-account-pe"
  location            = var.location_private_endpoint != null ? var.location_private_endpoint : var.location
  resource_group_name = azurerm_cognitive_account.cognitive_account.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_cognitive_account.cognitive_account.name}-account-nic"
  private_service_connection {
    name                           = "${azurerm_cognitive_account.cognitive_account.name}-account-svc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_cognitive_account.cognitive_account.id
    subresource_names              = ["account"]
  }
  subnet_id = var.subnet_id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_cognitive_account == "" ? [] : [1]
    content {
      name = "${azurerm_cognitive_account.cognitive_account.name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_cognitive_account
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
    azurerm_private_endpoint.private_endpoint_cognitive_account
  ]
}
