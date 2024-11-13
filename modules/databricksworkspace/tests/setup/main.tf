resource "azapi_resource" "databricks_private_subnet" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2022-07-01"
  name      = "DatabricksPrivateSubnetTfTest"
  parent_id = var.virtual_network_id

  body = {
    properties = {
      addressPrefix = var.databricks_private_subnet_address_prefix
      delegations = [
        {
          name = "DatabricksSubnetDelegation"
          properties = {
            serviceName = "Microsoft.Databricks/workspaces"
          }
        }
      ]
      ipAllocations = []
      networkSecurityGroup = {
        id = var.nsg_id
      }
      privateEndpointNetworkPolicies    = "Enabled"
      privateLinkServiceNetworkPolicies = "Enabled"
      routeTable = {
        id = var.route_table_id
      }
      serviceEndpointPolicies = []
      serviceEndpoints        = []
    }
  }
}

resource "azapi_resource" "databricks_public_subnet" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2022-07-01"
  name      = "DatabricksPublicSubnetTfTest"
  parent_id = var.virtual_network_id

  body = {
    properties = {
      addressPrefix = var.databricks_public_subnet_address_prefix
      delegations = [
        {
          name = "DatabricksSubnetDelegation"
          properties = {
            serviceName = "Microsoft.Databricks/workspaces"
          }
        }
      ]
      ipAllocations = []
      networkSecurityGroup = {
        id = var.nsg_id
      }
      privateEndpointNetworkPolicies    = "Enabled"
      privateLinkServiceNetworkPolicies = "Enabled"
      routeTable = {
        id = var.route_table_id
      }
      serviceEndpointPolicies = []
      serviceEndpoints        = []
    }
  }

  depends_on = [
    azapi_resource.databricks_private_subnet
  ]
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
