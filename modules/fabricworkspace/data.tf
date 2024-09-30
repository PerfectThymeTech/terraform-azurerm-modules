# Not enabled as other workspaces not in the list would be removed from the domain
# data "fabric_domain" "domain" {
#   count = var.workspace_domain_id == null ? 0 : 1

#   id = var.workspace_domain_id
# }
