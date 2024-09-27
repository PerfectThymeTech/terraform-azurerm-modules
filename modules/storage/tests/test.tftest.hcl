run "create_storage" {
  command = apply

  variables {
    location            = "northeurope"
    resource_group_name = "tfmodule-test-rg"
    tags = {
      test = "storage"
    }
    storage_account_name                            = "tftstr001"
    storage_access_tier                             = "Hot"
    storage_account_type                            = "StorageV2"
    storage_account_tier                            = "Standard"
    storage_account_replication_type                = "ZRS"
    storage_blob_change_feed_enabled                = false
    storage_blob_container_delete_retention_in_days = 7
    storage_blob_delete_retention_in_days           = 7
    storage_blob_cors_rules                         = {}
    storage_blob_last_access_time_enabled           = false
    storage_blob_versioning_enabled                 = false
    storage_is_hns_enabled                          = false
    storage_network_bypass                          = ["None"]
    storage_network_private_link_access             = []
    storage_public_network_access_enabled           = false
    storage_nfsv3_enabled                           = false
    storage_sftp_enabled                            = false
    storage_shared_access_key_enabled               = false
    storage_container_names                         = []
    storage_static_website                          = []
    diagnostics_configurations                      = []
    subnet_id                                       = "/subscriptions/1fdab118-1638-419a-8b12-06c9543714a0/resourceGroups/ptt-dev-networking-rg/providers/Microsoft.Network/virtualNetworks/spoke-ptt-dev-vnet001/subnets/TerraformTestSubnet"
    connectivity_delay_in_seconds                   = 0
    private_endpoint_subresource_names              = ["blob"]
    private_dns_zone_id_blob                        = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
    private_dns_zone_id_file                        = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net"
    private_dns_zone_id_table                       = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.table.core.windows.net"
    private_dns_zone_id_queue                       = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.queue.core.windows.net"
    private_dns_zone_id_web                         = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.web.core.windows.net"
    private_dns_zone_id_dfs                         = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.dfs.core.windows.net"
    customer_managed_key                            = null
  }

  assert {
    condition     = azurerm_storage_account.storage_account.resource_group_name == "tfmodule-test-rg"
    error_message = "Failed to deploy."
  }
}
