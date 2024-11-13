resource "azurerm_private_endpoint" "private_endpoint_databricks_workspace_databricks_ui_api" {
  name                = "${azurerm_databricks_workspace.databricks_workspace.name}-uiapi-pe"
  location            = var.location
  resource_group_name = azurerm_databricks_workspace.databricks_workspace.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_databricks_workspace.databricks_workspace.name}-uiapi-nic"
  private_service_connection {
    name                           = "${azurerm_databricks_workspace.databricks_workspace.name}-uiapi-svc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_databricks_workspace.databricks_workspace.id
    subresource_names              = ["databricks_ui_api"]
  }
  subnet_id = var.subnet_id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_databricks == "" ? [] : [1]
    content {
      name = "${azurerm_databricks_workspace.databricks_workspace.name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_databricks
      ]
    }
  }

  lifecycle {
    ignore_changes = [
      private_dns_zone_group
    ]
  }
  # depends_on = [
  #   time_sleep.sleep_workspace
  # ]
}

resource "azurerm_private_endpoint" "private_endpoint_databricks_workspace_browser_authentication" {
  count = var.databricks_workspace_browser_authentication_private_endpoint_enabled ? 1 : 0

  name                = "${azurerm_databricks_workspace.databricks_workspace.name}-auth-pe"
  location            = var.location
  resource_group_name = azurerm_databricks_workspace.databricks_workspace.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_databricks_workspace.databricks_workspace.name}-auth-nic"
  private_service_connection {
    name                           = "${azurerm_databricks_workspace.databricks_workspace.name}-auth-svc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_databricks_workspace.databricks_workspace.id
    subresource_names              = ["browser_authentication"]
  }
  subnet_id = var.subnet_id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_databricks == "" ? [] : [1]
    content {
      name = "${azurerm_databricks_workspace.databricks_workspace.name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_databricks
      ]
    }
  }

  lifecycle {
    ignore_changes = [
      private_dns_zone_group
    ]
  }

  depends_on = [
    azurerm_private_endpoint.private_endpoint_databricks_workspace_databricks_ui_api,
  ]
}

resource "time_sleep" "sleep_connectivity" {
  create_duration = "${var.connectivity_delay_in_seconds}s"

  depends_on = [
    azurerm_private_endpoint.private_endpoint_databricks_workspace_browser_authentication,
    azurerm_private_endpoint.private_endpoint_databricks_workspace_databricks_ui_api,
  ]
}
