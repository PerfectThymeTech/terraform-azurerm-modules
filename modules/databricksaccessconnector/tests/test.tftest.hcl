run "create_databricks_access_connector" {
  command = apply

  variables {
    location            = "northeurope"
    resource_group_name = "tfmodule-test-rg"
    tags = {
      test = "databricks_access_connector"
    }
    databricks_access_connector_name = "tftstdbac001"
    diagnostics_configurations       = []
  }

  assert {
    condition     = azurerm_databricks_access_connector.databricks_access_connector.resource_group_name == "tfmodule-test-rg"
    error_message = "Failed to deploy."
  }
}
