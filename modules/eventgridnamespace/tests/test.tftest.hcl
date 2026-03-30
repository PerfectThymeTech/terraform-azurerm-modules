run "create_eventgrid_namespace" {
  command = apply

  variables {
    location            = "northeurope"
    resource_group_name = "tfmodule-test-rg"
    tags = {
      test = "keyvault"
    }
    eventgrid_namespace_name     = "tftstr-001"
    eventgrid_namespace_sku      = "Standard"
    eventgrid_namespace_capacity = 1
    eventgrid_topics = {
      topic001 = {
        event_retention_in_days = 1
        input_schema            = "CloudEventSchemaV1_0"
        publisher_type          = "Custom"
      }
    }
    diagnostics_configurations    = []
    subnet_id                     = "/subscriptions/1fdab118-1638-419a-8b12-06c9543714a0/resourceGroups/ptt-dev-networking-rg/providers/Microsoft.Network/virtualNetworks/spoke-ptt-dev-vnet001/subnets/TerraformTestSubnet"
    connectivity_delay_in_seconds = 0
    private_dns_zone_id_topic     = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.eventgrid.azure.net"
    customer_managed_key          = null
  }

  assert {
    condition     = azurerm_eventgrid_namespace.eventgrid_namespace.resource_group_name == "tfmodule-test-rg"
    error_message = "Failed to deploy."
  }
}
