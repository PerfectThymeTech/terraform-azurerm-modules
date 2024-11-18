<!-- BEGIN_TF_DOCS -->
# Azure Synapse Private Link Hub Terraform Module

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

### <a name="input_location"></a> [location](#input\_location)

Description: Specifies the location of all resources.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: Specifies the resource group name in which all resources will get deployed.

Type: `string`

### <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id)

Description: Specifies the resource id of a subnet in which the private endpoints get created.

Type: `string`

### <a name="input_synapse_private_link_hub_name"></a> [synapse\_private\_link\_hub\_name](#input\_synapse\_private\_link\_hub\_name)

Description: Specifies the name of the synapse private link hub.

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

### <a name="input_private_dns_zone_id_synapse_portal"></a> [private\_dns\_zone\_id\_synapse\_portal](#input\_private\_dns\_zone\_id\_synapse\_portal)

Description: Specifies the resource ID of the private DNS zone for Synapse PL Hub. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_synapse_private_link_hub_id"></a> [synapse\_private\_link\_hub\_id](#output\_synapse\_private\_link\_hub\_id)

Description: Specifies the key vault resource id.

### <a name="output_synapse_private_link_hub_name"></a> [synapse\_private\_link\_hub\_name](#output\_synapse\_private\_link\_hub\_name)

Description: Specifies the key vault resource name.

### <a name="output_synapse_private_link_hub_setup_completed"></a> [synapse\_private\_link\_hub\_setup\_completed](#output\_synapse\_private\_link\_hub\_setup\_completed)

Description: Specifies whether the connectivity and identity has been successfully configured.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->