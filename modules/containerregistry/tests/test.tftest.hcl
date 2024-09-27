run "create_containerregistry" {
  command = apply

  variables {
    location            = "northeurope"
    resource_group_name = "tfmodule-test-rg"
    tags = {
      test = "containerregistry"
    }
    container_registry_name                      = "tftstr001"
    container_registry_admin_enabled             = false
    container_registry_anonymous_pull_enabled    = false
    container_registry_data_endpoint_enabled     = false
    container_registry_export_policy_enabled     = false
    container_registry_quarantine_policy_enabled = false
    container_registry_retention_policy_in_days  = 7
    container_registry_trust_policy_enabled      = false
    container_registry_zone_redundancy_enabled   = false
    diagnostics_configurations                   = []
    subnet_id                                    = "/subscriptions/1fdab118-1638-419a-8b12-06c9543714a0/resourceGroups/ptt-dev-networking-rg/providers/Microsoft.Network/virtualNetworks/spoke-ptt-dev-vnet001/subnets/TerraformTestSubnet"
    connectivity_delay_in_seconds                = 0
    private_dns_zone_id_container_registry       = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io"
    customer_managed_key                         = null
  }

  assert {
    condition     = azurerm_container_registry.container_registry.resource_group_name == "tfmodule-test-rg"
    error_message = "Failed to deploy."
  }
}
