resource "azapi_resource" "ai_studio_project_connection" {
  for_each = var.ai_studio_project_connections

  type      = "Microsoft.MachineLearningServices/workspaces/connections@2024-04-01-preview"
  name      = each.key
  parent_id = azapi_resource.ai_studio_project.id

  body = jsonencode({
    properties = {
      authType       = each.value.auth_type
      category       = each.value.category
      credentials    = each.value.credentials
      isSharedToAll  = false
      sharedUserList = []
      target         = each.value.target
      metadata       = each.value.metadata
    }

  })

  response_export_values    = ["*"]
  schema_validation_enabled = true
  locks                     = []
  ignore_casing             = false
  ignore_missing_property   = false
}
