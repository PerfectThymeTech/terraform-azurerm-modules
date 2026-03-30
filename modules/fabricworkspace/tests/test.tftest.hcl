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

provider "fabric" {
  preview = true
}

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
    workspace_display_name     = "MyTestWs"
    workspace_description      = "My Test Workspace"
    workspace_domain_id        = "3545bf73-5300-432e-8401-09a40b59c8b1"
    workspace_capacity_name    = "mabutst" # run.setup.fabric_capacity_name
    workspace_tag_ids          = ["712b09c6-4bac-4782-8002-387f354ce4b1", "83b0afef-d404-4921-9a3b-577bd7e03fbf"]
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
        notebook_pipeline_run_enabled    = true
      }
      job = {
        conservative_job_admission_enabled = true
        session_timeout_in_minutes         = 30
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
    workspace_managed_private_endpoints = {
      test_endpoint = {
        target_private_link_resource_id = "/subscriptions/1fdab118-1638-419a-8b12-06c9543714a0/resourceGroups/tfmodule-test-rg/providers/Microsoft.Storage/storageAccounts/mytfteststg"
        target_subresource_type         = "blob"
        approve                         = true
      }
    }
    workspace_onelake_diagnostics = {
      enabled      = true
      workspace_id = "949494f4-3616-43ea-9f2f-c19152efa3d9"
      lakehouse_id = "2e815603-1b04-4851-84ae-3b389330e530"
    }
  }

  assert {
    condition     = fabric_workspace.workspace.display_name == "MyTestWs"
    error_message = "Failed to deploy."
  }
}
