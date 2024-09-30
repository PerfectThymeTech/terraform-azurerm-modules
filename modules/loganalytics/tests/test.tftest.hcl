run "create_loganalytics" {
  command = apply

  variables {
    location            = "northeurope"
    resource_group_name = "tfmodule-test-rg"
    tags = {
      test = "loganalytics"
    }
    log_analytics_workspace_name              = "tftstr-001"
    log_analytics_workspace_retention_in_days = 30
    diagnostics_configurations                = []
  }

  assert {
    condition     = azurerm_log_analytics_workspace.log_analytics_workspace.resource_group_name == "tfmodule-test-rg"
    error_message = "Failed to deploy."
  }
}
