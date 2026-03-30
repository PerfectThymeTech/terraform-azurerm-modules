# Not enabled as other workspaces not in the list would be removed from the domain. Use null_resource with local-exec provisioner to assign the workspace to the domain instead.
# resource "fabric_domain_workspace_assignments" "domain_workspace_assignments" {
#   count = var.workspace_domain_id == null ? 0 : 1

#   domain_id = one(data.fabric_domain.domain[*].id)
#   workspace_ids = [
#     fabric_workspace.workspace.id
#   ]
# }

resource "null_resource" "workspace_domain" {
  count = var.workspace_domain_id == null ? 0 : 1
  triggers = {
    run_once     = "true"
    workspace_id = fabric_workspace.workspace.id
    domain_id    = var.workspace_domain_id
  }
  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = "./Set-WorkspaceDomain.ps1 -WorkspaceId '${fabric_workspace.workspace.id}' -DomainId '${var.workspace_domain_id}'"
    on_failure  = fail
    quiet       = false
    when        = create
    working_dir = "${path.module}/scripts/"
  }
  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = "./Set-WorkspaceDomain.ps1 -WorkspaceId '${self.triggers.workspace_id}' -DomainId '${self.triggers.domain_id}' -Unassign $true"
    on_failure  = fail
    quiet       = false
    when        = destroy
    working_dir = "${path.module}/scripts/"
  }
}
