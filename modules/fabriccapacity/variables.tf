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

# AI studio hub variables
variable "fabric_capacity_name" {
  description = "Specifies the name of the fabric capacity."
  type        = string
  sensitive   = false
  nullable    = false
  validation {
    condition     = length(var.fabric_capacity_name) >= 2 && length(regexall("[^[:alnum:]]", var.fabric_capacity_name)) <= 0
    error_message = "Please specify a valid name."
  }
}

variable "fabric_capacity_admin_emails" {
  description = "Specifies the list of admin email addresses of the fabric capacity."
  type        = list(string)
  sensitive   = false
  nullable    = false
  default     = []
}

variable "fabric_capacity_sku" {
  description = "Specifies the sku name of the fabric capacity."
  type        = string
  sensitive   = false
  nullable    = false
  default     = "F2"
  validation {
    condition     = contains(["F2", "F4", "F8", "F16", "F32", "F64", "F128", "F256", "F512", "F1024", "F2048"], var.fabric_capacity_sku)
    error_message = "Please specify a valid sku. Valid values today include: [ 'F2', 'F4', 'F8', 'F16', 'F32', 'F64', 'F128', 'F256', 'F512', 'F1024', 'F2048' ]."
  }
}

# Diagnostics variables

# Network variables

# Customer-managed key variables
