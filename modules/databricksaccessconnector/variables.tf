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

# Service variables
variable "databricks_access_connector_name" {
  description = "Specifies the name of the Azure Databricks workspace."
  type        = string
  sensitive   = false
  nullable    = false
  validation {
    condition     = length(var.databricks_access_connector_name) >= 2
    error_message = "Please specify a valid name."
  }
}

# Diagnostics variables
