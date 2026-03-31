resource "azurerm_search_shared_private_link_service" "search_shared_private_link_service" {
  for_each = var.search_service_shared_private_links

  name              = each.key
  search_service_id = azurerm_search_service.search_service.id

  request_message    = "Shared Private Link requested from ${azurerm_search_service.search_service.name}"
  subresource_name   = each.value.subresource_name
  target_resource_id = each.value.target_resource_id
}

resource "null_resource" "search_shared_private_link_service_approval" {
  for_each = {
    for key, value in var.search_service_shared_private_links : key => value if value.approve
  }

  triggers = {
    run_once           = "true"
    name               = azurerm_search_shared_private_link_service.search_shared_private_link_service[each.key].name
    subresource_name   = azurerm_search_shared_private_link_service.search_shared_private_link_service[each.key].subresource_name
    target_resource_id = azurerm_search_shared_private_link_service.search_shared_private_link_service[each.key].target_resource_id
    status             = azurerm_search_shared_private_link_service.search_shared_private_link_service[each.key].status
    request_message    = azurerm_search_shared_private_link_service.search_shared_private_link_service[each.key].request_message
  }
  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = "./Approve-ManagedPrivateEndpoint.ps1 -ResourceId '${azurerm_search_shared_private_link_service.search_shared_private_link_service[each.key].target_resource_id}' -WorkspaceName '${azurerm_search_service.search_service.name}' -ManagedPrivateEndpointName '${azurerm_search_shared_private_link_service.search_shared_private_link_service[each.key].name}' -RequestMessage '${azurerm_search_shared_private_link_service.search_shared_private_link_service[each.key].request_message}'"
    on_failure  = fail
    quiet       = false
    when        = create
    working_dir = "${path.module}/scripts/"
  }
}
