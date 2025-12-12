run "create_ai_foundry" {
  command = apply

  variables {
    location                  = "swedencentral"
    location_private_endpoint = "northeurope"
    resource_group_name       = "tfmodule-test-rg"
    tags = {
      test = "aifoundry"
    }
    ai_services_name                                  = "tftstr-001"
    ai_services_sku                                   = "S0"
    ai_services_firewall_bypass_azure_services        = true
    ai_services_outbound_network_access_restricted    = true
    ai_services_outbound_network_access_allowed_fqdns = []
    ai_services_local_auth_enabled                    = false
    ai_services_projects = {
      firstproject = {
        description  = "first-project"
        display_name = "first-project"
      }
    }
    ai_services_deployments               = {}
    diagnostics_configurations            = []
    subnet_id                             = "/subscriptions/1fdab118-1638-419a-8b12-06c9543714a0/resourceGroups/ptt-dev-networking-rg/providers/Microsoft.Network/virtualNetworks/spoke-ptt-dev-vnet001/subnets/TerraformTestSubnet"
    connectivity_delay_in_seconds         = 0
    private_dns_zone_id_ai_services       = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.services.ai.azure.com"
    private_dns_zone_id_cognitive_account = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.cognitiveservices.azure.com"
    private_dns_zone_id_open_ai           = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.openai.azure.com"
    customer_managed_key                  = null
  }

  assert {
    condition     = azapi_resource.ai_services.name == "tftstr-001"
    error_message = "Failed to deploy."
  }
  assert {
    condition     = length(azapi_resource.ai_services.identity[0].principal_id) > 0
    error_message = "Failed to deploy."
  }
}
