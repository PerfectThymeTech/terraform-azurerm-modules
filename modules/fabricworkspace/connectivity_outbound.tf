resource "fabric_workspace_network_communication_policy" "workspace_network_communication_policy" {
  workspace_id = fabric_workspace.workspace.id

  inbound = {
    public_access_rules = {
      default_action = var.workspace_network_communication_policy.inbound.public_access_rules.default_action
    }
  }
  outbound = {
    public_access_rules = {
      default_action = var.workspace_network_communication_policy.outbound.public_access_rules.default_action
    }
  }
}

resource "fabric_workspace_outbound_gateway_rules" "workspace_outbound_gateway_rules" {
  count = var.workspace_network_communication_policy.outbound.public_access_rules.default_action == "Deny" ? 1 : 0

  workspace_id = fabric_workspace.workspace.id

  allowed_gateways = [
    for gateway_id in var.workspace_outbound_gateway_rules.allowed_gateway_ids : {
      id = gateway_id
    }
  ]
  default_action = var.workspace_outbound_gateway_rules.default_action

  depends_on = [
    fabric_workspace_network_communication_policy.workspace_network_communication_policy
  ]
}
