<!-- BEGIN_TF_DOCS -->
# Azure Bot Service Terraform Module

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

### <a name="input_bot_service_application_insights_id"></a> [bot\_service\_application\_insights\_id](#input\_bot\_service\_application\_insights\_id)

Description: Specifies the application insights id to be used for the bot service.

Type: `string`

### <a name="input_bot_service_endpoint"></a> [bot\_service\_endpoint](#input\_bot\_service\_endpoint)

Description: Specifies the endpoint of the bot service.

Type: `string`

### <a name="input_bot_service_microsoft_app"></a> [bot\_service\_microsoft\_app](#input\_bot\_service\_microsoft\_app)

Description: Specifies the microsoft app details of the bot service.

Type:

```hcl
object({
    app_id        = string
    app_msi_id    = string
    app_tenant_id = string
    app_type      = string
  })
```

### <a name="input_bot_service_name"></a> [bot\_service\_name](#input\_bot\_service\_name)

Description: Specifies the name of the bot service.

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

### <a name="input_bot_service_icon_url"></a> [bot\_service\_icon\_url](#input\_bot\_service\_icon\_url)

Description: Specifies the icon url of the bot service.

Type: `string`

Default: `"https://docs.botframework.com/static/devportal/client/images/bot-framework-default.png"`

### <a name="input_bot_service_location"></a> [bot\_service\_location](#input\_bot\_service\_location)

Description: Specifies the location of the bot service.

Type: `string`

Default: `"global"`

### <a name="input_bot_service_luis"></a> [bot\_service\_luis](#input\_bot\_service\_luis)

Description: Specifies the luis app details of the bot service.

Type:

```hcl
object({
    app_ids = optional(list(string), []),
    key     = optional(string, null)
  })
```

Default:

```json
{
  "app_ids": [],
  "key": null
}
```

### <a name="input_bot_service_public_network_access_enabled"></a> [bot\_service\_public\_network\_access\_enabled](#input\_bot\_service\_public\_network\_access\_enabled)

Description: Specifies whether public network access should be enabled for the bot service.

Type: `bool`

Default: `false`

### <a name="input_bot_service_sku"></a> [bot\_service\_sku](#input\_bot\_service\_sku)

Description: Specifies the sku of the bot service.

Type: `string`

Default: `"S1"`

### <a name="input_bot_service_streaming_endpoint_enabled"></a> [bot\_service\_streaming\_endpoint\_enabled](#input\_bot\_service\_streaming\_endpoint\_enabled)

Description: Specifies whether the streaming endpoint should be enabled for the bot service.

Type: `bool`

Default: `false`

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

### <a name="input_private_dns_zone_id_bot_framework_directline"></a> [private\_dns\_zone\_id\_bot\_framework\_directline](#input\_private\_dns\_zone\_id\_bot\_framework\_directline)

Description: Specifies the resource ID of the private DNS zone for the bot framework directline. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_bot_framework_token"></a> [private\_dns\_zone\_id\_bot\_framework\_token](#input\_private\_dns\_zone\_id\_bot\_framework\_token)

Description: Specifies the resource ID of the private DNS zone for the bot framework token. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_bot_service_id"></a> [bot\_service\_id](#output\_bot\_service\_id)

Description: Specifies the resource id of the bot service.

### <a name="output_bot_service_setup_completed"></a> [bot\_service\_setup\_completed](#output\_bot\_service\_setup\_completed)

Description: Specifies whether the connectivity and identity has been successfully configured.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->