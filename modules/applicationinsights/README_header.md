# 📈 Azure Application Insights Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-applicationinsights.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-applicationinsights.yml)

Deploys an Azure Application Insights component linked to a Log Analytics workspace, with optional diagnostic settings.

## 📦 Overview

- One Application Insights component (`azurerm_application_insights`) linked to the workspace in `application_insights_log_analytics_workspace_id`.
- Optional diagnostic settings that enable every log category group and metric the service offers.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Internet Protocol (IP) masking is enabled.
- The instrumentation key and connection string outputs are marked sensitive.
- Diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- Internet ingestion and internet query are enabled by default (`application_insights_internet_ingestion_enabled` and `application_insights_internet_query_enabled` default to `true`). *Reason:* not stated in the module code. *Mitigation:* set both to `false` and use an Azure Monitor private link scope outside this module.
- Local authentication stays enabled unless `application_insights_local_authentication_disabled` is set to `true` (default `false`). *Reason:* not stated in the module code. *Mitigation:* set it to `true` and use Microsoft Entra ID authentication for ingestion.
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
