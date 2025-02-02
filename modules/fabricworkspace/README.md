<!-- BEGIN_TF_DOCS -->
# Microsoft Fabric Workspace Terraform Module

NOTE: Be aware that support for service principal authentication is limited today. For most of the API endpoints, service principal authentication will be added over time.

## Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.8)

- <a name="requirement_fabric"></a> [fabric](#requirement\_fabric) (0.1.0-beta.4)

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

### <a name="input_workspace_settings"></a> [workspace\_settings](#input\_workspace\_settings)

Description: Specifies settings of the fabric workspace.

Type:

```hcl
object({
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

No outputs.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->