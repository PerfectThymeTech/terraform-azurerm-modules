resource "azurerm_private_endpoint" "bot_service_azure_bot_private_endpoint_bot" {
  name                = "${azurerm_bot_service_azure_bot.bot_service_azure_bot.name}-bot-pe"
  location            = var.location
  resource_group_name = azurerm_bot_service_azure_bot.bot_service_azure_bot.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_bot_service_azure_bot.bot_service_azure_bot.name}-nic"
  private_service_connection {
    name                           = "${azurerm_bot_service_azure_bot.bot_service_azure_bot.name}-svc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_bot_service_azure_bot.bot_service_azure_bot.id
    subresource_names              = ["Bot"]
  }
  subnet_id = var.subnet_id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_bot_framework_directline == "" ? [] : [1]
    content {
      name = "${azurerm_bot_service_azure_bot.bot_service_azure_bot.name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_bot_framework_directline
      ]
    }
  }

  lifecycle {
    ignore_changes = [
      private_dns_zone_group
    ]
  }
}

resource "azurerm_private_endpoint" "bot_service_azure_bot_private_endpoint_token" {
  name                = "${azurerm_bot_service_azure_bot.bot_service_azure_bot.name}-token-pe"
  location            = var.location
  resource_group_name = azurerm_bot_service_azure_bot.bot_service_azure_bot.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_bot_service_azure_bot.bot_service_azure_bot.name}-nic"
  private_service_connection {
    name                           = "${azurerm_bot_service_azure_bot.bot_service_azure_bot.name}-svc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_bot_service_azure_bot.bot_service_azure_bot.id
    subresource_names              = ["Token"]
  }
  subnet_id = var.subnet_id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_bot_framework_token == "" ? [] : [1]
    content {
      name = "${azurerm_bot_service_azure_bot.bot_service_azure_bot.name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_bot_framework_token
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
    azurerm_private_endpoint.bot_service_azure_bot_private_endpoint_bot,
    azurerm_private_endpoint.bot_service_azure_bot_private_endpoint_token,
  ]
}
