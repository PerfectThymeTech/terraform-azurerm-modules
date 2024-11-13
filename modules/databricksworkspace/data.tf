data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_databricks_workspace" {
  resource_id = azurerm_databricks_workspace.databricks_workspace.id
}
