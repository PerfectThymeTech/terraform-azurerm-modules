locals {
  # Project workspace guids
  project_internal_ids = {
    for key, value in var.ai_services_projects :
    key => azapi_resource.ai_services_project[key].output.properties.internalId
  }
  project_workspace_ids = {
    for key, value in var.ai_services_projects :
    key => "${substr(local.project_internal_ids[key], 0, 8)}-${substr(local.project_internal_ids[key], 8, 4)}-${substr(local.project_internal_ids[key], 12, 4)}-${substr(local.project_internal_ids[key], 16, 4)}-${substr(local.project_internal_ids[key], 20, 12)}"
  }
}
