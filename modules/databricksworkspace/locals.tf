locals {
  private_dns_zones_map = {
    databricks_ui_api      = var.private_dns_zone_id_databricks
    browser_authentication = var.private_dns_zone_id_databricks
  }
}
