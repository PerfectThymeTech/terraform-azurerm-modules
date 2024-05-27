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

# User Assigned Identity variables
variable "user_assigned_identity_name" {
  description = "Specifies the name of the User Assigned Identity. Changing this forces a new resource to be created."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.user_assigned_identity_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "user_assigned_identity_federated_identity_credentials" {
  description = "Specifies the federated identity credentials to be added to the user assigned identity."
  type = map(object({
    audience = string,
    issuer   = string,
    subject  = string
  }))
  sensitive = false
  default   = {}
}

# Diagnostics variables

# Network variables
