resource "null_resource" "workspace_disagnostics_onelake" {
  count = var.workspace_onelake_diagnostics.enabled == true ? 1 : 0
  triggers = {
    run_once                         = "true"
    workspace_id                     = fabric_workspace.workspace.id
    onelake_diagnostics_workspace_id = var.workspace_onelake_diagnostics.workspace_id
    onelake_diagnostics_lakehouse_id = var.workspace_onelake_diagnostics.lakehouse_id
  }
  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = "./Set-WorkspaceOneLakeDiagnostics.ps1 -WorkspaceId '${fabric_workspace.workspace.id}' -OneLakeDiagnosticsWorkspaceId '${var.workspace_onelake_diagnostics.workspace_id}' -OneLakeDiagnosticsLakehouseId '${var.workspace_onelake_diagnostics.lakehouse_id}'"
    on_failure  = fail
    quiet       = false
    when        = create
    working_dir = "${path.module}/scripts/"
  }
}
