resource "azurerm_service_plan" "service_plan" {
  name                = var.service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  maximum_elastic_worker_count = var.service_plan_maximum_elastic_worker_count
  os_type                  = var.service_plan_os_type
  per_site_scaling_enabled = var.service_plan_per_site_scaling_enabled
  sku_name                 = var.service_plan_sku_name
  worker_count             = var.service_plan_worker_count
  zone_balancing_enabled   = var.service_plan_zone_balancing_enabled
}
