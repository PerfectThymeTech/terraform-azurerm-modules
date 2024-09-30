run "create_key_vault" {
  command = apply

  variables {
    location            = "northeurope"
    resource_group_name = "tfmodule-test-rg"
    tags = {
      test = "keyvault"
    }
    key_vault_name                       = "tftstr-001"
    key_vault_sku_name                   = "standard"
    key_vault_soft_delete_retention_days = 7
    diagnostics_configurations           = []
    subnet_id                            = "/subscriptions/1fdab118-1638-419a-8b12-06c9543714a0/resourceGroups/ptt-dev-networking-rg/providers/Microsoft.Network/virtualNetworks/spoke-ptt-dev-vnet001/subnets/TerraformTestSubnet"
    connectivity_delay_in_seconds        = 0
    private_dns_zone_id_vault            = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"
    customer_managed_key                 = null
  }

  assert {
    condition     = azurerm_key_vault.key_vault.resource_group_name == "tfmodule-test-rg"
    error_message = "Failed to deploy."
  }
}
