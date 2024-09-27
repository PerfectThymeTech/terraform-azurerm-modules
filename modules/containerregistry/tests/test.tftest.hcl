run "create_containerregistry" {
  command = apply

  variables {
    location            = "northeurope"
    resource_group_name = "tfmodule-test-rg"
    tags = {
      test = "containerregistry"
    }
    container_registry_name                      = "mytftst001"
    container_registry_admin_enabled             = false
    container_registry_anonymous_pull_enabled    = false
    container_registry_data_endpoint_enabled     = false
    container_registry_export_policy_enabled     = false
    container_registry_quarantine_policy_enabled = false
    container_registry_retention_policy_in_days  = 7
    container_registry_trust_policy_enabled      = false
    container_registry_zone_redundancy_enabled   = false
    diagnostics_configurations                   = []
    subnet_id                                    = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/tfmdltst-dev-rg/providers/Microsoft.Network/virtualNetworks/tfmdltst-dev-vnet/subnets/PrivateEndpoints"
    connectivity_delay_in_seconds                = 0
    private_dns_zone_id_container_registry       = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io"
    customer_managed_key                         = null
  }

  assert {
    condition     = azurerm_container_registry.container_registry.resource_group_name == "tfmodule-test-rg"
    error_message = "Failed to deploy."
  }
}
