run "create_synapse_private_link_hub" {
  command = apply

  variables {
    location            = "northeurope"
    resource_group_name = "tfmodule-test-rg"
    tags = {
      test = "synapse-pl-hub"
    }
    synapse_private_link_hub_name        = "tftstr-001"
    diagnostics_configurations           = []
    subnet_id                            = "/subscriptions/1fdab118-1638-419a-8b12-06c9543714a0/resourceGroups/ptt-dev-networking-rg/providers/Microsoft.Network/virtualNetworks/spoke-ptt-dev-vnet001/subnets/TerraformTestSubnet"
    connectivity_delay_in_seconds        = 0
    private_dns_zone_id_synapse_portal   = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.azuresynapse.net"
  }

  assert {
    condition     = azurerm_synapse_private_link_hub.synapse_private_link_hub.resource_group_name == "tfmodule-test-rg"
    error_message = "Failed to deploy."
  }
}
