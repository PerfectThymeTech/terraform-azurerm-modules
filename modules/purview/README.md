<!-- BEGIN_TF_DOCS -->
# Microsoft Purview Terraform Module

## Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>=0.12)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 4.0.0)

- <a name="requirement_time"></a> [time](#requirement\_time) (>= 0.9.1)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input\_location)

Description: Specifies the location of all resources.

Type: `string`

### <a name="input_purview_account_name"></a> [purview\_account\_name](#input\_purview\_account\_name)

Description: Specifies the name of the Purview account.

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

### <a name="input_private_dns_zone_id_blob"></a> [private\_dns\_zone\_id\_blob](#input\_private\_dns\_zone\_id\_blob)

Description: Specifies the resource ID of the private DNS zone for Azure Storage blob endpoints. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_purview_platform"></a> [private\_dns\_zone\_id\_purview\_platform](#input\_private\_dns\_zone\_id\_purview\_platform)

Description: Specifies the resource ID of the private DNS zone for Azure Key Vault. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_queue"></a> [private\_dns\_zone\_id\_queue](#input\_private\_dns\_zone\_id\_queue)

Description: Specifies the resource ID of the private DNS zone for Azure Storage queue endpoints. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_purview_account_root_collection_admins"></a> [purview\_account\_root\_collection\_admins](#input\_purview\_account\_root\_collection\_admins)

Description: Specifies the root collection admins of the Purview account.

Type:

```hcl
map(object({
    object_id = string
  }))
```

Default: `{}`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_purview_account_endpoints_catalog"></a> [purview\_account\_endpoints\_catalog](#output\_purview\_account\_endpoints\_catalog)

Description: Specifies the purview account catalog endpoint.

### <a name="output_purview_account_endpoints_scan"></a> [purview\_account\_endpoints\_scan](#output\_purview\_account\_endpoints\_scan)

Description: Specifies the purview account scan endpoint.

### <a name="output_purview_account_id"></a> [purview\_account\_id](#output\_purview\_account\_id)

Description: Specifies the purview account id.

### <a name="output_purview_account_ingestion_storage_id"></a> [purview\_account\_ingestion\_storage\_id](#output\_purview\_account\_ingestion\_storage\_id)

Description: Specifies the purview account ingestion storage id.

### <a name="output_purview_account_ingestion_storage_primary_endpoint"></a> [purview\_account\_ingestion\_storage\_primary\_endpoint](#output\_purview\_account\_ingestion\_storage\_primary\_endpoint)

Description: Specifies the purview account ingestion storage id.

### <a name="output_purview_account_name"></a> [purview\_account\_name](#output\_purview\_account\_name)

Description: Specifies the purview account name.

### <a name="output_purview_account_principal_id"></a> [purview\_account\_principal\_id](#output\_purview\_account\_principal\_id)

Description: Specifies the purview account name.

### <a name="output_purview_account_setup_completed"></a> [purview\_account\_setup\_completed](#output\_purview\_account\_setup\_completed)

Description: Specifies whether the connectivity and identity has been successfully configured.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->