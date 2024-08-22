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

variable "service_plan_per_site_scaling_enabled" {
  description = "Specifies whether per site scaling should be enabled for the app service plan."
  type        = bool
  sensitive   = false
  nullable    = false
  default     = false
}

variable "service_plan_sku_name" {
  description = "Specifies the sku name of the app service plan."
  type        = string
  sensitive   = false
  nullable    = false
  default     = "P0v3"
  validation {
    condition     = contains(["B1", "B2", "B3", "D1", "F1", "I1", "I2", "I3", "I1v2", "I2v2", "I3v2", "I4v2", "I5v2", "I6v2", "P1v2", "P2v2", "P3v2", "P0v3", "P1v3", "P2v3", "P3v3", "P1mv3", "P2mv3", "P3mv3", "P4mv3", "P5mv3", "S1", "S2", "S3", "SHARED", "EP1", "EP2", "EP3", "FC1", "WS1", "WS2", "WS3", "Y1"], var.service_plan_sku_name)
    error_message = "Please specify a valid sku name."
  }
}

variable "service_plan_worker_count" {
  description = "Specifies the worker count of the app service plan."
  type        = number
  sensitive   = false
  nullable    = false
  default     = 1
  validation {
    condition     = var.service_plan_worker_count > 0
    error_message = "Please specify a valid worker count larger than 0."
  }
}

variable "service_plan_zone_balancing_enabled" {
  description = "Specifies whether zone balancing should be enabled for the app service plan. Can only be enabled if woker count is >= 3."
  type        = bool
  sensitive   = false
  nullable    = false
  default     = false
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
