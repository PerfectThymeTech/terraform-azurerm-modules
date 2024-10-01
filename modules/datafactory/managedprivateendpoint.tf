resource "azurerm_data_factory_managed_private_endpoint" "data_factory_managed_private_endpoints" {
  for_each = var.data_factory_managed_private_endpoints

  name            = each.key
  data_factory_id = azurerm_data_factory.data_factory.id

  subresource_name   = each.value.subresource_name
  target_resource_id = each.value.target_resource_id
}

resource "null_resource" "data_factory_managed_private_endpoint_storage_blob_approval" {
  for_each = var.data_factory_managed_private_endpoints

  triggers = {
    run_once = "true"
  }
  provisioner "local-exec" {
    working_dir = "${path.module}/../scripts/"
    interpreter = ["pwsh", "-Command"]
    command     = "./Approve-ManagedPrivateEndpoint.ps1 -ResourceId '${each.value.target_resource_id}' -WorkspaceName '${azurerm_data_factory.data_factory.name}' -ManagedPrivateEndpointName '${azurerm_data_factory_managed_private_endpoint.data_factory_managed_private_endpoints[each.key].name}'"
  }
}
