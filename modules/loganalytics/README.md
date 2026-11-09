<!-- BEGIN_TF_DOCS -->
# 📈 Azure Log Analytics Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-loganalytics.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-loganalytics.yml)

Deploys an Azure Log Analytics workspace with optional diagnostic settings.

## 📦 Overview

- One Log Analytics workspace (`azurerm_log_analytics_workspace`, SKU (pricing tier) `PerGB2018`).
- Optional diagnostic settings that enable every log category group and metric the service offers.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Local authentication is disabled (hard-coded).
- Diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- Internet ingestion and internet query access are hard-coded to `Enabled`. No variable overrides them and no code comment gives a reason. *Reason:* not stated in the module code. *Mitigation:* use an Azure Monitor private link scope outside this module and control who can query with Azure role-based access control.
- The module has no private endpoint and no network variables.

**Prerequisites**

- Each `diagnostics_configurations` entry needs a Log Analytics workspace ID, a storage account ID, or both.

## 🚀 Usage

```hcl
module "log_analytics" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/loganalytics?ref=<release-tag>"

  location                     = "<azure-region>"
  resource_group_name          = "<resource-group-name>"
  log_analytics_workspace_name = "<log-analytics-workspace-name>"
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

- [azurerm_log_analytics_workspace.log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) (resource)
- [azurerm_monitor_diagnostic_setting.diagnostic_setting_log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_monitor_diagnostic_categories.diagnostic_categories_log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) (data source)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input\_location)

Description: Specifies the location of all resources.

Type: `string`

### <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name)

Description: Specifies the name of the log analytics workspace.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: Specifies the resource group name in which all resources will get deployed.

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

### <a name="input_log_analytics_workspace_retention_in_days"></a> [log\_analytics\_workspace\_retention\_in\_days](#input\_log\_analytics\_workspace\_retention\_in\_days)

Description: Specifies the retention in days for the log analytics workspace.

Type: `number`

Default: `30`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#output\_log\_analytics\_workspace\_id)

Description: Specifies the resource ID of the log analytics workspace.

### <a name="output_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#output\_log\_analytics\_workspace\_name)

Description: Specifies the name of the log analytics workspace.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->