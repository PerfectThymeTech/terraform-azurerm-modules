run "setup" {
  module {
    source = "./modules/setup"
  }

  variables {
    location            = "northeurope"
    environment         = "int"
    prefix              = "tfmdlaihub"
    resource_group_name = "tfmdltst-dev-rg"
    tags = {
      test = "loganalytics"
    }
    log_analytics_workspace_id             = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/DefaultResourceGroup-WEU/providers/Microsoft.OperationalInsights/workspaces/DefaultWorkspace-8f171ff9-2b5b-4f0f-aed5-7fa360a1d094-WEU"
    subnet_id                              = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/tfmdltst-dev-rg/providers/Microsoft.Network/virtualNetworks/tfmdltst-dev-vnet/subnets/PrivateEndpoints"
    connectivity_delay_in_seconds          = 0
    private_dns_zone_id_container_registry = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io"
    private_dns_zone_id_vault              = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"
    private_dns_zone_id_blob               = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
    private_dns_zone_id_file               = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net"
    private_dns_zone_id_table              = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.table.core.windows.net"
    private_dns_zone_id_queue              = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.queue.core.windows.net"
  }
}

run "create_aistudio" {
  command = apply

  variables {
    location            = "northeurope"
    resource_group_name = "tfmdltst-dev-rg"
    tags = {
      test = "loganalytics"
    }
    ai_studio_name                                 = "mytftst-001"
    application_insights_id                        = run.setup.application_insights_id
    container_registry_id                          = run.setup.container_registry_id
    key_vault_id                                   = run.setup.key_vault_id
    storage_account_id                             = run.setup.storage_account_id
    diagnostics_configurations                     = []
    subnet_id                                      = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/tfmdltst-dev-rg/providers/Microsoft.Network/virtualNetworks/tfmdltst-dev-vnet/subnets/PrivateEndpoints"
    connectivity_delay_in_seconds                  = 0
    private_dns_zone_id_machine_learning_api       = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.api.azureml.ms"
    private_dns_zone_id_machine_learning_notebooks = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.notebooks.azure.net"
    customer_managed_key                           = null
  }

  assert {
    condition     = azapi_resource.ai_studio_hub.resource_group_name == "tfmdltst-dev-rg"
    error_message = "Failed to deploy."
  }
}
