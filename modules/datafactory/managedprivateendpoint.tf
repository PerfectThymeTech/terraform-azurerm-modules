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
    run_once           = "true"
    name               = azurerm_data_factory_managed_private_endpoint.data_factory_managed_private_endpoints[each.key].name
    subresource_name   = azurerm_data_factory_managed_private_endpoint.data_factory_managed_private_endpoints[each.key].subresource_name
    target_resource_id = azurerm_data_factory_managed_private_endpoint.data_factory_managed_private_endpoints[each.key].target_resource_id
  }
  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = "./Approve-ManagedPrivateEndpoint.ps1 -ResourceId '${azurerm_data_factory_managed_private_endpoint.data_factory_managed_private_endpoints[each.key].target_resource_id}' -WorkspaceName '${azurerm_data_factory.data_factory.name}' -ManagedPrivateEndpointName '${azurerm_data_factory_managed_private_endpoint.data_factory_managed_private_endpoints[each.key].name}'"
    on_failure  = fail
    quiet       = false
    when        = create
    working_dir = "${path.module}/scripts/"
  }
}
