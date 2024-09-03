run "create_cosmosdb_account" {
  command = apply

  variables {
    location            = "northeurope"
    resource_group_name = "tfmdltst-dev-rg"
    tags = {
      test = "cosmosdb_account"
    }
    cosmosdb_account_name                       = "mytftst001"
    cosmosdb_account_analytical_storage_enabled = false
    cosmosdb_account_automatic_failover_enabled = false
    cosmosdb_account_backup = {
      type                = "Continuous"
      tier                = "Continuous7Days"
      storage_redundancy  = "Geo"
      retention_in_hours  = 8
      interval_in_minutes = 240
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
    cosmosdb_account_kind                    = "GlobalDocumentDB"
    cosmosdb_account_mongo_server_version    = null
    cosmosdb_account_partition_merge_enabled = false
    diagnostics_configurations               = []
    subnet_id                                = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/tfmdltst-dev-rg/providers/Microsoft.Network/virtualNetworks/tfmdltst-dev-vnet/subnets/PrivateEndpoints"
    connectivity_delay_in_seconds            = 0
    private_endpoint_subresource_names       = ["Sql"]
    private_dns_zone_id_cosmos_sql           = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.documents.cosmos.azure.com"
    private_dns_zone_id_cosmos_mongodb       = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.mongo.cosmos.azure.com"
    private_dns_zone_id_cosmos_cassandra     = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.cassandra.cosmos.azure.com"
    private_dns_zone_id_cosmos_gremlin       = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.gremlin.cosmos.azure.com"
    private_dns_zone_id_cosmos_table         = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.table.cosmos.azure.com"
    private_dns_zone_id_cosmos_analytical    = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.analytics.cosmos.azure.com"
    private_dns_zone_id_cosmos_coordinator   = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.postgres.cosmos.azure.com"
    customer_managed_key                     = null
  }

  assert {
    condition     = azurerm_cosmosdb_account.cosmosdb_account.resource_group_name == "tfmdltst-dev-rg"
    error_message = "Failed to deploy."
  }
}
