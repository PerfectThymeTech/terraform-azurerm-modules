resource "fabric_workspace_managed_private_endpoint" "workspace_managed_private_endpoint" {
  for_each = var.workspace_managed_private_endpoints

  name         = each.key
  workspace_id = fabric_workspace.workspace.id

  request_message                 = "Request from workspace ${fabric_workspace.workspace.id} with name ${fabric_workspace.workspace.display_name}"
  target_private_link_resource_id = each.value.target_private_link_resource_id
  target_subresource_type         = each.value.target_subresource_type
}

resource "null_resource" "workspace_managed_private_endpoint_approval" {
  for_each = var.workspace_managed_private_endpoints

  triggers = {
    run_once           = "true"
    name               = fabric_workspace_managed_private_endpoint.workspace_managed_private_endpoint[each.key].name
    subresource_type   = fabric_workspace_managed_private_endpoint.workspace_managed_private_endpoint[each.key].target_subresource_type
    target_resource_id = fabric_workspace_managed_private_endpoint.workspace_managed_private_endpoint[each.key].target_private_link_resource_id
    connection_state   = fabric_workspace_managed_private_endpoint.workspace_managed_private_endpoint[each.key].connection_state.status
    actions_required   = fabric_workspace_managed_private_endpoint.workspace_managed_private_endpoint[each.key].connection_state.actions_required
    provisioning_state = fabric_workspace_managed_private_endpoint.workspace_managed_private_endpoint[each.key].provisioning_state
  }
  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = "./Approve-ManagedPrivateEndpoint.ps1 -ResourceId '${fabric_workspace_managed_private_endpoint.workspace_managed_private_endpoint[each.key].target_private_link_resource_id}' -WorkspaceName '${fabric_workspace.workspace.id}' -ManagedPrivateEndpointName '${fabric_workspace_managed_private_endpoint.workspace_managed_private_endpoint[each.key].name}'"
    on_failure  = fail
    quiet       = false
    when        = create
    working_dir = "${path.module}/scripts/"
  }
}
