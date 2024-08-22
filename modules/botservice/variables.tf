# General variables
variable "location" {
  description = "Specifies the location of all resources."
  type        = string
  sensitive   = false
  nullable    = false
}

variable "resource_group_name" {
  description = "Specifies the resource group name in which all resources will get deployed."
  type        = string
  sensitive   = false
  nullable    = false
  validation {
    condition     = length(var.resource_group_name) >= 2
    error_message = "Please specify a valid resource group name."
  }
}

variable "tags" {
  description = "Specifies a key value map of tags to set on every taggable resources."
  type        = map(string)
  sensitive   = false
  default     = {}
  nullable    = false
}

# Bot service variables
variable "bot_service_name" {
  description = "Specifies the name of the bot service."
  type        = string
  sensitive   = false
  nullable    = false
  validation {
    condition     = length(var.bot_service_name) >= 2 && length(var.bot_service_name) <= 64
    error_message = "Please specify a valid name."
  }
}

variable "bot_service_location" {
  description = "Specifies the location of the bot service."
  type        = string
  sensitive   = false
  nullable    = false
  default     = "global"
  validation {
    condition     = contains(["global", "westeurope", "westus", "centralindia"], var.bot_service_location)
    error_message = "Please specify a valid region which must be one of 'global', 'westeurope', 'westus' or 'centralindia'."
  }
}

variable "bot_service_endpoint" {
  description = "Specifies the endpoint of the bot service."
  type        = string
  sensitive   = false
  nullable    = false
  validation {
    condition     = length(var.bot_service_endpoint) >= 2 && startswith(var.bot_service_endpoint, "https://")
    error_message = "Please specify a valid endpoint name that starts with 'https://'."
  }
}

variable "bot_service_luis" {
  description = "Specifies the luis app details of the bot service."
  type = object({
    app_ids = optional(list(string), []),
    key     = optional(string, null)
  })
  sensitive = false
  nullable  = false
  default = {
    app_ids = []
    key     = null
  }
}

variable "bot_service_microsoft_app" {
  description = "Specifies the microsoft app details of the bot service."
  type = object({
    app_id        = string
    app_msi_id    = string
    app_tenant_id = string
    app_type      = string
  })
  sensitive = false
  nullable  = false
  validation {
    condition     = contains(["MultiTenant", "SingleTenant", "UserAssignedMSI"], var.bot_service_microsoft_app.app_type)
    error_message = "Please specify a valid app type which must be one of 'MultiTenant', 'SingleTenant' or 'UserAssignedMSI'."
  }
}

variable "bot_service_sku" {
  description = "Specifies the sku of the bot service."
  type        = string
  sensitive   = false
  nullable    = false
  default     = "S1"
  validation {
    condition     = contains(["F0", "S1"], var.bot_service_sku)
    error_message = "Please specify a valid bot service sku which must be one of 'F0' or 'S1'."
  }
}

variable "bot_service_icon_url" {
  description = "Specifies the icon url of the bot service."
  type        = string
  sensitive   = false
  nullable    = false
  default     = "https://docs.botframework.com/static/devportal/client/images/bot-framework-default.png"
  validation {
    condition     = startswith(var.bot_service_icon_url, "https://")
    error_message = "Please specify a valid bot service icon url which starts with 'https://'."
  }
}

variable "bot_service_streaming_endpoint_enabled" {
  description = "Specifies whether the streaming endpoint should be enabled for the bot service."
  type        = bool
  sensitive   = false
  nullable    = false
  default     = false
}

variable "bot_service_public_network_access_enabled" {
  description = "Specifies whether public network access should be enabled for the bot service."
  type        = bool
  sensitive   = false
  nullable    = false
  default     = false
}

variable "bot_service_application_insights_id" {
  description = "Specifies the application insights id to be used for the bot service."
  type        = string
  sensitive   = false
  nullable    = false
  validation {
    condition     = length(split("/", var.bot_service_application_insights_id)) == 9
    error_message = "Please specify a valid resource id."
  }
}

# Diagnostics variables
variable "diagnostics_configurations" {
  description = "Specifies the diagnostic configuration for the service."
  type = list(object({
    log_analytics_workspace_id = optional(string, ""),
    storage_account_id         = optional(string, "")
  }))
  sensitive = false
  nullable  = false
  default   = []
  validation {
    condition = alltrue([
      length([for diagnostics_configuration in toset(var.diagnostics_configurations) : diagnostics_configuration if diagnostics_configuration.log_analytics_workspace_id == "" && diagnostics_configuration.storage_account_id == ""]) <= 0
    ])
    error_message = "Please specify a valid resource ID."
  }
}

# Network variables
variable "subnet_id" {
  description = "Specifies the resource id of a subnet in which the private endpoints get created."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.subnet_id)) == 11
    error_message = "Please specify a valid subnet id."
  }
}

variable "connectivity_delay_in_seconds" {
  description = "Specifies the delay in seconds after the private endpoint deployment (required for the DNS automation via Policies)."
  type        = number
  sensitive   = false
  nullable    = false
  default     = 120
  validation {
    condition     = var.connectivity_delay_in_seconds >= 0
    error_message = "Please specify a valid non-negative number."
  }
}

variable "private_dns_zone_id_bot_framework_directline" {
  description = "Specifies the resource ID of the private DNS zone for the bot framework directline. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_bot_framework_directline == "" || (length(split("/", var.private_dns_zone_id_bot_framework_directline)) == 9 && endswith(var.private_dns_zone_id_bot_framework_directline, "privatelink.directline.botframework.com"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_bot_framework_token" {
  description = "Specifies the resource ID of the private DNS zone for the bot framework token. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_bot_framework_token == "" || (length(split("/", var.private_dns_zone_id_bot_framework_token)) == 9 && endswith(var.private_dns_zone_id_bot_framework_token, "privatelink.token.botframework.com"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

# Customer-managed key variables
variable "customer_managed_key" {
  description = "Specifies the customer managed key configurations."
  type = object({
    key_vault_id                     = string,
    key_vault_key_versionless_id     = string,
    user_assigned_identity_id        = string,
    user_assigned_identity_client_id = string,
  })
  sensitive = false
  nullable  = true
  default   = null
  validation {
    condition = alltrue([
      var.customer_managed_key == null || length(split("/", try(var.customer_managed_key.key_vault_id, ""))) == 9,
      var.customer_managed_key == null || startswith(try(var.customer_managed_key.key_vault_key_versionless_id, ""), "https://"),
      var.customer_managed_key == null || length(split("/", try(var.customer_managed_key.user_assigned_identity_id, ""))) == 9,
      var.customer_managed_key == null || length(try(var.customer_managed_key.user_assigned_identity_client_id, "")) >= 2,
    ])
    error_message = "Please specify a valid resource ID."
  }
}
