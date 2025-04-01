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

### <a name="input_workspace_display_name"></a> [workspace\_display\_name](#input\_workspace\_display\_name)

Description: Specifies the display name of the fabric workspace.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_workspace_capacity_name"></a> [workspace\_capacity\_name](#input\_workspace\_capacity\_name)

Description: Specifies the name of a fabric capacity hosted in Azure to assign to the fabric workspace.

Type: `string`

Default: `null`

### <a name="input_workspace_description"></a> [workspace\_description](#input\_workspace\_description)

Description: Specifies the description of the fabric workspace.

Type: `string`

Default: `""`

### <a name="input_workspace_git"></a> [workspace\_git](#input\_workspace\_git)

Description: Specifies git config of the fabric workspace. Not supported when deploying with service principal.

Type:

```hcl
object({
    git_provider_type = optional(string, "AzureDevOps")
    organization_name = string
    project_name      = string
    repository_name   = string
    branch_name       = optional(string, "main")
    directory_name    = optional(string, "code/fabric")
  })
```

Default: `null`

### <a name="input_workspace_identity_enabled"></a> [workspace\_identity\_enabled](#input\_workspace\_identity\_enabled)

Description: Specifies whether the workspace identity should be enabled for the fabric workspace.

Type: `bool`

Default: `true`

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
    }), {})
    pool = optional(object({
      customize_compute_enabled = optional(bool, true)
    }), {})
  })
```

Default: `{}`

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