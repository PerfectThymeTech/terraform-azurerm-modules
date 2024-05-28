run "create_aistudioproject" {
  command = apply

  variables {
    location            = "northeurope"
    resource_group_name = "tfmdltst-dev-rg"
    tags = {
      test = "aistudioproject"
    }
    ai_studio_project_name     = "mytftst-001"
    ai_studio_hub_id           = ""
    diagnostics_configurations = []
  }

  assert {
    condition     = azapi_resource.ai_studio_project.name == "mytftst-001"
    error_message = "Failed to deploy."
  }
}
