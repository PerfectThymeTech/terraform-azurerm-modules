module "application_insights" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/applicationinsights?ref=main"
  providers = {
    azurerm = azurerm
  }

  location                                        = var.location
  resource_group_name                             = var.resource_group_name
  tags                                            = var.tags
  application_insights_name                       = "${local.prefix}-ai001"
  application_insights_application_type           = "web"
  application_insights_log_analytics_workspace_id = var.log_analytics_workspace_id
  diagnostics_configurations                      = []
}

module "container_registry" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/containerregistry?ref=main"
  providers = {
    azurerm = azurerm
    time    = time
  }

  location                                     = var.location
  resource_group_name                          = var.resource_group_name
  tags                                         = var.tags
  container_registry_name                      = replace("${local.prefix}-acr001", "-", "")
  container_registry_admin_enabled             = false
  container_registry_anonymous_pull_enabled    = false
  container_registry_data_endpoint_enabled     = false
  container_registry_export_policy_enabled     = false
  container_registry_quarantine_policy_enabled = false
  container_registry_retention_policy_in_days  = 7
  container_registry_trust_policy_enabled      = false
  container_registry_zone_redundancy_enabled   = false
  diagnostics_configurations                   = []
  subnet_id                                    = var.subnet_id
  connectivity_delay_in_seconds                = var.connectivity_delay_in_seconds
  private_dns_zone_id_container_registry       = var.private_dns_zone_id_container_registry
  customer_managed_key                         = null
}

module "key_vault" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/keyvault?ref=main"
  providers = {
    azurerm = azurerm
    time    = time
  }

  location                             = var.location
  resource_group_name                  = var.resource_group_name
  tags                                 = var.tags
  key_vault_name                       = "${local.prefix}-kv011"
  key_vault_sku_name                   = "standard"
  key_vault_soft_delete_retention_days = 7
  diagnostics_configurations           = []
  subnet_id                            = var.subnet_id
  connectivity_delay_in_seconds        = var.connectivity_delay_in_seconds
  private_dns_zone_id_vault            = var.private_dns_zone_id_vault
}

module "storage_account" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/storage?ref=main"
  providers = {
    azurerm = azurerm
    time    = time
  }

  location                                        = var.location
  resource_group_name                             = var.resource_group_name
  tags                                            = var.tags
  storage_account_name                            = replace("${local.prefix}-stg001", "-", "")
  storage_access_tier                             = "Hot"
  storage_account_type                            = "StorageV2"
  storage_account_tier                            = "Standard"
  storage_account_replication_type                = "LRS"
  storage_blob_change_feed_enabled                = false
  storage_blob_container_delete_retention_in_days = 7
  storage_blob_delete_retention_in_days           = 7
  storage_blob_cors_rules = {
    azureml = {
      allowed_headers    = ["*"]
      allowed_methods    = ["DELETE", "GET", "HEAD", "POST", "OPTIONS", "PUT", "PATCH"]
      allowed_origins    = ["https://mlworkspace.azure.ai", "https://ml.azure.com", "https://*.ml.azure.com", "https://ai.azure.com", "https://*.ai.azure.com"]
      exposed_headers    = ["*"]
      max_age_in_seconds = 1800
    }
  }
  storage_blob_last_access_time_enabled = false
  storage_is_hns_enabled                = false
  storage_network_bypass                = ["AzureServices"]
  storage_network_private_link_access   = []
  storage_public_network_access_enabled = false
  storage_nfsv3_enabled                 = false
  storage_sftp_enabled                  = false
  storage_shared_access_key_enabled     = true
  storage_container_names               = []
  storage_static_website                = []
  diagnostics_configurations            = []
  subnet_id                             = var.subnet_id
  connectivity_delay_in_seconds         = var.connectivity_delay_in_seconds
  private_endpoint_subresource_names    = ["blob", "file", "queue", "table"]
  private_dns_zone_id_blob              = var.private_dns_zone_id_blob
  private_dns_zone_id_file              = var.private_dns_zone_id_file
  private_dns_zone_id_table             = var.private_dns_zone_id_table
  private_dns_zone_id_queue             = var.private_dns_zone_id_queue
}
