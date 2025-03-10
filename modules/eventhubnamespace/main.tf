resource "azurerm_eventhub_namespace" "eventhub_namespace" {
  name                = var.event_hub_namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }

  auto_inflate_enabled         = var.event_hub_namespace_auto_inflate_enabled
  capacity                     = var.event_hub_namespace_capacity
  dedicated_cluster_id         = var.event_hub_namespace_dedicated_cluster_id
  local_authentication_enabled = var.event_hub_namespace_local_authentication_enabled
  maximum_throughput_units     = var.event_hub_namespace_maximum_throughput_units
  minimum_tls_version          = "1.2"
  network_rulesets {
    default_action                 = "Deny"
    ip_rule                        = []
    public_network_access_enabled  = false
    trusted_service_access_enabled = true
    virtual_network_rule           = []
  }
  public_network_access_enabled = false
  sku                           = var.event_hub_namespace_sku
}

resource "azurerm_eventhub" "eventhub" {
  for_each = var.event_hubs

  name         = each.key
  namespace_id = azurerm_eventhub_namespace.eventhub_namespace.id

  # capture_description {
  #   enabled = true
  #   encoding = "Avro" # "AvroDeflate"
  #   interval_in_seconds = 300
  #   size_limit_in_bytes = 314572800
  #   skip_empty_archives = true
  #   destination {
  #     name = "EventHubArchive.AzureBlockBlob"
  #     archive_name_format = "{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}"
  #     blob_container_name = ""
  #     storage_account_id = ""
  #   }
  # }
  message_retention = each.value.message_retention
  partition_count   = each.value.partition_count
  status            = "Active"
}
