<!-- BEGIN_TF_DOCS -->
# Azure AI Foundry (Basic) Terraform Module

## Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>=0.12)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (~> 2.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.17)

- <a name="requirement_time"></a> [time](#requirement\_time) (~> 0.9)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_ai_services_name"></a> [ai\_services\_name](#input\_ai\_services\_name)

Description: Specifies the name of the cognitive service.

Type: `string`

### <a name="input_ai_services_sku"></a> [ai\_services\_sku](#input\_ai\_services\_sku)

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

### <a name="input_ai_services_deployments"></a> [ai\_services\_deployments](#input\_ai\_services\_deployments)

Description: Specifies the models that should be deployed within your ai service. Only applicable to ai services of kind openai.

Type:

```hcl
map(object({
    model_name        = string
    model_version     = string
    model_api_version = optional(string, "2024-02-15-preview")
    sku_name          = optional(string, "Standard")
    sku_tier          = optional(string, "Standard")
    sku_size          = optional(string, null)
    sku_family        = optional(string, null)
    sku_capacity      = optional(number, 1)
  }))
```

Default: `{}`

### <a name="input_ai_services_firewall_bypass_azure_services"></a> [ai\_services\_firewall\_bypass\_azure\_services](#input\_ai\_services\_firewall\_bypass\_azure\_services)

Description: Specifies whether Azure Services should be allowed to bypass the firewall of the cognitive service. This is required for some common integration sceanrios but not supported by all ai services.

Type: `bool`

Default: `false`

### <a name="input_ai_services_local_auth_enabled"></a> [ai\_services\_local\_auth\_enabled](#input\_ai\_services\_local\_auth\_enabled)

Description: Specifies whether key-based acces should be enabled for the cognitive service.

Type: `bool`

Default: `false`

### <a name="input_ai_services_outbound_network_access_allowed_fqdns"></a> [ai\_services\_outbound\_network\_access\_allowed\_fqdns](#input\_ai\_services\_outbound\_network\_access\_allowed\_fqdns)

Description: Specifies the outbound network allowed fqdns of the cognitive service.

Type: `list(string)`

Default: `[]`

### <a name="input_ai_services_outbound_network_access_restricted"></a> [ai\_services\_outbound\_network\_access\_restricted](#input\_ai\_services\_outbound\_network\_access\_restricted)

Description: Specifies the outbound network restrictions of the cognitive service.

Type: `bool`

Default: `true`

### <a name="input_ai_services_projects"></a> [ai\_services\_projects](#input\_ai\_services\_projects)

Description: Specifies the projects that should be deployed within your ai service.

Type:

```hcl
map(object({
    description  = optional(string, "")
    display_name = optional(string, "")
  }))
```

Default: `{}`

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

### <a name="input_location_private_endpoint"></a> [location\_private\_endpoint](#input\_location\_private\_endpoint)

Description: Specifies the location of the private endpoint. Use this variables only if the private endpoint(s) should reside in a different location than the service itself.

Type: `string`

Default: `null`

### <a name="input_private_dns_zone_id_ai_services"></a> [private\_dns\_zone\_id\_ai\_services](#input\_private\_dns\_zone\_id\_ai\_services)

Description: Specifies the resource ID of the private DNS zone for Azure Foundry (AI Services). Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_cognitive_account"></a> [private\_dns\_zone\_id\_cognitive\_account](#input\_private\_dns\_zone\_id\_cognitive\_account)

Description: Specifies the resource ID of the private DNS zone for Azure Cognitive Services. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_open_ai"></a> [private\_dns\_zone\_id\_open\_ai](#input\_private\_dns\_zone\_id\_open\_ai)

Description: Specifies the resource ID of the private DNS zone for Azure Open AI. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_ai_services_endpoint"></a> [ai\_services\_endpoint](#output\_ai\_services\_endpoint)

Description: The base URL of the cognitive service account.

### <a name="output_ai_services_id"></a> [ai\_services\_id](#output\_ai\_services\_id)

Description: The ID of the cognitive service account.

### <a name="output_ai_services_name"></a> [ai\_services\_name](#output\_ai\_services\_name)

Description: The name of the cognitive service account.

### <a name="output_ai_services_primary_access_key"></a> [ai\_services\_primary\_access\_key](#output\_ai\_services\_primary\_access\_key)

Description: The primary access key of the cognitive service account.

### <a name="output_ai_services_principal_id"></a> [ai\_services\_principal\_id](#output\_ai\_services\_principal\_id)

Description: The principal id of the cognitive service account.

### <a name="output_ai_services_setup_completed"></a> [ai\_services\_setup\_completed](#output\_ai\_services\_setup\_completed)

Description: Specifies whether the connectivity and identity has been successfully configured.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->