resource "azurerm_search_service" "search_service" {
  name                = var.search_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }

  allowed_ips                              = []
  authentication_failure_mode              = var.search_service_authentication_failure_mode
  customer_managed_key_enforcement_enabled = var.customer_managed_key != null ? true : false
  hosting_mode                             = var.search_service_hosting_mode
  local_authentication_enabled             = var.search_service_local_authentication_enabled
  partition_count                          = var.search_service_partition_count
  public_network_access_enabled            = false
  replica_count                            = var.search_service_replica_count
  sku                                      = var.search_service_sku
  semantic_search_sku                      = var.search_service_semantic_search_sku
}
