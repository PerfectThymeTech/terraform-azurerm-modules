output "databricks_access_connector_id" {
  description = "Specifies the id of the databricks access connector."
  value       = module.databricks_access_connector.databricks_access_connector_id
  sensitive   = false
}

output "subnets_id" {
  description = "Specifies the id's of the subnets."
  value = {
    for key, value in var.subnets :
    key => azurerm_subnet.subnet[key].id
  }
  sensitive = false
}

output "subnets_network_security_group_association" {
  description = "Specifies the id's of the subnet nsg associations."
  value = {
    for key, value in var.subnets :
    key => azurerm_subnet_network_security_group_association.subnets_network_security_group_association[key].id
  }
  sensitive = false
}

output "subnets_route_table_association" {
  description = "Specifies the id's of the subnet route table associations."
  value = {
    for key, value in var.subnets :
    key => azurerm_subnet_route_table_association.subnets_route_table_association[key].id
  }
  sensitive = false
}
