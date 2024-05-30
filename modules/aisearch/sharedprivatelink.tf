resource "azurerm_search_shared_private_link_service" "search_shared_private_link_service" {


  name              = each.key
  search_service_id = azurerm_search_service.search_service.id

  request_message    = "Shared Private Link requested from ${azurerm_search_service.search_service.name}"
  subresource_name   = each.value.subresource_name
  target_resource_id = each.value.target_resource_id
}
