resource "fabric_workspace" "workspace" {
  display_name = var.workspace_display_name
  description  = var.workspace_description
  capacity_id  = data.fabric_capacity.capacity.id
  identity = var.workspace_identity_enabled ? {
    type = "SystemAssigned"
  } : null
}

# Not enabled as other workspaces not in the list would be removed from the domain
# resource "fabric_domain_workspace_assignments" "domain_workspace_assignments" {
#   count = var.workspace_domain_id == null ? 0 : 1

#   domain_id = one(data.fabric_domain.domain[*].id)
#   workspace_ids = [
#     fabric_workspace.workspace.id
#   ]
# }

resource "fabric_spark_workspace_settings" "workspace_settings" {
  count = var.workspace_capacity_name == null ? 0 : 1

  workspace_id = fabric_workspace.workspace.id

  automatic_log = {
    enabled = var.workspace_settings.automatic_log.enabled
  }
  # environment = {
  #   name            = var.workspace_settings.environment.default_environment_name
  #   runtime_version = var.workspace_settings.environment.runtime_version
  # }
  high_concurrency = {
    notebook_interactive_run_enabled = var.workspace_settings.high_concurrency.notebook_interactive_run_enabled
  }
  pool = {
    customize_compute_enabled = var.workspace_settings.pool.customize_compute_enabled
    # default_pool = {
    #   name = var.workspace_settings.pool.default_pool_name
    #   type = var.workspace_capacity_name == null ? "Workspace" : "Capacity"
    # }
    # starter_pool = {
    #   max_executors  = 3
    #   max_node_count = 1
    # }
  }
}

# resource "fabric_workspace_git" "workspace_git" {
#   count = var.workspace_git == null ? 0 : 1

#   workspace_id = fabric_workspace.workspace.id

#   git_provider_details = {
#     git_provider_type = var.workspace_git.git_provider_type
#     organization_name = var.workspace_git.organization_name
#     project_name      = var.workspace_git.project_name
#     repository_name   = var.workspace_git.repository_name
#     branch_name       = var.workspace_git.branch_name
#     directory_name    = var.workspace_git.directory_name
#   }
#   initialization_strategy = "PreferWorkspace"
# }

# resource "fabric_workspace_role_assignment" "example" {
#   for_each = var.workspace_role_assignments

#   workspace_id = fabric_workspace.workspace.id

#   principal_id   = each.value.principal_id
#   principal_type = each.value.principal_type
#   role           = each.value.role
# }
