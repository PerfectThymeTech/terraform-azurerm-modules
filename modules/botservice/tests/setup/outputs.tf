output "application_insights_id" {
  description = "Specifies the resource id of application insights."
  value       = module.application_insights.application_insights_id
  sensitive   = false
}
