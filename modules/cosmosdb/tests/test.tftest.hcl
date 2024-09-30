run "create_cosmosdb_account" {
  command = apply

  variables {
    location            = "northeurope"
    resource_group_name = "tfmodule-test-rg"
    tags = {
      test = "cosmosdb_account"
    }
    cosmosdb_account_name                               = "tftstr001"
    cosmosdb_account_access_key_metadata_writes_enabled = false
    cosmosdb_account_analytical_storage_enabled         = false
    cosmosdb_account_automatic_failover_enabled         = false
    cosmosdb_account_backup = {
      type                = "Continuous"
      tier                = "Continuous7Days"
      storage_redundancy  = null
      retention_in_hours  = null
      interval_in_minutes = null
    }
    cosmosdb_account_capabilities = [
      "DisableRateLimitingResponses"
    ]
    cosmosdb_account_capacity_total_throughput_limit = -1
    cosmosdb_account_consistency_policy = {
      consistency_level       = "Strong"
      max_interval_in_seconds = null
      max_staleness_prefix    = null
    }
    cosmosdb_account_cors_rules            = {}
    cosmosdb_account_default_identity_type = null
    cosmosdb_account_geo_location = [
      {
        location          = "northeurope"
        failover_priority = 0
        zone_redundant    = false
      }
    ]
    cosmosdb_account_kind                          = "GlobalDocumentDB"
    cosmosdb_account_mongo_server_version          = null
    cosmosdb_account_local_authentication_disabled = true
    cosmosdb_account_partition_merge_enabled       = false
    diagnostics_configurations                     = []
    subnet_id                                      = "/subscriptions/1fdab118-1638-419a-8b12-06c9543714a0/resourceGroups/ptt-dev-networking-rg/providers/Microsoft.Network/virtualNetworks/spoke-ptt-dev-vnet001/subnets/TerraformTestSubnet"
    connectivity_delay_in_seconds                  = 0
    private_endpoint_subresource_names             = ["Sql"]
    private_dns_zone_id_cosmos_sql                 = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.documents.azure.com"
    private_dns_zone_id_cosmos_mongodb             = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.mongo.cosmos.azure.com"
    private_dns_zone_id_cosmos_cassandra           = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.cassandra.cosmos.azure.com"
    private_dns_zone_id_cosmos_gremlin             = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.gremlin.cosmos.azure.com"
    private_dns_zone_id_cosmos_table               = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.table.cosmos.azure.com"
    private_dns_zone_id_cosmos_analytical          = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.analytics.cosmos.azure.com"
    private_dns_zone_id_cosmos_coordinator         = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.postgres.cosmos.azure.com"
    customer_managed_key                           = null
  }

  assert {
    condition     = azurerm_cosmosdb_account.cosmosdb_account.resource_group_name == "tfmodule-test-rg"
    error_message = "Failed to deploy."
  }
}
