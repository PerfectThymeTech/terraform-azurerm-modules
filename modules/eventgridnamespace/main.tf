resource "azurerm_eventgrid_namespace" "eventgrid_namespace" {
  name                = var.eventgrid_namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }

  capacity              = var.eventgrid_namespace_capacity
  public_network_access = "Disabled"
  sku                   = var.eventgrid_namespace_sku
}

resource "azapi_resource" "eventgrid_namespace_topics" {
  for_each = var.eventgrid_topics

  type      = "Microsoft.EventGrid/namespaces/topics@2025-07-15-preview"
  name      = each.key
  parent_id = azurerm_eventgrid_namespace.eventgrid_namespace.id

  body = {
    properties = {
      eventRetentionInDays = each.value.event_retention_in_days
      inputSchema          = each.value.input_schema
      publisherType        = each.value.publisher_type
    }
  }
}
