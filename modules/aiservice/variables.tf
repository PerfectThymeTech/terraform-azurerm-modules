# General variables
variable "location" {
  description = "Specifies the location of all resources."
  type        = string
  sensitive   = false
}

variable "resource_group_name" {
  description = "Specifies the resource group name in which all resources will get deployed."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.resource_group_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "tags" {
  description = "Specifies a key value map of tags to set on every taggable resources."
  type        = map(string)
  sensitive   = false
  default     = {}
}

# Service variables
variable "cognitive_account_name" {
  description = "Specifies the name of the cognitive service."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.cognitive_account_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "cognitive_account_kind" {
  description = "Specifies the kind of the cognitive service."
  type        = string
  sensitive   = false
  validation {
    condition     = contains(["AnomalyDetector", "ComputerVision", "CognitiveServices", "ContentModerator", "CustomVision.Training", "CustomVision.Prediction", "Face", "FormRecognizer", "ImmersiveReader", "LUIS", "Personalizer", "SpeechServices", "TextAnalytics", "TextTranslation", "OpenAI"], var.cognitive_account_kind)
    error_message = "Please specify a valid kind."
  }
}

variable "cognitive_account_sku" {
  description = "Specifies the sku of the cognitive service."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.cognitive_account_sku) >= 1
    error_message = "Please specify a valid sku name."
  }
}

variable "cognitive_account_outbound_network_access_restricted" {
  description = "Specifies the outbound network restrictions of the cognitive service."
  type        = bool
  sensitive   = false
  nullable    = false
  default     = true
}

variable "cognitive_account_deployments" {
  description = "Specifies the models that should be deployed within your ai service. Only applicable to ai services of kind openai."
  type = map(object({
    model_name        = string
    model_version     = string
    model_api_version = optional(string, "2024-02-15-preview")
    scale_type        = optional(string, "Standard")
    scale_tier        = optional(string, "Standard")
    scale_size        = optional(string, null)
    scale_family      = optional(string, null)
    scale_capacity    = optional(number, 1)
  }))
  sensitive = false
  default   = {}
  # validation {
  #   condition = alltrue([
  #     length([for model_name in values(var.cognitive_account_deployments)[*].model_name : model_name if !contains(["value1", "value2"], model_name)]) <= 0
  #   ])
  #   error_message = "Please specify a valid model configuration."
  # }
}

# Monitoring variables
variable "diagnostics_configurations" {
  description = "Specifies the diagnostic configuration for the service."
  type = list(object({
    log_analytics_workspace_id = optional(string, ""),
    storage_account_id         = optional(string, "")
  }))
  sensitive = false
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
    condition     = length(var.subnet_id) == 11
    error_message = "Please specify a valid resource group name."
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

variable "private_dns_zone_id_cognitive_account" {
  description = "Specifies the resource ID of the private DNS zone for Azure Cognitive Services. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_cognitive_account == "" || (length(split("/", var.private_dns_zone_id_cognitive_account)) == 9 && (endswith(var.private_dns_zone_id_cognitive_account, "privatelink.cognitiveservices.azure.com") || endswith(var.private_dns_zone_id_cognitive_account, "privatelink.openai.azure.com")))
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
