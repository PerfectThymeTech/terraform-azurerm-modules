resource "azurerm_subnet" "subnet" {
  for_each = var.subnets

  name                 = each.key
  virtual_network_name = ""
  resource_group_name  = ""

  address_prefixes = [
    each.value.address_prefix
  ]
  delegation {
    name = "DatabricksDelegation"
    service_delegation {
      name = ""
    }
  }
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = true
  service_endpoint_policy_ids                   = []
  service_endpoints                             = []
}
