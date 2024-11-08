run "create_appserviceplan" {
  command = apply

  variables {
    location            = "northeurope"
    resource_group_name = "tfmodule-test-rg"
    tags = {
      test = "appserviceplan"
    }
    service_plan_name                         = "tftstr-asp001"
    service_plan_maximum_elastic_worker_count = null
    service_plan_os_type                      = "Linux"
    service_plan_per_site_scaling_enabled     = false
    service_plan_sku_name                     = "FC1"
    service_plan_worker_count                 = 0
    service_plan_zone_balancing_enabled       = false
    diagnostics_configurations                = []
  }

  assert {
    condition     = azurerm_service_plan.service_plan.resource_group_name == "tfmodule-test-rg"
    error_message = "Failed to deploy."
  }
}
