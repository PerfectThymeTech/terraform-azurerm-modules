run "create_ai_service" {
  command = apply

  variables {
    location                  = "swedencentral"
    location_private_endpoint = "northeurope"
    resource_group_name       = "tfmodule-test-rg"
    tags = {
      test = "aiservice"
    }
    cognitive_account_name                                  = "tftstr-001"
    cognitive_account_kind                                  = "OpenAI"
    cognitive_account_sku                                   = "S0"
    cognitive_account_firewall_bypass_azure_services        = true
    cognitive_account_outbound_network_access_restricted    = true
    cognitive_account_outbound_network_access_allowed_fqdns = ["microsoft.com"]
    cognitive_account_deployments                           = {}
    diagnostics_configurations                              = []
    subnet_id                                               = "/subscriptions/1fdab118-1638-419a-8b12-06c9543714a0/resourceGroups/ptt-dev-networking-rg/providers/Microsoft.Network/virtualNetworks/spoke-ptt-dev-vnet001/subnets/TerraformTestSubnet"
    connectivity_delay_in_seconds                           = 0
    private_dns_zone_id_cognitive_account                   = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.cognitiveservices.azure.com"
    customer_managed_key                                    = null
  }

  assert {
    condition     = azurerm_cognitive_account.cognitive_account.resource_group_name == "tfmodule-test-rg"
    error_message = "Failed to deploy."
  }
}
