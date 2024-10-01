terraform {
  required_version = "~> 1.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = ">= 1.14.0"
    }
    fabric = {
      source  = "microsoft/fabric"
      version = "0.1.0-beta.3"
    }
  }
}

provider "azurerm" {
  disable_correlation_request_id  = false
  environment                     = "public"
  resource_provider_registrations = "none"
  storage_use_azuread             = true
  use_oidc                        = true
  subscription_id = "1fdab118-1638-419a-8b12-06c9543714a0"

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
  default_location               = "germanywestcentral"
  default_tags                   = {}
  disable_correlation_request_id = false
  environment                    = "public"
  skip_provider_registration     = false
  use_oidc                       = true
}

provider "fabric" {}

module "fabric_capacity" {
  source = "../../modules/fabriccapacity"

  location                     = "germanywestcentral"
  resource_group_name          = "tfmodule-test-rg"
  tags                         = {}
  fabric_capacity_name         = "tstcpcty004"
  fabric_capacity_admin_emails = []
  fabric_capacity_sku          = "F2"
}

module "fabric" {
  source = "../../modules/fabricworkspace"

  workspace_capacity_name      = module.fabric_capacity.fabric_capacity_id
  workspace_display_name     = "MyTestWs"
  workspace_description      = "My Test Workspace"
  workspace_identity_enabled = false
  workspace_settings = {
    automatic_log = {
      enabled = true
    }
    environment = {
      default_environment_name = ""
      runtime_version          = "1.3"
    }
    high_concurrency = {
      notebook_interactive_run_enabled = true
    }
    pool = {
      customize_compute_enabled = true
      default_pool_name         = "defaultpool"
    }
  }
  workspace_git              = null
  workspace_role_assignments = {}
}
