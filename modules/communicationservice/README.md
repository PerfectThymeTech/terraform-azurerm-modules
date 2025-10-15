<!-- BEGIN_TF_DOCS -->
# Azure Communication Service Terraform Module

## Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>=0.12)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_communication_service_name"></a> [communication\_service\_name](#input\_communication\_service\_name)

Description: Specifies the name of the Communication Service. Changing this forces a new resource to be created.

Type: `string`

### <a name="input_location"></a> [location](#input\_location)

Description: Specifies the location of all resources.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: Specifies the resource group name in which all resources will get deployed.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_communication_service_data_location"></a> [communication\_service\_data\_location](#input\_communication\_service\_data\_location)

Description: Specifies the name of the SKU used for this Key Vault.

Type: `string`

Default: `"United States"`

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

### <a name="output_communication_service_hostname"></a> [communication\_service\_hostname](#output\_communication\_service\_hostname)

Description: Specifies the communication service hostname.

### <a name="output_communication_service_id"></a> [communication\_service\_id](#output\_communication\_service\_id)

Description: Specifies the communication service resource id.

### <a name="output_communication_service_name"></a> [communication\_service\_name](#output\_communication\_service\_name)

Description: Specifies the communication service resource name.

### <a name="output_communication_service_primary_connection_string"></a> [communication\_service\_primary\_connection\_string](#output\_communication\_service\_primary\_connection\_string)

Description: Specifies the communication service primary connection string.

### <a name="output_communication_service_primary_key"></a> [communication\_service\_primary\_key](#output\_communication\_service\_primary\_key)

Description: Specifies the communication service primary key.

### <a name="output_communication_service_secondary_connection_string"></a> [communication\_service\_secondary\_connection\_string](#output\_communication\_service\_secondary\_connection\_string)

Description: Specifies the communication service secondary connection string.

### <a name="output_communication_service_secondary_key"></a> [communication\_service\_secondary\_key](#output\_communication\_service\_secondary\_key)

Description: Specifies the communication service secondary key.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->