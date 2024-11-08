<!-- BEGIN_TF_DOCS -->
# Azure Databricks Terraform Module

## Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>=0.12)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

- <a name="requirement_time"></a> [time](#requirement\_time) (~> 0.9)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_databricks_access_connector_name"></a> [databricks\_access\_connector\_name](#input\_databricks\_access\_connector\_name)

Description: Specifies the name of the Azure Databricks workspace.

Type: `string`

### <a name="input_location"></a> [location](#input\_location)

Description: Specifies the location of all resources.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: Specifies the resource group name in which all resources will get deployed.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

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

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_databricks_access_connector_id"></a> [databricks\_access\_connector\_id](#output\_databricks\_access\_connector\_id)

Description: Specifies the resource id of the Azure Databricks access connector.

### <a name="output_databricks_access_connector_name"></a> [databricks\_access\_connector\_name](#output\_databricks\_access\_connector\_name)

Description: Specifies the resource name of the Azure Databricks access connector.

### <a name="output_databricks_access_connector_principal_id"></a> [databricks\_access\_connector\_principal\_id](#output\_databricks\_access\_connector\_principal\_id)

Description: Specifies the principal id of the Azure Databricks access connector.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->