resource "null_resource" "workspace_tags" {
  count = length(var.workspace_tag_ids) <= 0 ? 0 : 1
  triggers = {
    run_once     = "true"
    workspace_id = fabric_workspace.workspace.id
    tag_ids      = join(",", var.workspace_tag_ids)
  }
  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = "./Set-WorkspaceTags.ps1 -WorkspaceId '${fabric_workspace.workspace.id}' -TagIds '${replace(replace(jsonencode(var.workspace_tag_ids), "[", ""), "]", "")}'"
    on_failure  = fail
    quiet       = false
    when        = create
    working_dir = "${path.module}/scripts/"
  }
}
