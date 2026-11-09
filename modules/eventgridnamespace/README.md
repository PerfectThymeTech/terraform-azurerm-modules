<!-- BEGIN_TF_DOCS -->
# 🔌 Azure Event Grid Namespace Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-eventgridnamespace.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-eventgridnamespace.yml)

Deploys an Azure Event Grid namespace with public access disabled, a private endpoint and optional namespace topics.

## 📦 Overview

- An Event Grid namespace (`azurerm_eventgrid_namespace`) with a system-assigned managed identity.
- Optional namespace topics deployed through the `azapi` provider.
- A private endpoint for the `topic` subresource and optional diagnostic settings.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Public network access is disabled (hard-coded); no variable changes it.
- The namespace uses a system-assigned managed identity.
- The private endpoint uses automatic approval.
- Diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- No security exceptions.

**Prerequisites**

- `subnet_id`: the resource ID of the subnet for the private endpoint.
- Optional `private_dns_zone_id_topic` ending in `privatelink.eventgrid.azure.net`. It is not required when DNS A-records are created through Azure Policy.
- The `azapi` provider (`~> 2.0`) in addition to `azurerm` and `time`, and Terraform `>=1.3`.

## 🚀 Usage

```hcl
module "eventgrid_namespace" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/eventgridnamespace?ref=<release-tag>"

  location                 = "<azure-region>"
  resource_group_name      = "<resource-group-name>"
  eventgrid_namespace_name = "<eventgrid-namespace-name>"
  subnet_id                = "<subnet-resource-id>"
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).

## 📚 Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>=1.3)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (~> 2.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 5.0)

- <a name="requirement_time"></a> [time](#requirement\_time) (~> 0.9)

## Providers

The following providers are used by this module:

- <a name="provider_azapi"></a> [azapi](#provider\_azapi) (~> 2.0)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 5.0)

- <a name="provider_time"></a> [time](#provider\_time) (~> 0.9)

## Resources

The following resources are used by this module:

- [azapi_resource.eventgrid_namespace_topics](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) (resource)
- [azurerm_eventgrid_namespace.eventgrid_namespace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventgrid_namespace) (resource)
- [azurerm_monitor_diagnostic_setting.diagnostic_setting_eventgrid_namespace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_private_endpoint.private_endpoint_topic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [time_sleep.sleep_connectivity](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_monitor_diagnostic_categories.diagnostic_categories_eventgrid_namespace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) (data source)

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
    event_retention_in_days = optional(number, 1)
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