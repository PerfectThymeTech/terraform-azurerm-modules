# General variables
variable "location" {
  description = "Specifies the location of all resources."
  type        = string
  sensitive   = false
}

variable "environment" {
  description = "Specifies the environment of the deployment."
  type        = string
  sensitive   = false
  default     = "dev"
  validation {
    condition     = contains(["int", "dev", "tst", "qa", "prd"], var.environment)
    error_message = "Please use an allowed value: \"int\", \"dev\", \"tst\", \"qa\" or \"prd\"."
  }
}

variable "prefix" {
  description = "Specifies the prefix for all resources created in this deployment."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.prefix) >= 2 && length(var.prefix) <= 10
    error_message = "Please specify a prefix with more than two and less than 10 characters."
  }
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
}

# Service variables
variable "virtual_network_id" {
  description = "Specifies the id of the vnet in which the subnets will be created."
  type        = string
  sensitive   = false
  nullable    = false
  validation {
    condition     = length(split("/", var.virtual_network_id)) == 9
    error_message = "Please specify a valid resource id."
  }
}

variable "nsg_id" {
  description = "Specifies the resource ID of the default network security group for the Azure Function."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.nsg_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "route_table_id" {
  description = "Specifies the resource ID of the default route table for the Azure Function."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.route_table_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "databricks_private_subnet_address_prefix" {
  description = "Specifies the address prefix of the databricks private subnet."
  type        = string
  sensitive   = false
  nullable    = false
}

variable "databricks_public_subnet_address_prefix" {
  description = "Specifies the address prefix of the databricks public subnet."
  type        = string
  sensitive   = false
  nullable    = false
}

# Network variables
