resource "azurerm_private_endpoint" "private_endpoint_purview_account_platform" {
  name                = "${azapi_resource.purview_account.name}-platform-pe"
  location            = var.location_private_endpoint != null ? var.location_private_endpoint : var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azapi_resource.purview_account.name}-platform-nic"
  private_service_connection {
    name                           = "${azapi_resource.purview_account.name}-platform-svc"
    is_manual_connection           = false
    private_connection_resource_id = azapi_resource.purview_account.id
    subresource_names              = ["platform"]
  }
  subnet_id = var.subnet_id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_purview_platform == "" ? [] : [1]
    content {
      name = "${azapi_resource.purview_account.name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_purview_platform
      ]
    }
  }

  lifecycle {
    ignore_changes = [
      private_dns_zone_group
    ]
  }
}

resource "azurerm_private_endpoint" "private_endpoint_purview_account_ingestion_storage_blob" {
  name                = "${azapi_resource.purview_account.name}-ing-blob-pe"
  location            = var.location_private_endpoint != null ? var.location_private_endpoint : var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azapi_resource.purview_account.name}-ing-blob-nic"
  private_service_connection {
    name                           = "${azapi_resource.purview_account.name}-ing-blob-svc"
    is_manual_connection           = false
    private_connection_resource_id = azapi_resource.purview_account.output.properties.ingestionStorage.id
    subresource_names              = ["blob"]
  }
  subnet_id = var.subnet_id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_blob == "" ? [] : [1]
    content {
      name = "${azapi_resource.purview_account.name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_blob
      ]
    }
  }

  lifecycle {
    ignore_changes = [
      private_dns_zone_group
    ]
  }
}

resource "azurerm_private_endpoint" "private_endpoint_purview_account_ingestion_storage_queue" {
  name                = "${azapi_resource.purview_account.name}-ing-queue-pe"
  location            = var.location_private_endpoint != null ? var.location_private_endpoint : var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azapi_resource.purview_account.name}-ing-queue-nic"
  private_service_connection {
    name                           = "${azapi_resource.purview_account.name}-ing-queue-svc"
    is_manual_connection           = false
    private_connection_resource_id = azapi_resource.purview_account.output.properties.ingestionStorage.id
    subresource_names              = ["queue"]
  }
  subnet_id = var.subnet_id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_queue == "" ? [] : [1]
    content {
      name = "${azapi_resource.purview_account.name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_queue
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
    azurerm_private_endpoint.private_endpoint_purview_account_platform,
    azurerm_private_endpoint.private_endpoint_purview_account_ingestion_storage_blob,
    azurerm_private_endpoint.private_endpoint_purview_account_ingestion_storage_queue,
  ]
}
