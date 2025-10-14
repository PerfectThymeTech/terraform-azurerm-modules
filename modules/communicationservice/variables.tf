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
    error_message = "Please specify a valid resource group name."
  }
}

variable "tags" {
  description = "Specifies a key value map of tags to set on every taggable resources."
  type        = map(string)
  sensitive   = false
  default     = {}
}

# Key Vault variables
variable "communication_service_name" {
  description = "Specifies the name of the Communication Service. Changing this forces a new resource to be created."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.key_vault_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "communication_service_data_location" {
  description = "Specifies the name of the SKU used for this Key Vault."
  type        = string
  sensitive   = false
  default     = "United States"
  validation {
    condition     = contains(["Africa", "Asia Pacific", "Australia", "Brazil", "Canada", "Europe", "France", "Germany", "India", "Japan", "Korea", "Norway", "Switzerland", "UAE", "UK", "usgov", "United States"], var.key_vault_sku_name)
    error_message = "Please specify a valid commmunication service data location."
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
  default   = []
  validation {
    condition = alltrue([
      length([for diagnostics_configuration in toset(var.diagnostics_configurations) : diagnostics_configuration if diagnostics_configuration.log_analytics_workspace_id == "" && diagnostics_configuration.storage_account_id == ""]) <= 0
    ])
    error_message = "Please specify a valid resource ID."
  }
}

# Network variables
