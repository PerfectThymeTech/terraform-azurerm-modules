variables {
  location            = "germanywestcentral"
  resource_group_name = "tfmodule-test-rg"
  tags = {
    test = "fabric-workspace"
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
  default_location               = var.location
  default_tags                   = var.tags
  disable_correlation_request_id = false
  enable_preflight               = true
  environment                    = "public"
  skip_provider_registration     = false
  use_oidc                       = true
}

provider "fabric" {}

run "setup" {
  command = apply

  module {
    source = "./tests/setup"
  }

  providers = {
    azurerm = azurerm
    azapi   = azapi
  }

  variables {
    location            = var.location
    environment         = "int"
    prefix              = "tfmdlfbrc"
    resource_group_name = var.resource_group_name
    tags                = var.tags
  }
}

run "create_fabric_workspace" {
  command = apply

  variables {
    workspace_capacity_name    = run.setup.fabric_capacity_name
    workspace_display_name     = "MyTestWs"
    workspace_description      = "My Test Workspace"
    workspace_identity_enabled = true
    workspace_spark_settings = {
      enabled = false
      automatic_log = {
        enabled = true
      }
      # environment = {
      #   default_environment_name = ""
      #   runtime_version          = "1.3"
      # }
      high_concurrency = {
        notebook_interactive_run_enabled = true
      }
      pool = {
        customize_compute_enabled = true
        # default_pool_name         = "starterPool"
      }
    }
    workspace_git = null
    workspace_role_assignments = {
      my_sp = {
        principal_id   = "973df2ad-4e5e-4e8b-9df6-17f61e9efd55"
        principal_type = "ServicePrincipal"
        role           = "Viewer"
      }
    }
  }

  # assert {
  #   condition     = fabric_workspace.workspace.display_name == "MyTestWs"
  #   error_message = "Failed to deploy."
  # }
}
