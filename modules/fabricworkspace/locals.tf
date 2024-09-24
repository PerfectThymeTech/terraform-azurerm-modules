locals {
  workspace_role_assignments_map = {
    for item in var.workspace_role_assignments :
    "${item.principal_id}-${item.role}" => item
  }
}
