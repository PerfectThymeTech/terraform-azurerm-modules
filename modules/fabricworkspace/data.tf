data "azapi_resource" "fabric_capacity" {
  count = var.workspace_capacity_id == null ? 0 : 1

  type        = "Microsoft.Fabric/capacities@2023-11-01"
  resource_id = var.workspace_capacity_id

  response_export_values = ["*"]
}

data "fabric_capacities" "capacities" {}

# Not enabled as other workspaces not in the list would be removed from the domain
# data "fabric_domain" "domain" {
#   count = var.workspace_domain_id == null ? 0 : 1

#   id = var.workspace_domain_id
# }
