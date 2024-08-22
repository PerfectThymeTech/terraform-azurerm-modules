resource "azurerm_service_plan" "service_plan" {
  name                = var.service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  maximum_elastic_worker_count = var.service_plan_maximum_elastic_worker_count
  os_type                  = var.service_plan_os_type
  per_site_scaling_enabled = false
  sku_name                 = "P1mv3"
  worker_count             = 1     # Update to '3' for production
  zone_balancing_enabled   = false # Update to 'true' for production
}
