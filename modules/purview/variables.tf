# General variables
variable "location" {
  description = "Specifies the location of all resources."
  type        = string
  sensitive   = false
}

variable "location_private_endpoint" {
  description = "Specifies the location of the private endpoint. Use this variables only if the private endpoint(s) should reside in a different location than the service itself."
  type        = string
  sensitive   = false
  nullable    = true
  default     = null
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

# Key Vault variables
variable "purview_account_name" {
  description = "Specifies the name of the Purview account."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.purview_account_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "purview_account_root_collection_admins" {
  description = "Specifies the root collection admins of the Purview account."
  type = map(object({
    object_id = string
  }))
  sensitive = false
  default   = {}
  validation {
    condition = alltrue([
      length([for root_collection_admin in var.purview_account_root_collection_admins : true if length(root_collection_admin.object_id) <= 2]) <= 0
    ])
    error_message = "Please specify a valid object id."
  }
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

# DNS variables
variable "private_dns_zone_id_purview_platform" {
  description = "Specifies the resource ID of the private DNS zone for Azure Key Vault. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  nullable    = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_purview_platform == "" || (length(split("/", var.private_dns_zone_id_purview_platform)) == 9 && endswith(var.private_dns_zone_id_purview_platform, "privatelink.purview-service.microsoft.com"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_blob" {
  description = "Specifies the resource ID of the private DNS zone for Azure Storage blob endpoints. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_blob == "" || (length(split("/", var.private_dns_zone_id_blob)) == 9 && endswith(var.private_dns_zone_id_blob, "privatelink.blob.core.windows.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_queue" {
  description = "Specifies the resource ID of the private DNS zone for Azure Storage queue endpoints. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_queue == "" || (length(split("/", var.private_dns_zone_id_queue)) == 9 && endswith(var.private_dns_zone_id_queue, "privatelink.queue.core.windows.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

# Customer-managed key variables - not supported
