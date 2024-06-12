variables {
  location            = "northeurope"
  resource_group_name = "tfmdltst-dev-rg"
  tags = {
    test = "aistudiohub"
  }
  subnet_id                     = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/tfmdltst-dev-rg/providers/Microsoft.Network/virtualNetworks/tfmdltst-dev-vnet/subnets/PrivateEndpoints"
  connectivity_delay_in_seconds = 0
}

provider "azurerm" {
  disable_correlation_request_id = false
  environment                    = "public"
  skip_provider_registration     = false
  storage_use_azuread            = true
  use_oidc                       = true

  features {
    application_insights {
      disable_generated_rule = false
    }
    machine_learning {
      purge_soft_deleted_workspace_on_destroy = true
    }
    key_vault {
      purge_soft_delete_on_destroy               = false
      purge_soft_deleted_certificates_on_destroy = false
      purge_soft_deleted_keys_on_destroy         = false
      purge_soft_deleted_secrets_on_destroy      = false
      recover_soft_deleted_key_vaults            = true
      recover_soft_deleted_certificates          = true
      recover_soft_deleted_keys                  = true
      recover_soft_deleted_secrets               = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azapi" {
  default_location               = var.location
  default_tags                   = var.tags
  disable_correlation_request_id = false
  environment                    = "public"
  skip_provider_registration     = false
  use_oidc                       = true
}

provider "time" {}

run "setup" {
  command = apply

  module {
    source = "./tests/setup"
  }

  providers = {
    azurerm = azurerm
    time    = time
  }

  variables {
    location                               = var.location
    environment                            = "int"
    prefix                                 = "tfmdlaihub"
    resource_group_name                    = var.resource_group_name
    tags                                   = var.tags
    log_analytics_workspace_id             = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/DefaultResourceGroup-WEU/providers/Microsoft.OperationalInsights/workspaces/DefaultWorkspace-8f171ff9-2b5b-4f0f-aed5-7fa360a1d094-WEU"
    subnet_id                              = var.subnet_id
    connectivity_delay_in_seconds          = var.connectivity_delay_in_seconds
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

  providers = {
    azurerm = azurerm
    azapi   = azapi
    time    = time
  }

  variables {
    location                                       = var.location
    resource_group_name                            = var.resource_group_name
    tags                                           = var.tags
    ai_studio_hub_name                             = "mytftst-001"
    application_insights_id                        = run.setup.application_insights_id
    container_registry_id                          = run.setup.container_registry_id
    key_vault_id                                   = run.setup.key_vault_id
    storage_account_id                             = run.setup.storage_account_id
    # ai_studio_hub_outbound_rules_fqdns             = { "azure-com" = "azure.com" }
    # ai_studio_hub_outbound_rules_private_endpoints = {}
    # ai_studio_hub_outbound_rules_service_endpoints = {}
    ai_studio_hub_connections                      = {}
    diagnostics_configurations                     = []
    subnet_id                                      = var.subnet_id
    connectivity_delay_in_seconds                  = var.connectivity_delay_in_seconds
    private_dns_zone_id_machine_learning_api       = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.api.azureml.ms"
    private_dns_zone_id_machine_learning_notebooks = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.notebooks.azure.net"
    customer_managed_key                           = null
  }

  assert {
    condition     = azapi_resource.ai_studio_hub.name == "mytftst-001"
    error_message = "Failed to deploy."
  }
}
