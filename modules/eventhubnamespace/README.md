<!-- BEGIN_TF_DOCS -->
# Azure Event Hub Terraform Module

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

### <a name="input_event_hub_namespace_maximum_throughput_units"></a> [event\_hub\_namespace\_maximum\_throughput\_units](#input\_event\_hub\_namespace\_maximum\_throughput\_units)

Description: Specifies the maximum throughput units of the eventhub namespace.

Type: `number`

### <a name="input_event_hub_namespace_name"></a> [event\_hub\_namespace\_name](#input\_event\_hub\_namespace\_name)

Description: Specifies the name of the eventhub namespace.

Type: `string`

### <a name="input_event_hub_namespace_sku"></a> [event\_hub\_namespace\_sku](#input\_event\_hub\_namespace\_sku)

Description: Specifies the sku of the eventhub namespace.

Type: `string`

### <a name="input_event_hubs"></a> [event\_hubs](#input\_event\_hubs)

Description: Specifies the the eventhub details.

Type:

```hcl
map(object({
    partition_count   = optional(number, 1)
    message_retention = optional(number, 1)
  }))
```

### <a name="input_eventhub_namespace_authorization_rules"></a> [eventhub\_namespace\_authorization\_rules](#input\_eventhub\_namespace\_authorization\_rules)

Description: Specifies the the eventhub namespace authorization rules.

Type:

```hcl
map(object({
    listen = optional(bool, true)
    manage = optional(bool, false)
    send   = optional(bool, false)
  }))
```

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

### <a name="input_event_hub_namespace_auto_inflate_enabled"></a> [event\_hub\_namespace\_auto\_inflate\_enabled](#input\_event\_hub\_namespace\_auto\_inflate\_enabled)

Description: Specifies whether auto inflate should be enabled for the eventhub namespace.

Type: `bool`

Default: `true`

### <a name="input_event_hub_namespace_capacity"></a> [event\_hub\_namespace\_capacity](#input\_event\_hub\_namespace\_capacity)

Description: Specifies the capacity of the eventhub namespace.

Type: `number`

Default: `2`

### <a name="input_event_hub_namespace_dedicated_cluster_id"></a> [event\_hub\_namespace\_dedicated\_cluster\_id](#input\_event\_hub\_namespace\_dedicated\_cluster\_id)

Description: Specifies the resource id of the dedicated cluster.

Type: `bool`

Default: `null`

### <a name="input_event_hub_namespace_local_authentication_enabled"></a> [event\_hub\_namespace\_local\_authentication\_enabled](#input\_event\_hub\_namespace\_local\_authentication\_enabled)

Description: Specifies whether local authentication should be enabled for the eventhub namespace.

Type: `bool`

Default: `false`

### <a name="input_private_dns_zone_id_servicebus"></a> [private\_dns\_zone\_id\_servicebus](#input\_private\_dns\_zone\_id\_servicebus)

Description: Specifies the resource ID of the private DNS zone for Azure service bus endpoints. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_eventhub_namespace_default_primary_connection_string"></a> [eventhub\_namespace\_default\_primary\_connection\_string](#output\_eventhub\_namespace\_default\_primary\_connection\_string)

Description: Specifies the default primary connection string of the eventhub namespace.

### <a name="output_eventhub_namespace_default_primary_connection_string_alias"></a> [eventhub\_namespace\_default\_primary\_connection\_string\_alias](#output\_eventhub\_namespace\_default\_primary\_connection\_string\_alias)

Description: Specifies the default primary connection string alias of the eventhub namespace.

### <a name="output_eventhub_namespace_default_primary_key"></a> [eventhub\_namespace\_default\_primary\_key](#output\_eventhub\_namespace\_default\_primary\_key)

Description: Specifies the default primary key of the eventhub namespace.

### <a name="output_eventhub_namespace_default_secondary_connection_string"></a> [eventhub\_namespace\_default\_secondary\_connection\_string](#output\_eventhub\_namespace\_default\_secondary\_connection\_string)

Description: Specifies the default secondary connection string of the eventhub namespace.

### <a name="output_eventhub_namespace_default_secondary_connection_string_alias"></a> [eventhub\_namespace\_default\_secondary\_connection\_string\_alias](#output\_eventhub\_namespace\_default\_secondary\_connection\_string\_alias)

Description: Specifies the default secondary connection string alias of the eventhub namespace.

### <a name="output_eventhub_namespace_default_secondary_key"></a> [eventhub\_namespace\_default\_secondary\_key](#output\_eventhub\_namespace\_default\_secondary\_key)

Description: Specifies the default secondary key of the eventhub namespace.

### <a name="output_eventhub_namespace_id"></a> [eventhub\_namespace\_id](#output\_eventhub\_namespace\_id)

Description: Specifies the resource id of the eventhub namespace.

### <a name="output_eventhub_namespace_name"></a> [eventhub\_namespace\_name](#output\_eventhub\_namespace\_name)

Description: Specifies the resource name of the eventhub namespace.

### <a name="output_eventhub_namespace_principal_id"></a> [eventhub\_namespace\_principal\_id](#output\_eventhub\_namespace\_principal\_id)

Description: Specifies the principal id of the eventhub namespace.

### <a name="output_eventhub_namespace_setup_completed"></a> [eventhub\_namespace\_setup\_completed](#output\_eventhub\_namespace\_setup\_completed)

Description: Specifies whether the connectivity and identity has been successfully configured.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->