output "ai_studio_project_id" {
  description = "Specifies the resource ID of the ai studio project."
  value       = azapi_resource.ai_studio_project.id
  sensitive   = false
}

output "ai_studio_project_name" {
  description = "Specifies the name of the ai studio project."
  value       = azapi_resource.ai_studio_project.name
  sensitive   = true
}
