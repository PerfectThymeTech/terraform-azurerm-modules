run "create_eventhubnamespace" {
  command = apply

  variables {
    location            = "northeurope"
    resource_group_name = "tfmodule-test-rg"
    tags = {
      test = "storage"
    }
    event_hub_namespace_name                         = "tftstr001"
    event_hub_namespace_auto_inflate_enabled         = true
    event_hub_namespace_capacity                     = 1
    event_hub_namespace_dedicated_cluster_id         = null
    event_hub_namespace_local_authentication_enabled = true
    event_hub_namespace_maximum_throughput_units     = 10
    event_hub_namespace_sku                          = "Standard"
    eventhub_namespace_authorization_rules = {
      ar01 = {
        listen = true
        manage = false
        send   = false
      }
    }
    event_hubs = {
      eh001 = {
        partition_count   = 1
        message_retention = 1
      }
    }
    diagnostics_configurations     = []
    subnet_id                      = "/subscriptions/1fdab118-1638-419a-8b12-06c9543714a0/resourceGroups/ptt-dev-networking-rg/providers/Microsoft.Network/virtualNetworks/spoke-ptt-dev-vnet001/subnets/TerraformTestSubnet"
    connectivity_delay_in_seconds  = 0
    private_dns_zone_id_servicebus = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.servicebus.windows.net"
    customer_managed_key           = null
  }

  assert {
    condition     = azurerm_eventhub_namespace.eventhub_namespace.resource_group_name == "tfmodule-test-rg"
    error_message = "Failed to deploy."
  }
}
