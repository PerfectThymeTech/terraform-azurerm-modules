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
  nullable    = false
  default     = {}
}

# App service plan variables
variable "service_plan_name" {
  description = "Specifies the name of the app service plan."
  type        = string
  sensitive   = false
  nullable    = false
}

variable "service_plan_maximum_elastic_worker_count" {
  description = "Specifies the maximum elastic worker count of the app service plan. Can only be set for an elastic SKU."
  type        = string
  sensitive   = false
  nullable    = true
  default     = null
}

variable "service_plan_os_type" {
  description = "Specifies the os type of the app service plan."
  type        = string
  sensitive   = false
  nullable    = false
  default     = "Linux"
  validation {
    condition     = contains(["Linux", "Windows", "WindowsContainer"], var.service_plan_os_type)
    error_message = "Please specify a valid os type which must be one of 'Linux', 'Windows' or 'WindowsContainer'."
  }
}

variable "application_insights_application_type" {
  description = "Specifies the application type of the application insights service."
  type        = string
  sensitive   = false
  nullable    = false
  default     = "web"
}

variable "application_insights_log_analytics_workspace_id" {
  description = "Specifies the log analytics workspace of the application insights service."
  type        = string
  sensitive   = false
  nullable    = false
  validation {
    condition     = length(split("/", var.application_insights_log_analytics_workspace_id)) == 9
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
  default   = []
  validation {
    condition = alltrue([
      length([for diagnostics_configuration in toset(var.diagnostics_configurations) : diagnostics_configuration if diagnostics_configuration.log_analytics_workspace_id == "" && diagnostics_configuration.storage_account_id == ""]) <= 0
    ])
    error_message = "Please specify a valid resource ID."
  }
}

# Network variables
