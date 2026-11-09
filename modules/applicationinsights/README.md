<!-- BEGIN_TF_DOCS -->
# 📈 Azure Application Insights Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-applicationinsights.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-applicationinsights.yml)

Deploys an Azure Application Insights component linked to a Log Analytics workspace, with optional diagnostic settings.

## 📦 Overview

- One Application Insights component (`azurerm_application_insights`) linked to the workspace in `application_insights_log_analytics_workspace_id`.
- Optional diagnostic settings that enable every log category group and metric the service offers.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- IP masking is enabled.
- The instrumentation key and connection string outputs are marked sensitive.
- Diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- Internet ingestion and internet query are enabled by default (`application_insights_internet_ingestion_enabled` and `application_insights_internet_query_enabled` default to `true`).
- Local authentication stays enabled unless `application_insights_local_authentication_disabled` is set to `true` (default `false`).
- The module has no private endpoint and no network variables.

**Prerequisites**

- An existing Log Analytics workspace: `application_insights_log_analytics_workspace_id`.
- Each `diagnostics_configurations` entry needs a Log Analytics workspace ID, a storage account ID, or both.

## 🚀 Usage

```hcl
module "application_insights" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/applicationinsights?ref=<release-tag>"

  location                                        = "<azure-region>"
  resource_group_name                             = "<resource-group-name>"
  application_insights_name                       = "<application-insights-name>"
  application_insights_log_analytics_workspace_id = "<log-analytics-workspace-resource-id>"
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

- [azurerm_application_insights.application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) (resource)
- [azurerm_monitor_diagnostic_setting.diagnostic_setting_application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_monitor_diagnostic_categories.diagnostic_categories_application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) (data source)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_application_insights_log_analytics_workspace_id"></a> [application\_insights\_log\_analytics\_workspace\_id](#input\_application\_insights\_log\_analytics\_workspace\_id)

Description: Specifies the log analytics workspace of the application insights service.

Type: `string`

### <a name="input_application_insights_name"></a> [application\_insights\_name](#input\_application\_insights\_name)

Description: Specifies the name of the application insights service.

Type: `string`

### <a name="input_location"></a> [location](#input\_location)

Description: Specifies the location of all resources.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: Specifies the resource group name in which all resources will get deployed.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_application_insights_application_type"></a> [application\_insights\_application\_type](#input\_application\_insights\_application\_type)

Description: Specifies the application type of the application insights service.

Type: `string`

Default: `"web"`

### <a name="input_application_insights_internet_ingestion_enabled"></a> [application\_insights\_internet\_ingestion\_enabled](#input\_application\_insights\_internet\_ingestion\_enabled)

Description: Specifies whether internet ingestion is enabled for the application insights service.

Type: `bool`

Default: `true`

### <a name="input_application_insights_internet_query_enabled"></a> [application\_insights\_internet\_query\_enabled](#input\_application\_insights\_internet\_query\_enabled)

Description: Specifies whether internet query is enabled for the application insights service.

Type: `bool`

Default: `true`

### <a name="input_application_insights_local_authentication_disabled"></a> [application\_insights\_local\_authentication\_disabled](#input\_application\_insights\_local\_authentication\_disabled)

Description: Specifies whether local authentication is disabled for the application insights service.

Type: `bool`

Default: `false`

### <a name="input_application_insights_retention_in_days"></a> [application\_insights\_retention\_in\_days](#input\_application\_insights\_retention\_in\_days)

Description: Specifies the retention in days for the application insights service.

Type: `number`

Default: `90`

### <a name="input_application_insights_sampling_percentage"></a> [application\_insights\_sampling\_percentage](#input\_application\_insights\_sampling\_percentage)

Description: Specifies the sampling percentage for the application insights service.

Type: `number`

Default: `100`

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

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_application_insights_connection_string"></a> [application\_insights\_connection\_string](#output\_application\_insights\_connection\_string)

Description: Specifies the connection string of application insights.

### <a name="output_application_insights_id"></a> [application\_insights\_id](#output\_application\_insights\_id)

Description: Specifies the resource ID of application insights.

### <a name="output_application_insights_instrumentation_key"></a> [application\_insights\_instrumentation\_key](#output\_application\_insights\_instrumentation\_key)

Description: Specifies the instrumentation key of application insights.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->