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

# Storage variables
variable "event_hub_namespace_name" {
  description = "Specifies the name of the eventhub namespace."
  type        = string
  sensitive   = false
  nullable    = false
  validation {
    condition     = length(var.event_hub_namespace_name) >= 2 && length(var.event_hub_namespace_name) >= 6
    error_message = "Please specify a valid name."
  }
}

variable "event_hub_namespace_auto_inflate_enabled" {
  description = "Specifies whether auto inflate should be enabled for the eventhub namespace."
  type        = bool
  sensitive   = false
  nullable    = false
  default     = true
}

variable "event_hub_namespace_capacity" {
  description = "Specifies the capacity of the eventhub namespace."
  type        = number
  sensitive   = false
  nullable    = false
  default     = 2
  validation {
    condition     = var.event_hub_namespace_capacity >= 1 && var.event_hub_namespace_capacity <= 40
    error_message = "Please specify a valid capacity."
  }
}

variable "event_hub_namespace_dedicated_cluster_id" {
  description = "Specifies the resource id of the dedicated cluster."
  type        = bool
  sensitive   = false
  nullable    = true
  default     = null
  validation {
    condition     = var.event_hub_namespace_dedicated_cluster_id == null || length(try(split("/", var.event_hub_namespace_dedicated_cluster_id), "")) == 9
    error_message = "Please provide a valid resource id."
  }
}

variable "event_hub_namespace_local_authentication_enabled" {
  description = "Specifies whether local authentication should be enabled for the eventhub namespace."
  type        = bool
  sensitive   = false
  nullable    = false
  default     = false
}

variable "event_hub_namespace_maximum_throughput_units" {
  description = "Specifies the maximum throughput units of the eventhub namespace."
  type        = number
  sensitive   = false
  nullable    = false
  validation {
    condition     = var.event_hub_namespace_maximum_throughput_units >= 1 && var.event_hub_namespace_maximum_throughput_units <= 20
    error_message = "Please provide a valid maximum throughput."
  }
}

variable "event_hub_namespace_sku" {
  description = "Specifies the sku of the eventhub namespace."
  type        = string
  sensitive   = false
  nullable    = false
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.event_hub_namespace_sku)
    error_message = "Please provide a valid sku."
  }
}

variable "event_hubs" {
  description = "Specifies the the eventhub details."
  type = map(object({
    partition_count   = optional(number, 1)
    message_retention = optional(number, 1)
  }))
  sensitive = false
  nullable  = false
  validation {
    condition = alltrue([
      length([for partition_count in values(var.event_hubs)[*].partition_count : partition_count if !(partition_count >= 1 && partition_count <= 1024)]) <= 0,
      length([for message_retention in values(var.event_hubs)[*].message_retention : message_retention if !(message_retention >= 1 && message_retention <= 90)]) <= 0,
    ])
    error_message = "Please specify a valid event hub configuration."
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

variable "private_dns_zone_id_servicebus" {
  description = "Specifies the resource ID of the private DNS zone for Azure service bus endpoints. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_servicebus == "" || (length(split("/", var.private_dns_zone_id_servicebus)) == 9 && endswith(var.private_dns_zone_id_servicebus, "privatelink.servicebus.windows.net"))
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
