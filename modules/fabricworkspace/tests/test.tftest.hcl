variables {
  location            = "germanywestcentral"
  resource_group_name = "tfmodule-test-rg"
  tags = {
    test = "fabric-workspace"
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

provider "fabric" {}

run "setup" {
  command = apply

  module {
    source = "./tests/setup"
  }

  providers = {
    azapi = azapi
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
    workspace_capacity_id      = run.setup.fabric_capacity_id
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

  assert {
    condition     = fabric_workspace.workspace.display_name == "MyTestWs"
    error_message = "Failed to deploy."
  }
}
