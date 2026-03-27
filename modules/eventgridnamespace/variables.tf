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

# Event Grid Namespace variables
variable "eventgrid_namespace_name" {
  description = "Specifies the name of the Event Grid Namespace. Changing this forces a new resource to be created."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.eventgrid_namespace_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "eventgrid_namespace_sku" {
  description = "Specifies the name of the SKU used for the event grid namespace. Possible values are standard."
  type        = string
  sensitive   = false
  default     = "Standard"
  validation {
    condition     = contains(["Standard"], var.eventgrid_namespace_sku)
    error_message = "Please specify a valid sku name."
  }
}

variable "eventgrid_namespace_capacity" {
  description = "Specifies the capacity of the Event Grid Namespace. This value can be between 1 and 40."
  type        = number
  sensitive   = false
  default     = 1
  validation {
    condition     = var.eventgrid_namespace_capacity >= 1 && var.eventgrid_namespace_capacity <= 40
    error_message = "Please specify a valid capacity."
  }
}

variable "eventgrid_topics" {
  description = "Specifies the map of Event Grid Topics to be created within the namespace."
  type = map(object({
    event_retention_in_days = optional(int, 1)
    input_schema            = optional(string, "CloudEventSchemaV1_0")
    publisher_type          = optional(string, "Custom")
  }))
  sensitive = false
  default   = {}
  validation {
    # Ensure that each topic has valid retention in days
    condition = alltrue([
      for topic in values(var.eventgrid_topics) : (
        topic.event_retention_in_days >= 1 && topic.event_retention_in_days <= 7
      )
    ])
    error_message = "Please specify valid retention in days between 1 and 7 for each Event Grid Topic."
  }
  validation {
    # Ensure that each topic has valid input schema
    condition = alltrue([
      for topic in values(var.eventgrid_topics) : (
        contains(["CloudEventSchemaV1_0"], topic.input_schema)
      )
    ])
    error_message = "Please specify a valid input schema for each Event Grid Topic."
  }
  validation {
    # Ensure that each topic has valid publisher type
    condition = alltrue([
      for topic in values(var.eventgrid_topics) : (
        contains(["Custom"], topic.publisher_type)
      )
    ])
    error_message = "Please specify a valid publisher type for each Event Grid Topic."
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

variable "private_dns_zone_id_topic" {
  description = "Specifies the resource ID of the private DNS zone for Azure Event Grid Namespace Topic. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  nullable    = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_topic == "" || (length(split("/", var.private_dns_zone_id_topic)) == 9 && endswith(var.private_dns_zone_id_topic, "privatelink.eventgrid.azure.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}
