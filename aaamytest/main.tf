terraform {
  required_version = "~> 1.8"

  required_providers {
    fabric = {
      source  = "microsoft/fabric"
      version = "0.1.0-beta.2"
    }
  }
}

provider "fabric" {
  
}


module "fabric" {
  source = "../modules/fabricworkspace"

  workspace_capacity_id      = null
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
