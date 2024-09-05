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

# Key Vault variables
variable "cosmosdb_account_name" {
  description = "Specifies the name of the Cosmos DB Account. Changing this forces a new resource to be created."
  type        = string
  sensitive   = false
  nullable    = false
  validation {
    condition     = length(var.cosmosdb_account_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "cosmosdb_account_analytical_storage_enabled" {
  description = "Specifies whether the analytical storage should be enabled for the cosmos db account."
  type        = bool
  sensitive   = false
  nullable    = false
  default     = false
}

variable "cosmosdb_account_automatic_failover_enabled" {
  description = "Specifies whether the automatic failover should be enabled for the cosmos db account."
  type        = bool
  sensitive   = false
  nullable    = false
  default     = false
}

variable "cosmosdb_account_backup" {
  description = "Specifies the cosmos db backup configuration."
  type = object({
    type                = optional(string, "Continuous"),
    tier                = optional(string, "Continuous7Days")
    storage_redundancy  = optional(string, null)
    retention_in_hours  = optional(number, null)
    interval_in_minutes = optional(number, null)
  })
  sensitive = false
  nullable  = true
  default = {
    type                = "Continuous"
    tier                = "Continuous7Days"
    storage_redundancy  = null
    retention_in_hours  = null
    interval_in_minutes = null
  }
  validation {
    condition     = contains(["Continuous", "Periodic"], var.cosmosdb_account_backup.type)
    error_message = "Please specify a valid backup type."
  }
  validation {
    condition     = var.cosmosdb_account_backup.type == "Continuous" ? contains(["Continuous7Days", "Continuous30Days"], var.cosmosdb_account_backup.tier) : var.cosmosdb_account_backup.tier == null
    error_message = "Please specify a valid backup tier."
  }
  validation {
    condition     = var.cosmosdb_account_backup.type == "Periodic" ? contains(["Geo", "Zone", "Local"], var.cosmosdb_account_backup.storage_redundancy) : var.cosmosdb_account_backup.storage_redundancy == null
    error_message = "Please specify a valid backup storage redundancy."
  }
  validation {
    condition     = var.cosmosdb_account_backup.type == "Periodic" ? var.cosmosdb_account_backup.retention_in_hours >= 8 && var.cosmosdb_account_backup.retention_in_hours <= 720 : var.cosmosdb_account_backup.retention_in_hours == null
    error_message = "Please specify a valid backup retention in hours."
  }
  validation {
    condition     = var.cosmosdb_account_backup.type == "Periodic" ? var.cosmosdb_account_backup.interval_in_minutes >= 60 && var.cosmosdb_account_backup.interval_in_minutes <= 1440 : var.cosmosdb_account_backup.interval_in_minutes == null
    error_message = "Please specify a valid backup interval in minutes."
  }
}

variable "cosmosdb_account_capabilities" {
  description = "Specifies the cpabilities to be enabled on the cosmos db account."
  type        = list(string)
  sensitive   = false
  nullable    = false
  default     = []
}

variable "cosmosdb_account_capacity_total_throughput_limit" {
  description = "Specifies the total throughput limit for the cosmos db account."
  type        = number
  sensitive   = false
  nullable    = false
  default     = -1
  validation {
    condition     = var.cosmosdb_account_capacity_total_throughput_limit >= -1
    error_message = "Please specify a valid total throughput limit."
  }
}

variable "cosmosdb_account_consistency_policy" {
  description = "Specifies the cosmos db consistency policy."
  type = object({
    consistency_level       = optional(string, "Strong"),
    max_interval_in_seconds = optional(number, null)
    max_staleness_prefix    = optional(number, null)
  })
  sensitive = false
  nullable  = true
  default = {
    consistency_level       = "Strong"
    max_interval_in_seconds = null
    max_staleness_prefix    = null
  }
  validation {
    condition     = contains(["BoundedStaleness", "Eventual", "Session", "Strong", "ConsistentPrefix"], var.cosmosdb_account_consistency_policy.consistency_level)
    error_message = "Please specify a valid consistency level."
  }
  validation {
    condition     = var.cosmosdb_account_consistency_policy.consistency_level == "BoundedStaleness" ? var.cosmosdb_account_consistency_policy.max_interval_in_seconds >= 5 && var.cosmosdb_account_consistency_policy.max_interval_in_seconds <= 86400 : var.cosmosdb_account_consistency_policy.max_interval_in_seconds == null
    error_message = "Please specify a valid backup tier."
  }
  validation {
    condition     = var.cosmosdb_account_consistency_policy.consistency_level == "BoundedStaleness" ? var.cosmosdb_account_consistency_policy.max_staleness_prefix >= 10 && var.cosmosdb_account_consistency_policy.max_staleness_prefix <= 2147483647 : var.cosmosdb_account_consistency_policy.max_staleness_prefix == null
    error_message = "Please specify a valid backup storage redundancy."
  }
}

variable "cosmosdb_account_cors_rules" {
  description = "Specifies cosmos db account cors rules."
  type = map(object({
    allowed_headers    = list(string)
    allowed_methods    = list(string)
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = optional(number, 1800)
  }))
  sensitive = false
  nullable  = false
  default   = {}
}

variable "cosmosdb_account_default_identity_type" {
  description = "Specifies the default identity type for key vault access for customer-managed key."
  type        = string
  sensitive   = false
  nullable    = false
  default     = ""
  validation {
    condition     = var.cosmosdb_account_default_identity_type == "" || contains(["FirstPartyIdentity", "SystemAssignedIdentity"], var.cosmosdb_account_default_identity_type) || startswith(var.cosmosdb_account_default_identity_type, "UserAssignedIdentity=")
    error_message = "Please specify a valid default identity type for the key vault access for customer-managed keys."
  }
}

variable "cosmosdb_account_geo_location" {
  description = "Specifies the geo locations for the cosmos db account."
  type = list(object({
    location          = string
    failover_priority = number
    zone_redundant    = optional(bool, false)
  }))
  sensitive = false
  nullable  = false
}

variable "cosmosdb_account_kind" {
  description = "Specifies the kind of the cosmos db account."
  type        = string
  sensitive   = false
  nullable    = false
  default     = "GlobalDocumentDB"
  validation {
    condition     = contains(["GlobalDocumentDB", "MongoDB", "Parse"], var.cosmosdb_account_kind)
    error_message = "Please specify a valid kind for the account."
  }
}

variable "cosmosdb_account_local_authentication_disabled" {
  description = "Specifies whether local authentication should be enabled for the cosmos db account."
  type        = bool
  sensitive   = false
  nullable    = false
  default     = true
}

variable "cosmosdb_account_mongo_server_version" {
  description = "Specifies the mongo server version of the cosmos db account."
  type        = string
  sensitive   = false
  nullable    = true
  default     = null
  validation {
    condition     = var.cosmosdb_account_kind == "MongoDB" ? contains(["3.2", "3.6", "4.0", "4.2"], var.cosmosdb_account_mongo_server_version) : var.cosmosdb_account_mongo_server_version == null
    error_message = "Please specify a valid mongo server version."
  }
}

variable "cosmosdb_account_partition_merge_enabled" {
  description = "Specifies whether partition merge should be enabled for the cosmos db account."
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
  nullable  = false
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

variable "private_endpoint_subresource_names" {
  description = "Specifies a list of group ids for which private endpoints will be created (e.g. 'Sql', 'MongoDB', etc.). If sub resource is defined a private endpoint will be created."
  type        = set(string)
  sensitive   = false
  nullable    = false
  default     = ["blob"]
  validation {
    condition = alltrue([
      length([for private_endpoint_subresource_name in var.private_endpoint_subresource_names : private_endpoint_subresource_name if !contains(["Sql", "MongoDB", "Cassandra", "Gremlin", "Table", "Analytical", "coordinator"], private_endpoint_subresource_name)]) <= 0
    ])
    error_message = "Please specify a valid group id."
  }
}

variable "private_dns_zone_id_cosmos_sql" {
  description = "Specifies the resource ID of the private DNS zone for cosmos db sql. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_cosmos_sql == "" || (length(split("/", var.private_dns_zone_id_cosmos_sql)) == 9 && endswith(var.private_dns_zone_id_cosmos_sql, "privatelink.documents.azure.com"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_cosmos_mongodb" {
  description = "Specifies the resource ID of the private DNS zone for cosmos db mongo db. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_cosmos_mongodb == "" || (length(split("/", var.private_dns_zone_id_cosmos_mongodb)) == 9 && endswith(var.private_dns_zone_id_cosmos_mongodb, "privatelink.mongo.cosmos.azure.com"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_cosmos_cassandra" {
  description = "Specifies the resource ID of the private DNS zone for cosmos db cassandry. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_cosmos_cassandra == "" || (length(split("/", var.private_dns_zone_id_cosmos_cassandra)) == 9 && endswith(var.private_dns_zone_id_cosmos_cassandra, "privatelink.cassandra.cosmos.azure.com"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_cosmos_gremlin" {
  description = "Specifies the resource ID of the private DNS zone for cosmos db gramlin. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_cosmos_gremlin == "" || (length(split("/", var.private_dns_zone_id_cosmos_gremlin)) == 9 && endswith(var.private_dns_zone_id_cosmos_gremlin, "privatelink.gremlin.cosmos.azure.com"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_cosmos_table" {
  description = "Specifies the resource ID of the private DNS zone for cosmos db table. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_cosmos_table == "" || (length(split("/", var.private_dns_zone_id_cosmos_table)) == 9 && endswith(var.private_dns_zone_id_cosmos_table, "privatelink.table.cosmos.azure.com"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_cosmos_analytical" {
  description = "Specifies the resource ID of the private DNS zone for cosmos db analytical storage. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_cosmos_analytical == "" || (length(split("/", var.private_dns_zone_id_cosmos_analytical)) == 9 && endswith(var.private_dns_zone_id_cosmos_analytical, "privatelink.analytics.cosmos.azure.com"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_cosmos_coordinator" {
  description = "Specifies the resource ID of the private DNS zone for cosmos db coordinator. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_cosmos_coordinator == "" || (length(split("/", var.private_dns_zone_id_cosmos_coordinator)) == 9 && endswith(var.private_dns_zone_id_cosmos_coordinator, "privatelink.postgres.cosmos.azure.com"))
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
