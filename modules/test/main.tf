terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.2"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9.1"
    }
  }

  backend "azurerm" {
    environment          = "public"
    resource_group_name  = "<provided-via-config>"
    storage_account_name = "<provided-via-config>"
    container_name       = "<provided-via-config>"
    key                  = "<provided-via-config>"
    use_azuread_auth     = true
  }
}

provider "azurerm" {
  disable_correlation_request_id  = false
  environment                     = "public"
  resource_provider_registrations = "none"
  storage_use_azuread             = true
  use_oidc                        = true

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
  default_location               = local.location
  default_tags                   = local.tags
  disable_correlation_request_id = false
  enable_preflight               = true
  environment                    = "public"
  skip_provider_registration     = false
  use_oidc                       = true
}

provider "null" {}

provider "time" {}

locals {
  location            = "northeurope"
  resource_group_name = "tfmodule-test-rg"
  tags = {
    test = "aistudioproject"
  }
  subnet_id                     = "/subscriptions/1fdab118-1638-419a-8b12-06c9543714a0/resourceGroups/ptt-dev-networking-rg/providers/Microsoft.Network/virtualNetworks/spoke-ptt-dev-vnet001/subnets/TerraformTestSubnet"
  connectivity_delay_in_seconds = 0
}

module "setup" {
  source = "./setup"

  providers = {
    azurerm = azurerm
    azapi   = azapi
    time    = time
  }

  location                                       = local.location
  environment                                    = "int"
  prefix                                         = "mbprj002"
  resource_group_name                            = local.resource_group_name
  tags                                           = local.tags
  log_analytics_workspace_id                     = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-logging-rg/providers/Microsoft.OperationalInsights/workspaces/ptt-dev-log001"
  subnet_id                                      = local.subnet_id
  connectivity_delay_in_seconds                  = local.connectivity_delay_in_seconds
  private_dns_zone_id_container_registry         = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io"
  private_dns_zone_id_vault                      = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"
  private_dns_zone_id_blob                       = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
  private_dns_zone_id_file                       = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net"
  private_dns_zone_id_table                      = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.table.core.windows.net"
  private_dns_zone_id_queue                      = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.queue.core.windows.net"
  private_dns_zone_id_machine_learning_api       = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.api.azureml.ms"
  private_dns_zone_id_machine_learning_notebooks = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.notebooks.azure.net"
}

module "ai_studio_project" {
  source = "../aistudioproject"

  providers = {
    azurerm = azurerm
    azapi   = azapi
  }

  location                      = "northeurope"
  resource_group_name           = "tfmodule-test-rg"
  tags                          = local.tags
  ai_studio_project_name        = "mbprj002"
  ai_studio_hub_id              = module.setup.ai_studio_hub_id
  ai_studio_project_connections = {}
  diagnostics_configurations    = []
}

module "ai_service" {
  source = "../aiservice"

  providers = {
    azurerm = azurerm
    azapi   = azapi
    time    = time
  }

  location                  = "swedencentral"
  location_private_endpoint = "northeurope"
  resource_group_name       = "tfmodule-test-rg"
  tags = {
    test = "aiservice"
  }
  cognitive_account_name                                  = "mbprj002-aoai001"
  cognitive_account_kind                                  = "OpenAI"
  cognitive_account_sku                                   = "S0"
  cognitive_account_firewall_bypass_azure_services        = false
  cognitive_account_outbound_network_access_restricted    = true
  cognitive_account_outbound_network_access_allowed_fqdns = ["microsoft.com"]
  cognitive_account_deployments                           = {}
  diagnostics_configurations                              = []
  subnet_id                                               = "/subscriptions/1fdab118-1638-419a-8b12-06c9543714a0/resourceGroups/ptt-dev-networking-rg/providers/Microsoft.Network/virtualNetworks/spoke-ptt-dev-vnet001/subnets/TerraformTestSubnet"
  connectivity_delay_in_seconds                           = 0
  private_dns_zone_id_cognitive_account                   = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.cognitiveservices.azure.com"
  customer_managed_key                                    = null
}

module "ai_studio_hub_outbound_rules" {
  source = "../aistudiooutboundrules"

  providers = {
    azapi = azapi
    null  = null
  }

  ai_studio_hub_id                   = module.setup.ai_studio_hub_id
  ai_studio_hub_storage_account_id   = module.setup.ai_studio_hub_storage_account_id
  ai_studio_hub_outbound_rules_fqdns = {}
  ai_studio_hub_outbound_rules_private_endpoints = {
    aoai = {
      private_connection_resource_id = module.ai_service.cognitive_account_id
      subresource_name               = "account"
    }
  }
  ai_studio_hub_outbound_rules_service_endpoints = {}
  ai_studio_hub_provision_managed_network        = true
  ai_studio_hub_approve_private_endpoints        = true
}
