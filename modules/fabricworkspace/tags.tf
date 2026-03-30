resource "null_resource" "workspace_tags" {
  for_each = {
    for idx, tag_id in var.workspace_tag_ids : tag_id => tag_id
  }
  triggers = {
    run_once     = "true"
    workspace_id = fabric_workspace.workspace.id
    tag_ids      = join(",", var.workspace_tag_ids)
  }
  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = "./Set-WorkspaceTags.ps1 -WorkspaceId '${fabric_workspace.workspace.id}' -TagIds '${each.value}'"
    on_failure  = fail
    quiet       = false
    when        = create
    working_dir = "${path.module}/scripts/"
  }
  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = "./Set-WorkspaceTags.ps1 -WorkspaceId '${fabric_workspace.workspace.id}' -TagIds '${each.value}' -Unassign $true"
    on_failure  = fail
    quiet       = false
    when        = destroy
    working_dir = "${path.module}/scripts/"
  }
}
