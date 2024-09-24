provider "fabric" {}

run "create_fabric_workspace" {
  command = apply

  variables {
    workspace_capacity_id      = null
    workspace_display_name     = "MyTestWs"
    workspace_description      = "My Test Workspace"
    workspace_identity_enabled = true
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
