resource "azurerm_cosmosdb_account" "cosmosdb_account" {
  name                = var.cosmosdb_account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  dynamic "identity" {
    for_each = var.customer_managed_key != null ? [{
      type = "SystemAssigned, UserAssigned"
      identity_ids = [
        var.customer_managed_key.user_assigned_identity_id
      ]
      }] : [{
      type         = "SystemAssigned"
      identity_ids = null
    }]
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  access_key_metadata_writes_enabled = false
  analytical_storage_enabled         = var.cosmosdb_account_analytical_storage_enabled
  dynamic "analytical_storage" {
    for_each = var.cosmosdb_account_analytical_storage_enabled ? [1] : [0]
    content {
      schema_type = "FullFidelity"
    }
  }
  automatic_failover_enabled = var.cosmosdb_account_automatic_failover_enabled
  backup {
    type                = var.cosmosdb_account_backup.type
    tier                = var.cosmosdb_account_backup.tier
    interval_in_minutes = var.cosmosdb_account_backup.interval_in_minutes
    retention_in_hours  = var.cosmosdb_account_backup.retention_in_hours
    storage_redundancy  = var.cosmosdb_account_backup.storage_redundancy
  }
  dynamic "capabilities" {
    for_each = var.cosmosdb_account_capabilities
    content {
      name = capabilities.value
    }
  }
  capacity {
    total_throughput_limit = var.cosmosdb_account_capacity_total_throughput_limit
  }
  consistency_policy {
    consistency_level       = var.cosmosdb_account_consistency_policy.consistency_level
    max_interval_in_seconds = var.cosmosdb_account_consistency_policy.max_interval_in_seconds
    max_staleness_prefix    = var.cosmosdb_account_consistency_policy.max_staleness_prefix
  }
  dynamic "cors_rule" {
    for_each = var.cosmosdb_account_cors_rules
    content {
      allowed_headers    = cors_rule.value.allowed_headers
      allowed_methods    = cors_rule.value.allowed_methods
      allowed_origins    = cors_rule.value.allowed_origins
      exposed_headers    = cors_rule.value.exposed_headers
      max_age_in_seconds = cors_rule.value.max_age_in_seconds
    }
  }
  create_mode           = "Default"
  default_identity_type = var.cosmosdb_account_default_identity_type == "" ? null : var.cosmosdb_account_default_identity_type
  free_tier_enabled     = false
  dynamic "geo_location" {
    for_each = var.cosmosdb_account_geo_location
    content {
      location          = geo_location.value.location
      failover_priority = geo_location.value.failover_priority
      zone_redundant    = geo_location.value.zone_redundant
    }
  }
  ip_range_filter                       = []
  is_virtual_network_filter_enabled     = true
  key_vault_key_id                      = var.customer_managed_key != null ? var.customer_managed_key.key_vault_key_versionless_id : null
  kind                                  = var.cosmosdb_account_kind
  local_authentication_disabled         = true
  minimal_tls_version                   = "Tls12"
  mongo_server_version                  = null
  multiple_write_locations_enabled      = var.cosmosdb_account_mongo_server_version
  network_acl_bypass_for_azure_services = false
  network_acl_bypass_ids                = []
  offer_type                            = "Standard"
  partition_merge_enabled               = var.cosmosdb_account_partition_merge_enabled
  public_network_access_enabled         = false
}
