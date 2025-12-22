run "create_applicationinsights" {
  command = apply

  variables {
    location            = "northeurope"
    resource_group_name = "tfmodule-test-rg"
    tags = {
      test = "applicationinsights"
    }
    application_insights_name                          = "tftstr-001"
    application_insights_application_type              = "web"
    application_insights_internet_ingestion_enabled    = true
    application_insights_internet_query_enabled        = true
    application_insights_local_authentication_disabled = false
    application_insights_retention_in_days             = 90
    application_insights_sampling_percentage           = 100
    application_insights_log_analytics_workspace_id    = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-logging-rg/providers/Microsoft.OperationalInsights/workspaces/ptt-dev-log001"
    diagnostics_configurations                         = []
  }

  assert {
    condition     = azurerm_application_insights.application_insights.resource_group_name == "tfmodule-test-rg"
    error_message = "Failed to deploy."
  }
}
