resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                 = each.key
  virtual_network_name = local.virtual_network.name
  resource_group_name  = local.virtual_network.resource_group_name

  address_prefixes = [
    each.value.address_prefix
  ]
  delegation {
    name = "DatabricksDelegation"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
    }
  }
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = true
  service_endpoint_policy_ids                   = []
  service_endpoints                             = []
}

resource "azurerm_subnet_network_security_group_association" "subnets_network_security_group_association" {
  for_each = var.subnets

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = var.nsg_id
}

resource "azurerm_subnet_route_table_association" "subnets_route_table_association" {
  for_each = var.subnets

  subnet_id      = azurerm_subnet.subnets[each.key].id
  route_table_id = var.route_table_id
}

module "databricks_access_connector" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/databricksaccessconnector?ref=main"
  providers = {
    azurerm = azurerm
  }

  location                         = var.location
  resource_group_name              = var.resource_group_name
  tags                             = var.tags
  databricks_access_connector_name = "${local.prefix}-dbac001"
}
