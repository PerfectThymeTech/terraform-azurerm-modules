resource "azapi_resource_action" "purview_account_root_collection_admin" {
  for_each = var.purview_account_root_collection_admins

  type        = "Microsoft.Purview/accounts@2024-04-01-preview"
  resource_id = azapi_resource.purview_account.id
  action      = "addRootCollectionAdmin"
  method      = "POST"
  when        = "apply"

  body = {
    objectId = each.value.object_id
  }

  response_export_values = []
  locks                  = []
}
