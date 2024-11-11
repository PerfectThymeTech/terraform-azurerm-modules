resource "azurerm_databricks_workspace" "databricks_workspace" {
  name                = var.databricks_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  access_connector_id = var.databricks_workspace_access_connector_id
  custom_parameters {
    machine_learning_workspace_id                        = var.databricks_workspace_machine_learning_workspace_id
    nat_gateway_name                                     = null
    no_public_ip                                         = true
    private_subnet_name                                  = var.databricks_workspace_private_subnet_name
    private_subnet_network_security_group_association_id = var.databricks_workspace_private_subnet_network_security_group_association_id
    public_ip_name                                       = null
    public_subnet_name                                   = var.databricks_workspace_public_subnet_name
    public_subnet_network_security_group_association_id  = var.databricks_workspace_public_subnet_network_security_group_association_id
    storage_account_sku_name                             = var.databricks_workspace_storage_account_sku_name
    virtual_network_id                                   = var.databricks_workspace_virtual_network_id
    vnet_address_prefix                                  = null
  }
  customer_managed_key_enabled                        = var.customer_managed_key == null ? false : true
  default_storage_firewall_enabled                    = true
  infrastructure_encryption_enabled                   = true
  load_balancer_backend_address_pool_id               = null
  managed_disk_cmk_key_vault_id                       = var.customer_managed_key == null ? null : var.customer_managed_key.key_vault_id
  managed_disk_cmk_key_vault_key_id                   = var.customer_managed_key == null ? null : var.customer_managed_key.key_vault_key_versionless_id
  managed_disk_cmk_rotation_to_latest_version_enabled = var.customer_managed_key == null ? null : true
  managed_resource_group_name                         = "${var.databricks_workspace_name}-rg"
  managed_services_cmk_key_vault_id                   = var.customer_managed_key == null ? null : var.customer_managed_key.key_vault_id
  managed_services_cmk_key_vault_key_id               = var.customer_managed_key == null ? null : var.customer_managed_key.key_vault_key_versionless_id
  network_security_group_rules_required               = "NoAzureDatabricksRules"
  public_network_access_enabled                       = false
  sku                                                 = "premium"
}

resource "azurerm_databricks_workspace_root_dbfs_customer_managed_key" "databricks_workspace_root_dbfs_customer_managed_key" {
  count = var.customer_managed_key == null ? 0 : 1

  workspace_id = azurerm_databricks_workspace.databricks_workspace.id

  key_vault_id     = var.customer_managed_key.key_vault_id
  key_vault_key_id = var.customer_managed_key.key_vault_key_versionless_id
}
