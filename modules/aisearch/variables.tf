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
    error_message = "Please specify a valid name."
  }
}

variable "tags" {
  description = "Specifies a key value map of tags to set on every taggable resources."
  type        = map(string)
  sensitive   = false
  nullable    = false
  default     = {}
}

# Service variables
variable "search_service_name" {
  description = "Specifies the name of the search service."
  type        = string
  sensitive   = false
  nullable    = false
  validation {
    condition     = length(var.search_service_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "search_service_sku" {
  description = "Specifies the SKU for the search service"
  type        = string
  sensitive   = false
  nullable    = false
  default     = "standard"
  validation {
    condition     = contains(["free", "basic", "standard", "standard2", "standard3", "storage_optimized_l1", "storage_optimized_l2"], var.search_service_sku)
    error_message = "Please specify a valid sku."
  }
}

variable "search_service_semantic_search_sku" {
  description = "Specifies the semantic search SKU for the search service"
  type        = string
  sensitive   = false
  nullable    = true
  default     = "standard"
  validation {
    condition     = contains(["free", "standard"], var.search_service_semantic_search_sku)
    error_message = "Please specify a valid semantic search sku."
  }
}

variable "search_service_local_authentication_enabled" {
  description = "Specifies whether local auth should be enabled for the search service"
  type        = bool
  sensitive   = false
  nullable    = false
  default     = false
}

variable "search_service_authentication_failure_mode" {
  description = "Specifies the authentication failure mode for the search service"
  type        = string
  sensitive   = false
  nullable    = true
  default     = null
  validation {
    condition     = var.search_service_authentication_failure_mode == null ? true : contains(["http401WithBearerChallenge", "http403"], var.search_service_authentication_failure_mode)
    error_message = "Please specify a valid authentication failure mode."
  }
}

variable "search_service_hosting_mode" {
  description = "Specifies the hosting mode for the search service"
  type        = string
  sensitive   = false
  nullable    = false
  default     = "default"
  validation {
    condition     = contains(["default", "highDensity"], var.search_service_hosting_mode)
    error_message = "Please specify a valid hosting mode."
  }
}

variable "search_service_partition_count" {
  description = "Specifies the number of partitions in the search service."
  type        = number
  sensitive   = false
  default     = 1
  validation {
    condition     = contains([1, 2, 3, 4, 6, 12], var.search_service_partition_count)
    error_message = "Please specify a valid partition count."
  }
}

variable "search_service_replica_count" {
  description = "Specifies the number of replicas in the search service."
  type        = number
  sensitive   = false
  default     = 1
  validation {
    condition     = var.search_service_replica_count > 0
    error_message = "Please specify a valid replica count."
  }
}

variable "search_service_shared_private_links" {
  description = "Specifies the shared private links that should be connected to the search service."
  type = map(object({
    subresource_name   = string
    target_resource_id = string
    approve            = optional(bool, false)
  }))
  sensitive = false
  default   = {}
  validation {
    condition = alltrue([
      length([for shared_private_link in var.search_service_shared_private_links : true if shared_private_link.subresource_name == ""]) <= 0,
      length([for shared_private_link in var.search_service_shared_private_links : true if length(split("/", shared_private_link.target_resource_id)) < 9]) <= 0,
    ])
    error_message = "Please specify valid shared private link configurations."
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

variable "private_dns_zone_id_search_service" {
  description = "Specifies the resource ID of the private DNS zone for Azure Cognitive Search endpoints. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_search_service == "" || (length(split("/", var.private_dns_zone_id_search_service)) == 9 && endswith(var.private_dns_zone_id_search_service, "privatelink.search.windows.net"))
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
