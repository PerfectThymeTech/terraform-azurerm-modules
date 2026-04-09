run "create_mssql_server" {
  command = apply

  variables {
    location            = "northeurope"
    resource_group_name = "tfmodule-test-rg"
    tags = {
      test = "mssqlserver"
    }
    mssql_server_name              = "tftstr-001"
    mssql_server_connection_policy = "Default"
    mssql_server_version           = "12.0"
    diagnostics_configurations     = []
    subnet_id                      = "/subscriptions/1fdab118-1638-419a-8b12-06c9543714a0/resourceGroups/ptt-dev-networking-rg/providers/Microsoft.Network/virtualNetworks/spoke-ptt-dev-vnet001/subnets/TerraformTestSubnet"
    connectivity_delay_in_seconds  = 0
    private_dns_zone_id_sqlserver  = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.database.windows.net"
    customer_managed_key           = null
  }

  assert {
    condition     = azurerm_mssql_server.mssql_server.resource_group_name == "tfmodule-test-rg"
    error_message = "Failed to deploy."
  }
}
