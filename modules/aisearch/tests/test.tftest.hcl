run "create_ai_service" {
  command = apply

  variables {
    location            = "northeurope"
    resource_group_name = "tfmdltst-dev-rg"
    tags = {
      test = "aisearch"
    }
    search_service_name                        = "mytftst-001"
    search_service_sku                         = "basic"
    search_service_semantic_search_sku         = "basic"
    search_service_authentication_failure_mode = "http401WithBearerChallenge"
    search_service_hosting_mode                = "default"
    search_service_partition_count             = 1
    search_service_replica_count               = 1
    diagnostics_configurations                 = []
    subnet_id                                  = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/tfmdltst-dev-rg/providers/Microsoft.Network/virtualNetworks/tfmdltst-dev-vnet/subnets/PrivateEndpoints"
    connectivity_delay_in_seconds              = 0
    private_dns_zone_id_cognitive_account      = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.search.windows.net"
    customer_managed_key                       = null
  }

  assert {
    condition     = azurerm_search_service.search_service.resource_group_name == "tfmdltst-dev-rg"
    error_message = "Failed to deploy."
  }
}
