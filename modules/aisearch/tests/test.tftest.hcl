run "create_ai_search" {
  command = apply

  variables {
    location            = "northeurope"
    resource_group_name = "tfmdltst-dev-rg"
    tags = {
      test = "aisearch"
    }
    search_service_name                         = "mytftst-001"
    search_service_sku                          = "basic"
    search_service_semantic_search_sku          = "standard"
    search_service_local_authentication_enabled = false
    search_service_authentication_failure_mode  = null
    search_service_hosting_mode                 = "default"
    search_service_partition_count              = 1
    search_service_replica_count                = 1
    search_service_shared_private_links = {
      stg = {
        subresource_name   = "blob"
        target_resource_id = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourcegroups/tfmdltst-dev-rg/providers/Microsoft.Storage/storageAccounts/tftststrg"
        approve            = true
      }
    }
    diagnostics_configurations         = []
    subnet_id                          = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/tfmdltst-dev-rg/providers/Microsoft.Network/virtualNetworks/tfmdltst-dev-vnet/subnets/PrivateEndpoints"
    connectivity_delay_in_seconds      = 0
    private_dns_zone_id_search_service = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.search.windows.net"
    customer_managed_key               = null
  }

  assert {
    condition     = azurerm_search_service.search_service.resource_group_name == "tfmdltst-dev-rg"
    error_message = "Failed to deploy."
  }
}
