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
    subnet_id                            = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/tfmdltst-dev-rg/providers/Microsoft.Network/virtualNetworks/tfmdltst-dev-vnet/subnets/PrivateEndpoints"
    connectivity_delay_in_seconds        = 0
    private_dns_zone_id_vault            = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"
    customer_managed_key                 = null
  }

  assert {
    condition     = azurerm_key_vault.key_vault.resource_group_name == "tfmodule-test-rg"
    error_message = "Failed to deploy."
  }
}
