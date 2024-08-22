output "service_plan_id" {
  description = "Specifies the resource ID of the app service plan."
  value       = azurerm_service_plan.service_plan.id
  sensitive   = false
}
