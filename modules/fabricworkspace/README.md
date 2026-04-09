<!-- BEGIN_TF_DOCS -->
# Microsoft Fabric Workspace Terraform Module

NOTE: Be aware that support for service principal authentication is limited today. For most of the API endpoints, service principal authentication will be added over time.

## Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.8)

- <a name="requirement_fabric"></a> [fabric](#requirement\_fabric) (~> 1.0)

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