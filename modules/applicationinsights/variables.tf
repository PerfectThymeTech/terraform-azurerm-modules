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

# Application insights variables
variable "application_insights_name" {
  description = "Specifies the name of the application insights service."
  type        = string
  sensitive   = false
  nullable    = false
}

variable "application_insights_application_type" {
  description = "Specifies the application type of the application insights service."
  type        = string
  sensitive   = false
  nullable    = false
  default     = "web"
}

variable "application_insights_internet_ingestion_enabled" {
  description = "Specifies whether internet ingestion is enabled for the application insights service."
  type        = bool
  sensitive   = false
  nullable    = false
  default     = true
}

variable "application_insights_internet_query_enabled" {
  description = "Specifies whether internet query is enabled for the application insights service."
  type        = bool
  sensitive   = false
  nullable    = false
  default     = true
}

variable "application_insights_local_authentication_disabled" {
  description = "Specifies whether local authentication is disabled for the application insights service."
  type        = bool
  sensitive   = false
  nullable    = false
  default     = false
}

variable "application_insights_retention_in_days" {
  description = "Specifies the retention in days for the application insights service."
  type        = number
  sensitive   = false
  nullable    = false
  default     = 90
  validation {
    condition     = var.application_insights_retention_in_days >= 30 && var.application_insights_retention_in_days <= 730
    error_message = "Please specify a valid retention in days between 30 and 730 days."
  }
}

variable "application_insights_sampling_percentage" {
  description = "Specifies the sampling percentage for the application insights service."
  type        = number
  sensitive   = false
  nullable    = false
  default     = 100
  validation {
    condition     = var.application_insights_sampling_percentage >= 0 && var.application_insights_sampling_percentage <= 100
    error_message = "Please specify a valid sampling percentage between 0 and 100."
  }
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
