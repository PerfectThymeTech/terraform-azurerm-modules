resource "fabric_workspace_role_assignment" "workspace_role_assignment" {
  for_each = var.workspace_role_assignments

  workspace_id = fabric_workspace.workspace.id

  principal = {
    id   = each.value.principal_id
    type = each.value.principal_type
  }
  role = each.value.role
}
