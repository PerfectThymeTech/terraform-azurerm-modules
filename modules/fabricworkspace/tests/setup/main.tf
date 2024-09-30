module "fabric_capacity" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/fabriccapacity?ref=main"
  providers = {
    azapi = azapi
  }

  location                     = var.location
  resource_group_name          = var.resource_group_name
  tags                         = var.tags
  fabric_capacity_name         = replace("${local.prefix}-cpcty001", "-", "")
  fabric_capacity_admin_emails = []
  fabric_capacity_sku          = "F2"
}
