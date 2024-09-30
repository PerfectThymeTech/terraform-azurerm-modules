run "create_fabric_capacity" {
  command = apply

  variables {
    location            = "germanywestcentral"
    resource_group_name = "tfmodule-test-rg"
    tags = {
      test = "fabric-capacity"
    }
    fabric_capacity_name         = "tftstr001"
    fabric_capacity_admin_emails = []
    fabric_capacity_sku          = "F2"
  }

  assert {
    condition     = azapi_resource.fabric_capacity.resource_group_name == "tfmodule-test-rg"
    error_message = "Failed to deploy."
  }
}
