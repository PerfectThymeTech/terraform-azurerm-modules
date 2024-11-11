locals {
  prefix = "${lower(var.prefix)}-${var.environment}"
  diagnostics_configurations = var.log_analytics_workspace_id == "" ? [] : [
    {
      log_analytics_workspace_id = var.log_analytics_workspace_id
      storage_account_id         = ""
    }
  ]

  # Resource id's
  virtual_network = {
    name                = reverse(split("/", var.virtual_network_id))[0]
    resource_group_name = split("/", var.virtual_network_id)[4]
  }
}
