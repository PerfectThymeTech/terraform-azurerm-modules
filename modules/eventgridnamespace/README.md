<!-- BEGIN_TF_DOCS -->
# Azure Event Grid Namespace Terraform Module

## Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>=0.12)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (~> 2.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.42)

- <a name="requirement_time"></a> [time](#requirement\_time) (~> 0.9)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_eventgrid_namespace_name"></a> [eventgrid\_namespace\_name](#input\_eventgrid\_namespace\_name)

Description: Specifies the name of the Event Grid Namespace. Changing this forces a new resource to be created.

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

### <a name="input_eventgrid_namespace_capacity"></a> [eventgrid\_namespace\_capacity](#input\_eventgrid\_namespace\_capacity)

Description: Specifies the capacity of the Event Grid Namespace. This value can be between 1 and 40.

Type: `number`

Default: `1`

### <a name="input_eventgrid_namespace_sku"></a> [eventgrid\_namespace\_sku](#input\_eventgrid\_namespace\_sku)

Description: Specifies the name of the SKU used for the event grid namespace. Possible values are standard.

Type: `string`

Default: `"Standard"`

### <a name="input_eventgrid_topics"></a> [eventgrid\_topics](#input\_eventgrid\_topics)

Description: Specifies the map of Event Grid Topics to be created within the namespace.

Type:

```hcl
map(object({
    event_retention_in_days = optional(int, 1)
    input_schema            = optional(string, "CloudEventSchemaV1_0")
    publisher_type          = optional(string, "Custom")
  }))
```

Default: `{}`

### <a name="input_private_dns_zone_id_topic"></a> [private\_dns\_zone\_id\_topic](#input\_private\_dns\_zone\_id\_topic)

Description: Specifies the resource ID of the private DNS zone for Azure Event Grid Namespace Topic. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_eventgrid_namespace_id"></a> [eventgrid\_namespace\_id](#output\_eventgrid\_namespace\_id)

Description: Specifies the Event Grid Namespace resource id.

### <a name="output_eventgrid_namespace_name"></a> [eventgrid\_namespace\_name](#output\_eventgrid\_namespace\_name)

Description: Specifies the Event Grid Namespace resource name.

### <a name="output_eventgrid_namespace_setup_completed"></a> [eventgrid\_namespace\_setup\_completed](#output\_eventgrid\_namespace\_setup\_completed)

Description: Specifies whether the connectivity and identity has been successfully configured.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->