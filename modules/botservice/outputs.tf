output "bot_service_id" {
  description = "Specifies the resource id of the bot service."
  value       = azurerm_bot_service_azure_bot.bot_service_azure_bot.id
  sensitive   = false
}

output "bot_service_setup_completed" {
  description = "Specifies whether the connectivity and identity has been successfully configured."
  value       = true
  sensitive   = false

  depends_on = [
    time_sleep.sleep_connectivity,
  ]
}
