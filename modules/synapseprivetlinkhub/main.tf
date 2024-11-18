resource "azurerm_synapse_private_link_hub" "synapse_private_link_hub" {
  name                = var.synapse_private_link_hub_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}
