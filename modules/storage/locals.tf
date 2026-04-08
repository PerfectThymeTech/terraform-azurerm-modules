locals {
  private_dns_zones_map = {
    blob  = var.private_dns_zone_id_blob
    file  = var.private_dns_zone_id_file
    table = var.private_dns_zone_id_table
    queue = var.private_dns_zone_id_queue
    web   = var.private_dns_zone_id_web
    dfs   = var.private_dns_zone_id_dfs
  }

  resource_id_blob  = "${azurerm_storage_account.storage_account.id}/blobServices/default"
  resource_id_file  = "${azurerm_storage_account.storage_account.id}/fileServices/default"
  resource_id_table = "${azurerm_storage_account.storage_account.id}/tableServices/default"
  resource_id_queue = "${azurerm_storage_account.storage_account.id}/queueServices/default"
}
