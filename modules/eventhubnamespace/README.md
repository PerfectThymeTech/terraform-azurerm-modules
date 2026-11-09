<!-- BEGIN_TF_DOCS -->
# 🔌 Azure Event Hub Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-eventhubnamespace.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-eventhubnamespace.yml)

Deploys an Azure Event Hubs namespace with public access disabled, a private endpoint, event hubs and namespace authorization rules.

## 📦 Overview

- An Event Hubs namespace (`azurerm_eventhub_namespace`) with a system-assigned managed identity.
- The event hubs you list in `event_hubs` and the namespace authorization rules you list in `eventhub_namespace_authorization_rules`.
- A private endpoint for the `namespace` subresource and optional diagnostic settings.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Public network access is disabled (hard-coded), and the IP and virtual network rule lists are empty.
- Local (key-based) authentication is off (`event_hub_namespace_local_authentication_enabled` defaults to `false`).
- The minimum TLS version is 1.2.
- The namespace uses a system-assigned managed identity.
- The private endpoint uses automatic approval.
- Authorization rules default to listen only (`listen = true`, `manage = false`, `send = false`).
- The default key and connection string outputs are marked sensitive.
- Diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- `event_hub_namespace_local_authentication_enabled = true` enables local authentication, and each authorization rule can set `manage` or `send` to `true`.
- The network rule set has `default_action = "Allow"` (hard-coded). A code comment states that azurerm 5.3 and later reject `Deny` without rules and that the setting is inert while public access is disabled.
- `trusted_service_access_enabled = true` is hard-coded.
- Known issue: `customer_managed_key` is declared and validated but no resource uses it, so no customer-managed key is applied.
- Known issue: `event_hub_namespace_dedicated_cluster_id` is declared as `bool` although its description and validation treat it as a resource ID.
- Known issue: the private endpoint, NIC and service connection names contain `datafactory`.

**Prerequisites**

- `subnet_id`: the resource ID of the subnet for the private endpoint.
- Optional `private_dns_zone_id_servicebus` ending in `privatelink.servicebus.windows.net`. It is not required when DNS A-records are created through Azure Policy.

## 🚀 Usage

```hcl
module "eventhub_namespace" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/eventhubnamespace?ref=<release-tag>"

  location                                    = "<azure-region>"
  resource_group_name                         = "<resource-group-name>"
  event_hub_namespace_name                    = "<event-hub-namespace-name>"
  event_hub_namespace_sku                     = "Standard"
  event_hub_namespace_maximum_throughput_units = 1
  subnet_id                                   = "<subnet-resource-id>"

  event_hubs = {
    "<event-hub-name>" = {}
  }

  eventhub_namespace_authorization_rules = {
    "<authorization-rule-name>" = {}
  }
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).

## 📚 Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>=0.12)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 5.0)

- <a name="requirement_time"></a> [time](#requirement\_time) (~> 0.9)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 5.0)

- <a name="provider_time"></a> [time](#provider\_time) (~> 0.9)

## Resources

The following resources are used by this module:

- [azurerm_eventhub.eventhub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub) (resource)
- [azurerm_eventhub_namespace.eventhub_namespace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace) (resource)
- [azurerm_eventhub_namespace_authorization_rule.eventhub_namespace_authorization_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace_authorization_rule) (resource)
- [azurerm_monitor_diagnostic_setting.diagnostic_setting_eventhub_namespace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_private_endpoint.private_endpoint_eventhub_namespace_namespace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [time_sleep.sleep_connectivity](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_monitor_diagnostic_categories.diagnostic_categories_eventhub_namespace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) (data source)

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