run "create_ai_service" {
  command = apply

  variables {
    location                  = "swedencentral"
    location_private_endpoint = "northeurope"
    resource_group_name       = "tfmodule-test-rg"
    tags = {
      test = "aiservice"
    }
    cognitive_account_name                                  = "mytftst-001"
    cognitive_account_kind                                  = "OpenAI"
    cognitive_account_sku                                   = "S0"
    cognitive_account_firewall_bypass_azure_services        = true
    cognitive_account_outbound_network_access_restricted    = true
    cognitive_account_outbound_network_access_allowed_fqdns = ["microsoft.com"]
    cognitive_account_deployments                           = {}
    diagnostics_configurations                              = []
    subnet_id                                               = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/tfmdltst-dev-rg/providers/Microsoft.Network/virtualNetworks/tfmdltst-dev-vnet/subnets/PrivateEndpoints"
    connectivity_delay_in_seconds                           = 0
    private_dns_zone_id_cognitive_account                   = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.cognitiveservices.azure.com"
    customer_managed_key                                    = null
  }

  assert {
    condition     = azurerm_cognitive_account.cognitive_account.resource_group_name == "tfmodule-test-rg"
    error_message = "Failed to deploy."
  }
}
