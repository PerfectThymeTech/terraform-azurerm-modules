resource "azurerm_databricks_access_connector" "databricks_access_connector" {
  name = var.databricks_access_connector_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }
}
