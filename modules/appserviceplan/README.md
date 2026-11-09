<!-- BEGIN_TF_DOCS -->
# 🖥️ Azure App Service Plan Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-appserviceplan.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-appserviceplan.yml)

Deploys an Azure App Service plan with configurable SKU, operating system and worker count, with optional diagnostic settings.

## 📦 Overview

- One App Service plan (`azurerm_service_plan`).
- Optional diagnostic settings that enable every log category group and metric the service offers.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- None. The module has no network, identity or encryption settings.
- Diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- No security exceptions. Zone balancing is opt-in (`service_plan_zone_balancing_enabled` defaults to `false`), and the module has no private endpoint and no network variables.

**Prerequisites**

- Zone balancing can only be enabled with a worker count of 3 or more (stated in the variable description, not enforced by a validation).
- `service_plan_maximum_elastic_worker_count` can only be set for an elastic SKU.
- Each `diagnostics_configurations` entry needs a Log Analytics workspace ID, a storage account ID, or both.

## 🚀 Usage

```hcl
module "app_service_plan" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/appserviceplan?ref=<release-tag>"

  location            = "<azure-region>"
  resource_group_name = "<resource-group-name>"
  service_plan_name   = "<service-plan-name>"
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

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 5.0)

## Resources

The following resources are used by this module:

- [azurerm_monitor_diagnostic_setting.diagnostic_setting_service_plan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_service_plan.service_plan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) (resource)
- [azurerm_monitor_diagnostic_categories.diagnostic_categories_service_plan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) (data source)

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

### <a name="input_service_plan_name"></a> [service\_plan\_name](#input\_service\_plan\_name)

Description: Specifies the name of the app service plan.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

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

### <a name="input_service_plan_maximum_elastic_worker_count"></a> [service\_plan\_maximum\_elastic\_worker\_count](#input\_service\_plan\_maximum\_elastic\_worker\_count)

Description: Specifies the maximum elastic worker count of the app service plan. Can only be set for an elastic SKU.

Type: `string`

Default: `null`

### <a name="input_service_plan_os_type"></a> [service\_plan\_os\_type](#input\_service\_plan\_os\_type)

Description: Specifies the os type of the app service plan.

Type: `string`

Default: `"Linux"`

### <a name="input_service_plan_per_site_scaling_enabled"></a> [service\_plan\_per\_site\_scaling\_enabled](#input\_service\_plan\_per\_site\_scaling\_enabled)

Description: Specifies whether per site scaling should be enabled for the app service plan.

Type: `bool`

Default: `false`

### <a name="input_service_plan_sku_name"></a> [service\_plan\_sku\_name](#input\_service\_plan\_sku\_name)

Description: Specifies the sku name of the app service plan.

Type: `string`

Default: `"P0v3"`

### <a name="input_service_plan_worker_count"></a> [service\_plan\_worker\_count](#input\_service\_plan\_worker\_count)

Description: Specifies the worker count of the app service plan.

Type: `number`

Default: `1`

### <a name="input_service_plan_zone_balancing_enabled"></a> [service\_plan\_zone\_balancing\_enabled](#input\_service\_plan\_zone\_balancing\_enabled)

Description: Specifies whether zone balancing should be enabled for the app service plan. Can only be enabled if woker count is >= 3.

Type: `bool`

Default: `false`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_service_plan_id"></a> [service\_plan\_id](#output\_service\_plan\_id)

Description: Specifies the resource ID of the app service plan.

### <a name="output_service_plan_os_type"></a> [service\_plan\_os\_type](#output\_service\_plan\_os\_type)

Description: Specifies the os type of the app service plan.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->