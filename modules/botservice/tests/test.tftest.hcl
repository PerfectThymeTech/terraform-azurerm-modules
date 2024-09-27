variables {
  location            = "northeurope"
  location_bot        = "global"
  resource_group_name = "tfmodule-test-rg"
  tags = {
    test = "botservice"
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
    location                   = var.location
    environment                = "int"
    prefix                     = "tfmdlbot"
    resource_group_name        = var.resource_group_name
    tags                       = var.tags
    log_analytics_workspace_id = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/DefaultResourceGroup-WEU/providers/Microsoft.OperationalInsights/workspaces/DefaultWorkspace-8f171ff9-2b5b-4f0f-aed5-7fa360a1d094-WEU"
  }
}

run "create_botservice" {
  command = apply

  variables {
    location             = var.location
    resource_group_name  = "tfmodule-test-rg"
    tags                 = var.tags
    bot_service_name     = "tfmdlbot-int-bot"
    bot_service_location = var.location_bot
    bot_service_endpoint = "https://example.com"
    bot_service_luis = {
      app_ids = []
      key     = null
    }
    bot_service_microsoft_app = {
      app_id        = run.setup.user_assigned_identity_client_id
      app_msi_id    = run.setup.user_assigned_identity_id
      app_tenant_id = run.setup.user_assigned_identity_tenant_id
      app_type      = "UserAssignedMSI"
    }
    bot_service_sku                              = "S1"
    bot_service_streaming_endpoint_enabled       = false
    bot_service_public_network_access_enabled    = true
    bot_service_application_insights_id          = run.setup.application_insights_id
    bot_service_application_insights_key_enabled = false
    diagnostics_configurations                   = []
    subnet_id                                    = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/tfmdltst-dev-rg/providers/Microsoft.Network/virtualNetworks/tfmdltst-dev-vnet/subnets/PrivateEndpoints"
    connectivity_delay_in_seconds                = 0
    private_dns_zone_id_bot_framework_directline = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.directline.botframework.com"
    private_dns_zone_id_bot_framework_token      = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.token.botframework.com"
    customer_managed_key                         = null
  }

  assert {
    condition     = azurerm_bot_service_azure_bot.bot_service_azure_bot.resource_group_name == "tfmodule-test-rg"
    error_message = "Failed to deploy."
  }
}
