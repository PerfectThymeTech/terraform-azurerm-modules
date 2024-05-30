<!-- BEGIN_TF_DOCS -->
# Azure AI Services Terraform Module

## Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>=0.12)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.50.0)

- <a name="requirement_time"></a> [time](#requirement\_time) (>= 0.9.1)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_cognitive_account_kind"></a> [cognitive\_account\_kind](#input\_cognitive\_account\_kind)

Description: Specifies the kind of the cognitive service.

Type: `string`

### <a name="input_cognitive_account_name"></a> [cognitive\_account\_name](#input\_cognitive\_account\_name)

Description: Specifies the name of the cognitive service.

Type: `string`

### <a name="input_cognitive_account_sku"></a> [cognitive\_account\_sku](#input\_cognitive\_account\_sku)

Description: Specifies the sku of the cognitive service.

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

### <a name="input_cognitive_account_deployments"></a> [cognitive\_account\_deployments](#input\_cognitive\_account\_deployments)

Description: Specifies the models that should be deployed within your ai service. Only applicable to ai services of kind openai.

Type:

```hcl
map(object({
    model_name        = string
    model_version     = string
    model_api_version = optional(string, "2024-02-15-preview")
    scale_type        = optional(string, "Standard")
    scale_tier        = optional(string, "Standard")
    scale_size        = optional(string, null)
    scale_family      = optional(string, null)
    scale_capacity    = optional(number, 1)
  }))
```

Default: `{}`

### <a name="input_cognitive_account_outbound_network_access_allowed_fqdns"></a> [cognitive\_account\_outbound\_network\_access\_allowed\_fqdns](#input\_cognitive\_account\_outbound\_network\_access\_allowed\_fqdns)

Description: Specifies the outbound network allowed fqdns of the cognitive service.

Type: `list(string)`

Default: `[]`

### <a name="input_cognitive_account_outbound_network_access_restricted"></a> [cognitive\_account\_outbound\_network\_access\_restricted](#input\_cognitive\_account\_outbound\_network\_access\_restricted)

Description: Specifies the outbound network restrictions of the cognitive service.

Type: `bool`

Default: `true`

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

### <a name="input_private_dns_zone_id_cognitive_account"></a> [private\_dns\_zone\_id\_cognitive\_account](#input\_private\_dns\_zone\_id\_cognitive\_account)

Description: Specifies the resource ID of the private DNS zone for Azure Cognitive Services. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_cognitive_account_endpoint"></a> [cognitive\_account\_endpoint](#output\_cognitive\_account\_endpoint)

Description: The base URL of the cognitive service account.

### <a name="output_cognitive_account_id"></a> [cognitive\_account\_id](#output\_cognitive\_account\_id)

Description: The ID of the cognitive service account.

### <a name="output_cognitive_account_setup_completed"></a> [cognitive\_account\_setup\_completed](#output\_cognitive\_account\_setup\_completed)

Description: Specifies whether the connectivity and identity has been successfully configured.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->