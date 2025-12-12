run "create_communication_service" {
  command = apply

  variables {
    location            = "northeurope"
    resource_group_name = "tfmodule-test-rg"
    tags = {
      test = "communication_service"
    }
    communication_service_name          = "tftstr-001"
    communication_service_data_location = "Europe"
    diagnostics_configurations          = []
  }

  assert {
    condition     = azurerm_communication_service.communication_service.resource_group_name == "tfmodule-test-rg"
    error_message = "Failed to deploy."
  }
}
