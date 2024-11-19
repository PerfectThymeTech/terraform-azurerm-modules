# General variables
variable "location" {
  description = "Specifies the location of all resources."
  type        = string
  sensitive   = false
  nullable    = false
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

# Service variables
variable "databricks_workspace_name" {
  description = "Specifies the name of the Azure Databricks workspace."
  type        = string
  sensitive   = false
  nullable    = false
  validation {
    condition     = length(var.databricks_workspace_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "databricks_workspace_access_connector_id" {
  description = "Specifies the id of the databricks access connector used for accessing the dbfs."
  type        = string
  sensitive   = false
  nullable    = false
  validation {
    condition     = (length(split("/", var.databricks_workspace_access_connector_id)) == 9) # && can(provider::azurerm::parse_resource_id(var.databricks_workspace_access_connector_id))
    error_message = "Please specify a valid resource id."
  }
}

variable "databricks_workspace_machine_learning_workspace_id" {
  description = "Specifies the id of the databricks access connector used for accessing the dbfs."
  type        = string
  sensitive   = false
  nullable    = true
  default     = null
  validation {
    condition     = var.databricks_workspace_machine_learning_workspace_id == null || (length(try(split("/", var.databricks_workspace_machine_learning_workspace_id), [])) == 9) # && can(provider::azurerm::parse_resource_id(var.databricks_workspace_machine_learning_workspace_id))
    error_message = "Please specify a valid resource id."
  }
}

variable "databricks_workspace_virtual_network_id" {
  description = "Specifies the id of the virtual network used for the Azure Databricks workspace."
  type        = string
  sensitive   = false
  nullable    = false
  validation {
    condition     = (length(split("/", var.databricks_workspace_virtual_network_id)) == 9) # && can(provider::azurerm::parse_resource_id(var.databricks_workspace_virtual_network_id))
    error_message = "Please specify a valid resource id."
  }
}

variable "databricks_workspace_private_subnet_name" {
  description = "Specifies the name private subnet of the Azure Databricks workspace."
  type        = string
  sensitive   = false
  nullable    = false
  validation {
    condition     = length(var.databricks_workspace_private_subnet_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "databricks_workspace_private_subnet_network_security_group_association_id" {
  description = "Specifies the id of the network group association of the private subnet used for the Azure Databricks workspace."
  type        = string
  sensitive   = false
  nullable    = false
  validation {
    condition     = length(split("/", var.databricks_workspace_private_subnet_network_security_group_association_id)) == 11 # && can(provider::azurerm::parse_resource_id(var.databricks_workspace_private_subnet_network_security_group_association_id))
    error_message = "Please specify a valid subnet nsg association id."
  }
}

variable "databricks_workspace_public_subnet_name" {
  description = "Specifies the name public subnet of the Azure Databricks workspace."
  type        = string
  sensitive   = false
  nullable    = false
  validation {
    condition     = length(var.databricks_workspace_public_subnet_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "databricks_workspace_public_subnet_network_security_group_association_id" {
  description = "Specifies the id of the network group association of the public subnet used for the Azure Databricks workspace."
  type        = string
  sensitive   = false
  nullable    = false
  validation {
    condition     = length(split("/", var.databricks_workspace_public_subnet_network_security_group_association_id)) == 11 # && can(provider::azurerm::parse_resource_id(var.databricks_workspace_public_subnet_network_security_group_association_id))
    error_message = "Please specify a valid subnet nsg association id."
  }
}

variable "databricks_workspace_storage_account_sku_name" {
  description = "Specifies the storage account sku for the dbfs storage of the Azure Databricks workspace."
  type        = string
  sensitive   = false
  nullable    = false
  default     = "Standard_LRS"
  validation {
    condition     = contains(["Standard_LRS", "Standard_GRS", "Standard_RAGRS", "Standard_GZRS", "Standard_RAGZRS", "Standard_ZRS", "Premium_LRS", "Premium_ZRS"], var.databricks_workspace_storage_account_sku_name)
    error_message = "Please specify a valid storage account sku name."
  }
}

variable "databricks_workspace_browser_authentication_private_endpoint_enabled" {
  description = "Specifies whether the 'browser_authentication' private endpoint should be deployed for the Azure Databricks workspace."
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
    condition     = length(split("/", var.subnet_id)) == 11 # && can(provider::azurerm::parse_resource_id(var.subnet_id))
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

variable "private_dns_zone_id_databricks" {
  description = "Specifies the resource ID of the private DNS zone for Azure Databricks. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_databricks == "" || (length(split("/", var.private_dns_zone_id_databricks)) == 9 && endswith(var.private_dns_zone_id_databricks, "privatelink.azuredatabricks.net")) # && can(provider::azurerm::parse_resource_id(var.private_dns_zone_id_databricks))
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
