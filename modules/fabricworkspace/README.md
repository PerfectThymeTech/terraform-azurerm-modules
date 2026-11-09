<!-- BEGIN_TF_DOCS -->
# 📊 Microsoft Fabric Workspace Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-fabricworkspace.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-fabricworkspace.yml)

Creates a Microsoft Fabric workspace on an existing capacity with optional Git integration, Spark settings, role assignments, network policy, private link and managed private endpoints.

## 📦 Overview

- A Fabric workspace (`fabric_workspace`) on the capacity named in `workspace_capacity_name`, with optional Spark settings and Git integration.
- A workspace network communication policy and, when `workspace_outbound_gateway_rules` applies, outbound gateway rules.
- Optional inbound private link (a private link service for Fabric and a private endpoint), role assignments and managed private endpoints.
- Optional PowerShell steps for domain assignment, tags, OneLake diagnostics and managed private endpoint approval.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- The workspace identity is on by default (`workspace_identity_enabled` defaults to `true`).
- When private link is enabled (`workspace_private_endpoint_enabled`), the private endpoint uses automatic approval.
- The scripts obtain the Fabric application programming interface (API) token from the Azure command-line interface (CLI) session at run time; no secret is stored in the module.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- The network communication policy (`workspace_network_communication_policy`) defaults to `Allow` for both inbound and outbound public access, and the outbound gateway rules (`workspace_outbound_gateway_rules`) default to `Allow`. *Reason:* not stated in the module code. *Mitigation:* set `default_action = "Deny"` in both variables and enable private link.
- Private link is off by default (`workspace_private_endpoint_enabled = false`). *Reason:* not stated in the module code. *Mitigation:* set `workspace_private_endpoint_enabled = true`.
- With `workspace_managed_private_endpoints[*].approve = true`, connections are approved by a script (the attribute has no default). *Reason:* not stated in the module code. *Mitigation:* run Terraform from a trusted machine or pipeline whose identity can approve only the connections you intend.
- The Git integration is hard-coded to `PreferWorkspace` with `allow_override_items = true`. *Reason:* not stated in the module code. *Mitigation:* review the Git settings before you use `workspace_git`.
- Several steps run PowerShell and the Azure CLI on the machine that runs Terraform (domain, tags, OneLake diagnostics and approval; see [Scripted steps](../../docs/scripted-steps.md)). *Reason:* not stated in the module code. *Mitigation:* run Terraform from a trusted machine or pipeline whose identity has least privilege in Fabric.

**Prerequisites**

- An existing Fabric capacity looked up by `workspace_capacity_name`. In practice the input is required: its validation and the capacity lookup do not tolerate `null`, although it has a `null` default.
- `subnet_id` has no default and is required even when private link is disabled.
- `workspace_git` is not supported when deploying with a service principal.
- `pwsh` and the Azure CLI (`az`), signed in, on the machine that runs Terraform. The signed-in identity must be allowed to call the Fabric Representational State Transfer (REST) API and, for approvals, to approve private endpoint connections on the target resource.
- Terraform `~> 1.8` and the `microsoft/fabric` provider (`~> 1.0`).

> [!NOTE]
> Be aware that support for service principal authentication is limited today. For most of the API endpoints, service principal authentication will be added over time.

## 🚀 Usage

```hcl
module "fabric_workspace" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/fabricworkspace?ref=<release-tag>"

  location                = "<azure-region>"
  resource_group_name     = "<resource-group-name>"
  workspace_display_name  = "<workspace-display-name>"
  workspace_capacity_name = "<fabric-capacity-name>"
  subnet_id               = "<subnet-resource-id>"
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).

## 📚 Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.8)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (~> 2.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 5.0)

- <a name="requirement_fabric"></a> [fabric](#requirement\_fabric) (~> 1.0)

- <a name="requirement_time"></a> [time](#requirement\_time) (~> 0.9)

## Providers

The following providers are used by this module:

- <a name="provider_azapi"></a> [azapi](#provider\_azapi) (~> 2.0)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 5.0)

- <a name="provider_fabric"></a> [fabric](#provider\_fabric) (~> 1.0)

- <a name="provider_null"></a> [null](#provider\_null)

- <a name="provider_time"></a> [time](#provider\_time) (~> 0.9)

## Resources

The following resources are used by this module:

- [azapi_resource.fabric_private_link_service](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) (resource)
- [azurerm_private_endpoint.private_endpoint_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [fabric_spark_workspace_settings.workspace_settings](https://registry.terraform.io/providers/microsoft/fabric/latest/docs/resources/spark_workspace_settings) (resource)
- [fabric_workspace.workspace](https://registry.terraform.io/providers/microsoft/fabric/latest/docs/resources/workspace) (resource)
- [fabric_workspace_git.workspace_git](https://registry.terraform.io/providers/microsoft/fabric/latest/docs/resources/workspace_git) (resource)
- [fabric_workspace_managed_private_endpoint.workspace_managed_private_endpoint](https://registry.terraform.io/providers/microsoft/fabric/latest/docs/resources/workspace_managed_private_endpoint) (resource)
- [fabric_workspace_network_communication_policy.workspace_network_communication_policy](https://registry.terraform.io/providers/microsoft/fabric/latest/docs/resources/workspace_network_communication_policy) (resource)
- [fabric_workspace_outbound_gateway_rules.workspace_outbound_gateway_rules](https://registry.terraform.io/providers/microsoft/fabric/latest/docs/resources/workspace_outbound_gateway_rules) (resource)
- [fabric_workspace_role_assignment.workspace_role_assignment](https://registry.terraform.io/providers/microsoft/fabric/latest/docs/resources/workspace_role_assignment) (resource)
- [null_resource.workspace_disagnostics_onelake](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) (resource)
- [null_resource.workspace_domain](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) (resource)
- [null_resource.workspace_managed_private_endpoint_approval](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) (resource)
- [null_resource.workspace_tags](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) (resource)
- [time_sleep.sleep_connectivity](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [fabric_capacity.capacity](https://registry.terraform.io/providers/microsoft/fabric/latest/docs/data-sources/capacity) (data source)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input\_location)

Description: Specifies the location of all resources.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: Specifies the resource group name in which all resources will get deployed.

Type: `string`

### <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id)

Description: Specifies the resource id of a subnet in which the private endpoints get created.

Type: `string`

### <a name="input_workspace_display_name"></a> [workspace\_display\_name](#input\_workspace\_display\_name)

Description: Specifies the display name of the fabric workspace.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_connectivity_delay_in_seconds"></a> [connectivity\_delay\_in\_seconds](#input\_connectivity\_delay\_in\_seconds)

Description: Specifies the delay in seconds after the private endpoint deployment (required for the DNS automation via Policies).

Type: `number`

Default: `120`

### <a name="input_private_dns_zone_id_workspace"></a> [private\_dns\_zone\_id\_workspace](#input\_private\_dns\_zone\_id\_workspace)

Description: Specifies the resource ID of the private DNS zone for the fabric workspace. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

### <a name="input_workspace_capacity_name"></a> [workspace\_capacity\_name](#input\_workspace\_capacity\_name)

Description: Specifies the name of a fabric capacity hosted in Azure to assign to the fabric workspace.

Type: `string`

Default: `null`

### <a name="input_workspace_description"></a> [workspace\_description](#input\_workspace\_description)

Description: Specifies the description of the fabric workspace.

Type: `string`

Default: `""`

### <a name="input_workspace_domain_id"></a> [workspace\_domain\_id](#input\_workspace\_domain\_id)

Description: Specifies the fabric domain id to which the fabric workspace should be assigned.

Type: `string`

Default: `null`

### <a name="input_workspace_git"></a> [workspace\_git](#input\_workspace\_git)

Description: Specifies git config of the fabric workspace. Not supported when deploying with service principal.

Type:

```hcl
object({
    git_provider_type             = optional(string, "AzureDevOps")
    git_credentials_connection_id = optional(string, "")
    organization_name             = string
    project_name                  = string
    repository_name               = string
    branch_name                   = optional(string, "main")
    directory_name                = optional(string, "code/fabric")
  })
```

Default: `null`

### <a name="input_workspace_identity_enabled"></a> [workspace\_identity\_enabled](#input\_workspace\_identity\_enabled)

Description: Specifies whether the workspace identity should be enabled for the fabric workspace.

Type: `bool`

Default: `true`

### <a name="input_workspace_managed_private_endpoints"></a> [workspace\_managed\_private\_endpoints](#input\_workspace\_managed\_private\_endpoints)

Description: Specifies the map of managed private endpoints to be created at the fabric workspace level.

Type:

```hcl
map(object({
    target_private_link_resource_id = string
    target_subresource_type         = string
    approve                         = bool
  }))
```

Default: `{}`

### <a name="input_workspace_network_communication_policy"></a> [workspace\_network\_communication\_policy](#input\_workspace\_network\_communication\_policy)

Description: Specifies the network communication policy for the fabric workspace. If not specified, the default 'Allow' policy will be applied.

Type:

```hcl
object({
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
```

Default: `{}`

### <a name="input_workspace_onelake_diagnostics"></a> [workspace\_onelake\_diagnostics](#input\_workspace\_onelake\_diagnostics)

Description: Specifies the target workspace id and lakehouse id to which onelake events should be sent.

Type:

```hcl
object({
    enabled      = optional(bool, false)
    workspace_id = optional(string, "")
    lakehouse_id = optional(string, "")
  })
```

Default: `{}`

### <a name="input_workspace_outbound_gateway_rules"></a> [workspace\_outbound\_gateway\_rules](#input\_workspace\_outbound\_gateway\_rules)

Description: Specifies the outbound gateway rules for the fabric workspace.

Type:

```hcl
object({
    allowed_gateway_ids = optional(list(string), [])
    default_action      = optional(string, "Allow")
  })
```

Default: `{}`

### <a name="input_workspace_private_endpoint_enabled"></a> [workspace\_private\_endpoint\_enabled](#input\_workspace\_private\_endpoint\_enabled)

Description: Specifies whether the private endpoints are enabled for the workspace.

Type: `bool`

Default: `false`

### <a name="input_workspace_role_assignments"></a> [workspace\_role\_assignments](#input\_workspace\_role\_assignments)

Description: Specifies the list of role assignments to be created at the fabric workspace level.

Type:

```hcl
map(object({
    principal_id   = string
    principal_type = string
    role           = string
  }))
```

Default: `{}`

### <a name="input_workspace_spark_settings"></a> [workspace\_spark\_settings](#input\_workspace\_spark\_settings)

Description: Specifies settings of the fabric workspace.

Type:

```hcl
object({
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
```

Default: `{}`

### <a name="input_workspace_tag_ids"></a> [workspace\_tag\_ids](#input\_workspace\_tag\_ids)

Description: Specifies the tag ids which must be assigned to the fabric workspace.

Type: `list(string)`

Default: `[]`

## Outputs

The following outputs are exported:

### <a name="output_fabric_workspace_application_id"></a> [fabric\_workspace\_application\_id](#output\_fabric\_workspace\_application\_id)

Description: Specifies the application id of the fabric workspace.

### <a name="output_fabric_workspace_blob_endpoint"></a> [fabric\_workspace\_blob\_endpoint](#output\_fabric\_workspace\_blob\_endpoint)

Description: Specifies the blob enpoint of the fabric workspace.

### <a name="output_fabric_workspace_dfs_endpoint"></a> [fabric\_workspace\_dfs\_endpoint](#output\_fabric\_workspace\_dfs\_endpoint)

Description: Specifies the dfs enpoint of the fabric workspace.

### <a name="output_fabric_workspace_id"></a> [fabric\_workspace\_id](#output\_fabric\_workspace\_id)

Description: Specifies the id of the fabric workspace.

### <a name="output_fabric_workspace_name"></a> [fabric\_workspace\_name](#output\_fabric\_workspace\_name)

Description: Specifies the name of the fabric workspace.

### <a name="output_fabric_workspace_principal_id"></a> [fabric\_workspace\_principal\_id](#output\_fabric\_workspace\_principal\_id)

Description: Specifies the principal id of the fabric workspace.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->