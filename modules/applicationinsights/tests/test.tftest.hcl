run "create_applicationinsights" {
  command = apply

  variables {
    location            = "northeurope"
    resource_group_name = "tfmdltst-dev-rg"
    tags = {
      test = "applicationinsights"
    }
    application_insights_name                       = "mytftst-001"
    application_insights_application_type           = "web"
    application_insights_log_analytics_workspace_id = ""
    diagnostics_configurations                      = []
  }

  assert {
    condition     = azurerm_application_insights.application_insights.resource_group_name == "tfmdltst-dev-rg"
    error_message = "Failed to deploy."
  }
}
