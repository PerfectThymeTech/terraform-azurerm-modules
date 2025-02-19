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
variable "postgresql_name" {
  description = "Specifies the name of the postgresql flexible server."
  type        = string
  sensitive   = false
  nullable    = false
  validation {
    condition     = length(var.postgresql_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "postgresql_auto_grow_enabled" {
  description = "Specifies whether auto grow is enabled for the postgresql flexible server."
  type        = bool
  sensitive   = false
  nullable    = false
  default     = false
}

variable "postgresql_backup_retention_days" {
  description = "Specifies the backup retention in days of the postgresql flexible server."
  type        = number
  sensitive   = false
  nullable    = false
  default     = 30
  validation {
    condition     = var.postgresql_backup_retention_days >= 7 && var.postgresql_backup_retention_days <= 35
    error_message = "Please specify a valid value for backup retention in days between 7 and 35 days."
  }
}

variable "postgresql_geo_redundant_backup_enabled" {
  description = "Specifies whether the geo redundant backup should be enabled for the postgresql storage account."
  type        = bool
  sensitive   = false
  nullable    = false
  default     = false
}

variable "postgresql_zone_redundancy_enabled" {
  description = "Specifies whether zone redundancy should be enabled for the postgresql flexible server."
  type        = bool
  sensitive   = false
  nullable    = false
  default     = false
}

variable "postgresql_high_availability_mode" {
  description = "Specifies whether zone redundancy should be enabled for the postgresql flexible server."
  type        = string
  sensitive   = false
  nullable    = false
  default     = "ZoneRedundant"
  validation {
    condition     = contains(["ZoneRedundant", "SameZone"], var.postgresql_high_availability_mode)
    error_message = "Please specify a valid zone redundancy mode."
  }
}

variable "postgresql_maintenance_window" {
  description = "Specifies the maintenance window for the postgresql flexible server."
  type = object({
    day_of_week  = optional(number, 6)
    start_hour   = optional(number, 0)
    start_minute = optional(number, 0)
  })
  sensitive = false
  nullable  = false
  default   = {}
  validation {
    condition     = var.postgresql_maintenance_window.day_of_week >= 0 && var.postgresql_maintenance_window.day_of_week <= 6
    error_message = "Please specify a valid maintenance window."
  }
  validation {
    condition     = var.postgresql_maintenance_window.start_hour >= 0 && var.postgresql_maintenance_window.start_hour <= 23
    error_message = "Please specify a valid maintenance window."
  }
  validation {
    condition     = var.postgresql_maintenance_window.start_minute >= 0 && var.postgresql_maintenance_window.start_minute <= 59
    error_message = "Please specify a valid maintenance window."
  }
}

variable "postgresql_sku_name" {
  description = "Specifies the sku of the postgresql flexible server."
  type        = string
  sensitive   = false
  nullable    = false
  default     = "B_Standard_B1ms"
  # validation {
  #   condition     = contains(["All", "AAD", "PrivateLink"], var.storage_account_allowed_copy_scope)
  #   error_message = "Please specify a valid allowed copy scope. Allowed values are: [ 'All', 'AAD', 'PrivateLink' ]"
  # }
}

variable "postgresql_storage_mb" {
  description = "Specifies the storage mb of the postgresql flexible server."
  type        = number
  sensitive   = false
  nullable    = false
  default     = 32768
  validation {
    condition     = contains([32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4193280, 4194304, 8388608, 16777216, 33553408], var.postgresql_storage_mb)
    error_message = "Please specify a valid allowed storage mb size. Please check the supported values."
  }
}

variable "postgresql_storage_tier" {
  description = "Specifies the storage tier of the postgresql flexible server."
  type        = string
  sensitive   = false
  nullable    = true
  default     = null
  validation {
    condition     = var.postgresql_storage_tier == null || contains(["P4", "P6", "P10", "P15", "P20", "P30", "P40", "P50", "P60", "P70", "P80"], var.postgresql_storage_mb)
    error_message = "Please specify a valid storage tier that can be used in combination with the provided storage mb size."
  }
}

variable "postgresql_version" {
  description = "Specifies the version of the postgresql flexible server."
  type        = number
  sensitive   = false
  nullable    = false
  default     = 16
  validation {
    condition     = contains([11, 12, 13, 14, 15, 16], var.postgresql_version)
    error_message = "Please specify a valid version."
  }
}

variable "postgresql_active_directory_administrator" {
  description = "Specifies the entra id admin configuration for the postgresql flexible server. Please provide a group name and the object id of teh group."
  type = object({
    object_id  = optional(string, "")
    group_name = optional(string, "")
  })
  sensitive = false
  nullable  = false
  default   = {}
  validation {
    condition     = (var.postgresql_active_directory_administrator.object_id == "" && var.postgresql_active_directory_administrator.group_name == "") || (length(var.postgresql_active_directory_administrator.object_id) > 2 && length(var.postgresql_active_directory_administrator.group_name) > 2)
    error_message = "Please specify a valid entra id administrator config and provide both values or none."
  }
}

variable "postgresql_configuration" {
  description = "Specifies the configuration of the postgresql flexible server."
  type        = map(string)
  sensitive   = false
  nullable    = false
  default     = {}
}

variable "postgresql_databases" {
  description = "Specifies the databases of the postgresql flexible server."
  type = map(object({
    charset   = optional(string, "UTF8")
    collation = optional(string, "en_US.utf8")
  }))
  sensitive = false
  nullable  = false
  default   = {}
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

variable "private_dns_zone_id_postrgesql" {
  description = "Specifies the resource ID of the private DNS zone for Azure Postgresql flexible server. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_postrgesql == "" || (length(split("/", var.private_dns_zone_id_postrgesql)) == 9 && endswith(var.private_dns_zone_id_postrgesql, "privatelink.postgres.database.azure.com"))
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
