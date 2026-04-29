run "create_ai_search" {
  command = apply

  variables {
    location            = "northeurope"
    resource_group_name = "tfmodule-test-rg"
    tags = {
      test = "aisearch"
    }
    search_service_name                         = "tftstr-001"
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
        target_resource_id = "/subscriptions/1fdab118-1638-419a-8b12-06c9543714a0/resourcegroups/tfmodule-test-rg/providers/Microsoft.Storage/storageAccounts/mytfteststg"
        approve            = true
      }
    }
    diagnostics_configurations         = []
    subnet_id                          = "/subscriptions/1fdab118-1638-419a-8b12-06c9543714a0/resourceGroups/ptt-dev-networking-rg/providers/Microsoft.Network/virtualNetworks/spoke-ptt-dev-vnet001/subnets/TerraformTestSubnet"
    connectivity_delay_in_seconds      = 0
    private_dns_zone_id_search_service = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.search.windows.net"
    customer_managed_key               = null
  }

  assert {
    condition     = azurerm_search_service.search_service.resource_group_name == "tfmodule-test-rg"
    error_message = "Failed to deploy."
  }
}
