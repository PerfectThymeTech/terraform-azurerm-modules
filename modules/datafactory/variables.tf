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
    error_message = "Please specify a valid name."
  }
}

variable "tags" {
  description = "Specifies a key value map of tags to set on every taggable resources."
  type        = map(string)
  sensitive   = false
  default     = {}
}

# Service variables
variable "data_factory_name" {
  description = "Specifies the name of the data factory."
  type        = string
  sensitive   = false
  nullable    = false
  validation {
    condition     = length(var.data_factory_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "data_factory_purview_id" {
  description = "Specifies the resource id of purview that should be connnected to the data factory."
  type        = string
  sensitive   = false
  nullable    = true
  default     = null
  validation {
    condition     = var.data_factory_purview_id == null ? true : length(split("/", var.data_factory_purview_id)) == 9
    error_message = "Please specify a valid resource id."
  }
}

variable "data_factory_azure_devops_repo" {
  description = "Specifies the Azure Devops repository configuration."
  type = object(
    {
      account_name    = optional(string, "")
      branch_name     = optional(string, "")
      project_name    = optional(string, "")
      repository_name = optional(string, "")
      root_folder     = optional(string, "")
      tenant_id       = optional(string, "")
    }
  )
  sensitive = false
  nullable  = false
  default   = {}
}

variable "data_factory_github_repo" {
  description = "Specifies the Github repository configuration."
  type = object(
    {
      account_name    = optional(string, "")
      branch_name     = optional(string, "")
      git_url         = optional(string, "")
      repository_name = optional(string, "")
      root_folder     = optional(string, "")
    }
  )
  sensitive = false
  nullable  = false
  default   = {}
}

variable "data_factory_global_parameters" {
  description = "Specifies the Azure Data Factory global parameters."
  type = map(object({
    type  = optional(string, "String")
    value = optional(any, "")
  }))
  sensitive = false
  nullable  = false
  default   = {}
  validation {
    condition = alltrue([
      length([for type in values(var.data_factory_global_parameters)[*].type : type if !contains(["Array", "Bool", "Float", "Int", "Object", "String"], type)]) <= 0,
    ])
    error_message = "Please specify a valid global parameter configuration."
  }
}

variable "data_factory_published_content" {
  description = "Specifies the Azure Devops repository configuration."
  type = object(
    {
      parameters_file = optional(string, "")
      template_file   = optional(string, "")
    }
  )
  sensitive = false
  nullable  = false
  default   = {}
}

variable "data_factory_published_content_template_variables" {
  description = "Specifies custom template variables to use for the deployment templates from ADF."
  type        = map(string)
  sensitive   = false
  default     = {}
}

variable "data_factory_triggers_start" {
  description = "Specifies the list of trigger names that should be started after the deployment."
  type        = list(string)
  sensitive   = false
  default     = []
}

variable "data_factory_pipelines_run" {
  description = "Specifies the list of pipeline names that should be started after the deployment."
  type        = list(string)
  sensitive   = false
  default     = []
}

variable "data_factory_managed_private_endpoints" {
  description = "Specifies custom template variables to use for the deployment templates from ADF."
  type = map(object({
    subresource_name   = string
    target_resource_id = string
  }))
  sensitive = false
  default   = {}
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

variable "private_dns_zone_id_data_factory" {
  description = "Specifies the resource ID of the private DNS zone for Azure Data Factory. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_data_factory == "" || (length(split("/", var.private_dns_zone_id_data_factory)) == 9 && endswith(var.private_dns_zone_id_data_factory, "privatelink.datafactory.azure.net"))
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
