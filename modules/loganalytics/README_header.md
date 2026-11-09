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
