variables {
  location            = "northeurope"
  resource_group_name = "tfmdltst-dev-rg"
  tags = {
    test = "botservice"
  }
  subnet_id                     = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/tfmdltst-dev-rg/providers/Microsoft.Network/virtualNetworks/tfmdltst-dev-vnet/subnets/PrivateEndpoints"
  connectivity_delay_in_seconds = 0
}

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
    resource_group_name  = "tfmdltst-dev-rg"
    tags                 = var.tags
    bot_service_name     = "tfmdlbot-int-bot"
    bot_service_endpoint = "https://example.com"
    bot_service_luis = {
      app_ids = []
      key     = null
    }
    bot_service_microsoft_app = {
      app_id        = ""
      app_msi_id    = null
      app_tenant_id = ""
      app_type      = "SingleTenant"
    }
    bot_service_sku                           = "S1"
    bot_service_streaming_endpoint_enabled    = false
    bot_service_public_network_access_enabled = true
    bot_service_application_insights_id       = run.setup.application_insights_id
    diagnostics_configurations                = []
    subnet_id                                 = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/tfmdltst-dev-rg/providers/Microsoft.Network/virtualNetworks/tfmdltst-dev-vnet/subnets/PrivateEndpoints"
    connectivity_delay_in_seconds             = 0
    customer_managed_key                      = null
  }

  assert {
    condition     = azurerm_bot_service_azure_bot.bot_service_azure_bot.resource_group_name == "tfmdltst-dev-rg"
    error_message = "Failed to deploy."
  }
}
