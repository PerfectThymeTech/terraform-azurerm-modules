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

# Fabric workspace variables
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

variable "workspace_capacity_name" {
  description = "Specifies the name of a fabric capacity hosted in Azure to assign to the fabric workspace."
  type        = string
  sensitive   = false
  nullable    = true
  default     = null
  validation {
    condition     = length(var.workspace_capacity_name) >= 2 && length(regexall("[^[:alnum:]]", var.workspace_capacity_name)) <= 0
    error_message = "Please specify a valid name."
  }
}

# Not enabled as other workspaces not in the list would be removed from the domain
variable "workspace_domain_id" {
  description = "Specifies the fabric domain id to which the fabric workspace should be assigned."
  type        = string
  sensitive   = false
  nullable    = true
  default     = null
  validation {
    condition     = var.workspace_domain_id == null || can(length(var.workspace_domain_id) > 2)
    error_message = "Please specify a valid capacity id."
  }
}

variable "workspace_tag_ids" {
  description = "Specifies the tag ids which must be assigned to the fabric workspace."
  type        = list(string)
  sensitive   = false
  nullable    = false
  default     = []
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

variable "workspace_spark_settings" {
  description = "Specifies settings of the fabric workspace."
  type = object({
    enabled = optional(bool, false)
    automatic_log = optional(object({
      enabled = optional(bool, true)
    }), {})
    high_concurrency = optional(object({
      notebook_interactive_run_enabled = optional(bool, true)
      notebook_pipeline_run_enabled    = optional(bool, true)
    }), {})
    job = optional(object({
      conservative_job_admission_enabled = optional(bool, true)
      session_timeout_in_minutes         = optional(number, 30)
    }), {})
    pool = optional(object({
      customize_compute_enabled = optional(bool, true)
    }), {})
  })
  sensitive = false
  nullable  = false
  default   = {}
}

# variable "workspace_settings" {
#   description = "Specifies settings of the fabric workspace."
#   type = object({
#     automatic_log = optional(object({
#       enabled = optional(bool, true)
#     }), {})
#     environment = optional(object({
#       default_environment_enabled = optional(bool, false)
#       runtime_version             = optional(string, "1.3")
#       default_environment_config = optional(object({
#         publication_status = optional(string, "Published")
#         driver_cores       = optional(number, 4)
#         driver_memory      = optional(string, "28g")
#         executor_cores     = optional(number, 4)
#         executor_memory    = optional(string, "28g")
#         dynamic_executor_allocation = optional(object({
#           enabled       = optional(bool, false)
#           min_executors = optional(number, null)
#           max_executors = optional(number, null)
#         }), {})
#       }), {})
#     }), {})
#     high_concurrency = optional(object({
#       notebook_interactive_run_enabled = optional(bool, true)
#     }), {})
#     pool = optional(object({
#       customize_compute_enabled = optional(bool, true)
#       default_pool_enabled      = optional(bool, false)
#       default_pool_config = optional(object({
#         node_family = optional(string, "MemoryOptimized")
#         node_size   = optional(string, "Small")

#       }), {})
#     }), {})
#   })
#   sensitive = false
#   nullable  = false
#   default   = {}
#   validation {
#     condition     = contains(["1.2", "1.3"], var.workspace_settings.environment.runtime_version)
#     error_message = "Please specify a valid runtime version. Version 1.1 should no longer be used."
#   }
# }

variable "workspace_git" {
  description = "Specifies git config of the fabric workspace. Not supported when deploying with service principal."
  type = object({
    git_provider_type             = optional(string, "AzureDevOps")
    git_credentials_connection_id = optional(string, "")
    organization_name             = string
    project_name                  = string
    repository_name               = string
    branch_name                   = optional(string, "main")
    directory_name                = optional(string, "code/fabric")
  })
  sensitive = false
  nullable  = true
  default   = null
  validation {
    condition     = var.workspace_git == null || can(contains(["AzureDevOps"], var.workspace_git.git_provider_type))
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

variable "workspace_managed_private_endpoints" {
  description = "Specifies the map of managed private endpoints to be created at the fabric workspace level."
  type = map(object({
    target_private_link_resource_id = string
    target_subresource_type         = string
    approve                         = bool
  }))
  sensitive = false
  nullable  = false
  default   = {}
  validation {
    condition = alltrue([
      for private_endpoint in values(var.workspace_managed_private_endpoints) : (
        length(split("/", private_endpoint.target_private_link_resource_id)) == 9
      )
    ])
    error_message = "Please specify a valid target resource id."
  }
}

# Diagnostics variables
variable "workspace_onelake_diagnostics" {
  description = "Specifies the target workspace id and lakehouse id to which onelake events should be sent."
  type = object({
    enabled      = optional(bool, false)
    workspace_id = optional(string, "")
    lakehouse_id = optional(string, "")
  })
  sensitive = false
  nullable  = false
  default   = {}
}

# Network variables
variable "workspace_network_communication_policy" {
  description = "Specifies the network communication policy for the fabric workspace. If not specified, the default 'Allow' policy will be applied."
  type = object({
    inbound = optional(object({
      public_access_rules = optional(object({
        default_action = optional(string, "Allow")
      }), {})
    }), {})
    outbound = optional(object({
      public_access_rules = optional(object({
        default_action = optional(string, "Allow")
      }), {})
    }), {})
  })
  sensitive = false
  nullable  = false
  default   = {}
  validation {
    condition = alltrue([
      var.workspace_network_communication_policy.inbound.public_access_rules.default_action == "Allow" || var.workspace_network_communication_policy.inbound.public_access_rules.default_action == "Deny",
      var.workspace_network_communication_policy.outbound.public_access_rules.default_action == "Allow" || var.workspace_network_communication_policy.outbound.public_access_rules.default_action == "Deny"
    ])
    error_message = "Please specify a valid default action for the public access rules. Valid values are: ['Allow', 'Deny']"
  }
}

variable "workspace_outbound_gateway_rules" {
  description = "Specifies the outbound gateway rules for the fabric workspace."
  type = object({
    allowed_gateway_ids = optional(list(string), [])
    default_action      = optional(string, "Allow")
  })
  sensitive = false
  nullable  = false
  default   = {}
  validation {
    condition = var.workspace_outbound_gateway_rules.default_action == "Allow" || var.workspace_outbound_gateway_rules.default_action == "Deny"
    error_message = "Please specify a valid default action for the outbound gateway rules. Valid values are: ['Allow', 'Deny']"
  }
}

variable "workspace_private_endpoint_enabled" {
  description = "Specifies whether the private endpoints are enabled for the workspace."
  type        = bool
  sensitive   = false
  nullable    = false
  default     = false
}

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

variable "private_dns_zone_id_workspace" {
  description = "Specifies the resource ID of the private DNS zone for the fabric workspace. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  nullable    = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_workspace == "" || (length(split("/", var.private_dns_zone_id_workspace)) == 9 && endswith(var.private_dns_zone_id_workspace, "privatelink.fabric.microsoft.com"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

# Customer-managed key variables
