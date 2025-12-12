resource "azurerm_communication_service" "communication_service" {
  name                = var.communication_service_name
  resource_group_name = var.resource_group_name
  tags                = var.tags

  data_location = var.communication_service_data_location
}
