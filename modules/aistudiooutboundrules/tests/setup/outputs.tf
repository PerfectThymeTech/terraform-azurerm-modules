output "ai_studio_hub_id" {
  description = "Specifies the resource id of ai studio hub."
  value       = module.ai_studio_hub.ai_studio_hub_id
  sensitive   = false
}

output "ai_studio_hub_storage_account_id" {
  description = "Specifies the resource id of ai studio hub storage account."
  value       = module.storage_account.storage_account_id
  sensitive   = false
}
