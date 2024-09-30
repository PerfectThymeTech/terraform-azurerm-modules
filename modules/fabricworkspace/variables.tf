# General variables

# Fabric workspace variables
variable "workspace_capacity_name" {
  description = "Specifies the name of a fabric capacity hosted in Azure to assign to the fabric workspace."
  type        = string
  sensitive   = false
  nullable    = true
  default     = null
  validation {
    condition     = var.workspace_capacity_name == null || length(var.workspace_capacity_name) > 2
    error_message = "Please specify a valid capacity name."
  }
}

# Not enabled as other workspaces not in the list would be removed from the domain
# variable "workspace_domain_id" {
#   description = "Specifies the fabric domain id to which the fabric workspace should be assigned."
#   type        = string
#   sensitive   = false
#   nullable    = true
#   default     = null
#   validation {
#     condition     = var.workspace_domain == null || can(length(var.workspace_domain_id) > 2)
#     error_message = "Please specify a valid capacity id."
#   }
# }

variable "workspace_display_name" {
  description = "Specifies the display name of the fabric workspace."
  type        = string
  sensitive   = false
  nullable    = false
  validation {
    condition     = length(var.workspace_display_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "workspace_description" {
  description = "Specifies the description of the fabric workspace."
  type        = string
  sensitive   = false
  nullable    = false
  default     = ""
}

variable "workspace_identity_enabled" {
  description = "Specifies whether the workspace identity should be enabled for the fabric workspace."
  type        = bool
  sensitive   = false
  nullable    = false
  default     = true
  validation {
    condition     = !var.workspace_identity_enabled || var.workspace_identity_enabled && var.workspace_capacity_name != null
    error_message = "Please specify a capacity id to enable the workspace identity."
  }
}

variable "workspace_settings" {
  description = "Specifies settings of the fabric workspace."
  type = object({
    automatic_log = optional(object({
      enabled = optional(bool, true)
    }), {})
    environment = optional(object({
      default_environment_name = optional(string, "")
      runtime_version          = optional(string, "1.3")
    }), {})
    high_concurrency = optional(object({
      notebook_interactive_run_enabled = optional(bool, true)
    }), {})
    pool = optional(object({
      customize_compute_enabled = optional(bool, true)
      default_pool_name         = optional(string, "defaultpool")
    }), {})
  })
  sensitive = false
  nullable  = false
  default   = {}
  validation {
    condition     = contains(["1.2", "1.3"], var.workspace_settings.environment.runtime_version)
    error_message = "Please specify a valid runtime version. Version 1.1 should no longer be used."
  }
}

variable "workspace_git" {
  description = "Specifies git config of the fabric workspace."
  type = object({
    git_provider_type = optional(string, "AzureDevOps")
    organization_name = string
    project_name      = string
    repository_name   = string
    branch_name       = optional(string, "main")
    directory_name    = optional(string, "code/fabric")
  })
  sensitive = false
  nullable  = true
  default   = null
  validation {
    condition     = var.workspace_git == null || can(contains(["AzureDevOps"], var.workspace_settings.environment.runtime_version))
    error_message = "Please specify a valid git provider. Valid values today include: [ 'AzureDevOps' ]."
  }
}

variable "workspace_role_assignments" {
  description = "Specifies the list of role assignments to be created at the fabric workspace level."
  type = map(object({
    principal_id   = string
    principal_type = string
    role           = string
  }))
  sensitive = false
  nullable  = false
  default   = {}
  validation {
    condition = alltrue([
      length([for role_assignment in var.workspace_role_assignments : true if !contains(["Group", "ServicePrincipal", "ServicePrincipalProfile", "User"], role_assignment.principal_type)]) <= 0
    ])
    error_message = "Please specify a valid principal type. Valid values are: ['Group', 'ServicePrincipal', 'ServicePrincipalProfile', 'User']"
  }
  validation {
    condition = alltrue([
      length([for role_assignment in var.workspace_role_assignments : true if !contains(["Admin", "Contributor", "Member", "Viewer"], role_assignment.role)]) <= 0
    ])
    error_message = "Please specify a valid role. Valid values are: ['Admin', 'Contributor', 'Member', 'Viewer']"
  }
}

# Diagnostics variables

# Network variables

# Customer-managed key variables
