<!-- BEGIN_TF_DOCS -->
# Azure Databricks Workspace Terraform Module

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

### <a name="input_databricks_workspace_access_connector_id"></a> [databricks\_workspace\_access\_connector\_id](#input\_databricks\_workspace\_access\_connector\_id)

Description: Specifies the id of the databricks access connector used for accessing the dbfs.

Type: `string`

### <a name="input_databricks_workspace_name"></a> [databricks\_workspace\_name](#input\_databricks\_workspace\_name)

Description: Specifies the name of the Azure Databricks workspace.

Type: `string`

### <a name="input_databricks_workspace_private_subnet_name"></a> [databricks\_workspace\_private\_subnet\_name](#input\_databricks\_workspace\_private\_subnet\_name)

Description: Specifies the name private subnet of the Azure Databricks workspace.

Type: `string`

### <a name="input_databricks_workspace_private_subnet_network_security_group_association_id"></a> [databricks\_workspace\_private\_subnet\_network\_security\_group\_association\_id](#input\_databricks\_workspace\_private\_subnet\_network\_security\_group\_association\_id)

Description: Specifies the id of the network group association of the private subnet used for the Azure Databricks workspace.

Type: `string`

### <a name="input_databricks_workspace_public_subnet_name"></a> [databricks\_workspace\_public\_subnet\_name](#input\_databricks\_workspace\_public\_subnet\_name)

Description: Specifies the name public subnet of the Azure Databricks workspace.

Type: `string`

### <a name="input_databricks_workspace_public_subnet_network_security_group_association_id"></a> [databricks\_workspace\_public\_subnet\_network\_security\_group\_association\_id](#input\_databricks\_workspace\_public\_subnet\_network\_security\_group\_association\_id)

Description: Specifies the id of the network group association of the public subnet used for the Azure Databricks workspace.

Type: `string`

### <a name="input_databricks_workspace_virtual_network_id"></a> [databricks\_workspace\_virtual\_network\_id](#input\_databricks\_workspace\_virtual\_network\_id)

Description: Specifies the id of the virtual network used for the Azure Databricks workspace.

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
    key_vault_key_versionless_id     = string,
    user_assigned_identity_id        = string,
    user_assigned_identity_client_id = string,
  })
```

Default: `null`

### <a name="input_databricks_workspace_browser_authentication_private_endpoint_enabled"></a> [databricks\_workspace\_browser\_authentication\_private\_endpoint\_enabled](#input\_databricks\_workspace\_browser\_authentication\_private\_endpoint\_enabled)

Description: Specifies whether the 'browser\_authentication' private endpoint should be deployed for the Azure Databricks workspace.

Type: `bool`

Default: `false`

### <a name="input_databricks_workspace_machine_learning_workspace_id"></a> [databricks\_workspace\_machine\_learning\_workspace\_id](#input\_databricks\_workspace\_machine\_learning\_workspace\_id)

Description: Specifies the id of the databricks access connector used for accessing the dbfs.

Type: `string`

Default: `null`

### <a name="input_databricks_workspace_storage_account_sku_name"></a> [databricks\_workspace\_storage\_account\_sku\_name](#input\_databricks\_workspace\_storage\_account\_sku\_name)

Description: Specifies the storage account sku for the dbfs storage of the Azure Databricks workspace.

Type: `string`

Default: `"Standard_LRS"`

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

### <a name="input_location_private_endpoint"></a> [location\_private\_endpoint](#input\_location\_private\_endpoint)

Description: Specifies the location of the private endpoint. Use this variables only if the private endpoint(s) should reside in a different location than the service itself.

Type: `string`

Default: `null`

### <a name="input_private_dns_zone_id_databricks"></a> [private\_dns\_zone\_id\_databricks](#input\_private\_dns\_zone\_id\_databricks)

Description: Specifies the resource ID of the private DNS zone for Azure Databricks. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_databricks_workspace_completed"></a> [databricks\_workspace\_completed](#output\_databricks\_workspace\_completed)

Description: Specifies whether the connectivity and identity has been successfully configured.

### <a name="output_databricks_workspace_id"></a> [databricks\_workspace\_id](#output\_databricks\_workspace\_id)

Description: Specifies the resource id of the Azure Databricks workspace.

### <a name="output_databricks_workspace_managed_resource_group_id"></a> [databricks\_workspace\_managed\_resource\_group\_id](#output\_databricks\_workspace\_managed\_resource\_group\_id)

Description: Specifies the id of the managed resource group of the Azure Databricks workspace.

### <a name="output_databricks_workspace_managed_resource_group_name"></a> [databricks\_workspace\_managed\_resource\_group\_name](#output\_databricks\_workspace\_managed\_resource\_group\_name)

Description: Specifies the name of the managed resource group of the Azure Databricks workspace.

### <a name="output_databricks_workspace_managed_storage_account_name"></a> [databricks\_workspace\_managed\_storage\_account\_name](#output\_databricks\_workspace\_managed\_storage\_account\_name)

Description: Specifies the name of the managed dbfs storage account of the Azure Databricks workspace.

### <a name="output_databricks_workspace_name"></a> [databricks\_workspace\_name](#output\_databricks\_workspace\_name)

Description: Specifies the resource name of the Azure Databricks workspace.

### <a name="output_databricks_workspace_storage_account_identity_principal_id"></a> [databricks\_workspace\_storage\_account\_identity\_principal\_id](#output\_databricks\_workspace\_storage\_account\_identity\_principal\_id)

Description: Specifies the principal id of the managed dbfs storage account of the Azure Databricks workspace.

### <a name="output_databricks_workspace_workspace_id"></a> [databricks\_workspace\_workspace\_id](#output\_databricks\_workspace\_workspace\_id)

Description: Specifies the workspace id of the Azure Databricks workspace.

### <a name="output_databricks_workspace_workspace_url"></a> [databricks\_workspace\_workspace\_url](#output\_databricks\_workspace\_workspace\_url)

Description: Specifies the workspace url of the Azure Databricks workspace.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->