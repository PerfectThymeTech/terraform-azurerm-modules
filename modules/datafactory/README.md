<!-- BEGIN_TF_DOCS -->
# Azure Data Factory Terraform Module

NOTE: The `data_factory_triggers_start` and `data_factory_pipelines_run` features rely on Azure CLI and therefore require you to be authenticated.

## Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>=0.12)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (~> 2.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

- <a name="requirement_time"></a> [time](#requirement\_time) (~> 0.9)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_data_factory_name"></a> [data\_factory\_name](#input\_data\_factory\_name)

Description: Specifies the name of the data factory.

Type: `string`

### <a name="input_location"></a> [location](#input\_location)

Description: Specifies the location of all resources.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: Specifies the resource group name in which all resources will get deployed.

Type: `string`

### <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id)

Description: Specifies the resource id of a subnet in which the private endpoints get created.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_connectivity_delay_in_seconds"></a> [connectivity\_delay\_in\_seconds](#input\_connectivity\_delay\_in\_seconds)

Description: Specifies the delay in seconds after the private endpoint deployment (required for the DNS automation via Policies).

Type: `number`

Default: `120`

### <a name="input_customer_managed_key"></a> [customer\_managed\_key](#input\_customer\_managed\_key)

Description: Specifies the customer managed key configurations.

Type:

```hcl
object({
    key_vault_id                     = string,
    key_vault_key_id                 = string,
    key_vault_key_versionless_id     = string,
    user_assigned_identity_id        = string,
    user_assigned_identity_client_id = string,
  })
```

Default: `null`

### <a name="input_data_factory_azure_devops_repo"></a> [data\_factory\_azure\_devops\_repo](#input\_data\_factory\_azure\_devops\_repo)

Description: Specifies the Azure Devops repository configuration.

Type:

```hcl
object(
    {
      account_name    = optional(string, "")
      branch_name     = optional(string, "")
      project_name    = optional(string, "")
      repository_name = optional(string, "")
      root_folder     = optional(string, "")
      tenant_id       = optional(string, "")
    }
  )
```

Default: `{}`

### <a name="input_data_factory_github_repo"></a> [data\_factory\_github\_repo](#input\_data\_factory\_github\_repo)

Description: Specifies the Github repository configuration.

Type:

```hcl
object(
    {
      account_name    = optional(string, "")
      branch_name     = optional(string, "")
      git_url         = optional(string, "")
      repository_name = optional(string, "")
      root_folder     = optional(string, "")
    }
  )
```

Default: `{}`

### <a name="input_data_factory_global_parameters"></a> [data\_factory\_global\_parameters](#input\_data\_factory\_global\_parameters)

Description: Specifies the Azure Data Factory global parameters.

Type:

```hcl
map(object({
    type  = optional(string, "String")
    value = optional(any, "")
  }))
```

Default: `{}`

### <a name="input_data_factory_managed_private_endpoints"></a> [data\_factory\_managed\_private\_endpoints](#input\_data\_factory\_managed\_private\_endpoints)

Description: Specifies custom template variables to use for the deployment templates from ADF.

Type:

```hcl
map(object({
    subresource_name   = string
    target_resource_id = string
  }))
```

Default: `{}`

### <a name="input_data_factory_pipelines_run"></a> [data\_factory\_pipelines\_run](#input\_data\_factory\_pipelines\_run)

Description: Specifies the list of pipeline names that should be started after the deployment.

Type: `list(string)`

Default: `[]`

### <a name="input_data_factory_published_content"></a> [data\_factory\_published\_content](#input\_data\_factory\_published\_content)

Description: Specifies the Azure Devops repository configuration.

Type:

```hcl
object(
    {
      parameters_file = optional(string, "")
      template_file   = optional(string, "")
    }
  )
```

Default: `{}`

### <a name="input_data_factory_published_content_template_variables"></a> [data\_factory\_published\_content\_template\_variables](#input\_data\_factory\_published\_content\_template\_variables)

Description: Specifies custom template variables to use for the deployment templates from ADF.

Type: `map(string)`

Default: `{}`

### <a name="input_data_factory_purview_id"></a> [data\_factory\_purview\_id](#input\_data\_factory\_purview\_id)

Description: Specifies the resource id of purview that should be connnected to the data factory.

Type: `string`

Default: `null`

### <a name="input_data_factory_triggers_start"></a> [data\_factory\_triggers\_start](#input\_data\_factory\_triggers\_start)

Description: Specifies the list of trigger names that should be started after the deployment.

Type: `list(string)`

Default: `[]`

### <a name="input_diagnostics_configurations"></a> [diagnostics\_configurations](#input\_diagnostics\_configurations)

Description: Specifies the diagnostic configuration for the service.

Type:

```hcl
list(object({
    log_analytics_workspace_id = optional(string, ""),
    storage_account_id         = optional(string, "")
  }))
```

Default: `[]`

### <a name="input_private_dns_zone_id_data_factory"></a> [private\_dns\_zone\_id\_data\_factory](#input\_private\_dns\_zone\_id\_data\_factory)

Description: Specifies the resource ID of the private DNS zone for Azure Data Factory. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_data_factory_id"></a> [data\_factory\_id](#output\_data\_factory\_id)

Description: Specifies the id of the data factory.

### <a name="output_data_factory_name"></a> [data\_factory\_name](#output\_data\_factory\_name)

Description: Specifies the name of the data factory.

### <a name="output_data_factory_principal_id"></a> [data\_factory\_principal\_id](#output\_data\_factory\_principal\_id)

Description: Specifies the principal id of the data factory.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->