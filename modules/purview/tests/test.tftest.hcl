run "create_purview_account" {
  command = apply

  variables {
    location                  = "westus"
    location_private_endpoint = "northeurope"
    resource_group_name       = "tfmodule-test-rg"
    tags = {
      test = "purview-account"
    }
    purview_account_name                   = "tftstr-001"
    purview_account_root_collection_admins = {}
    diagnostics_configurations             = []
    subnet_id                              = "/subscriptions/1fdab118-1638-419a-8b12-06c9543714a0/resourceGroups/ptt-dev-networking-rg/providers/Microsoft.Network/virtualNetworks/spoke-ptt-dev-vnet001/subnets/TerraformTestSubnet"
    connectivity_delay_in_seconds          = 0
    private_dns_zone_id_purview_platform   = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.purview-service.microsoft.com"
    private_dns_zone_id_blob               = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
    private_dns_zone_id_queue              = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.queue.core.windows.net"
  }

  assert {
    condition     = azapi_resource.purview_account.name == "tftstr-001"
    error_message = "Failed to deploy."
  }
}
