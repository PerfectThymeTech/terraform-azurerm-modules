# 🖥️ Azure App Service Plan Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-appserviceplan.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-appserviceplan.yml)

Deploys an Azure App Service plan with configurable SKU (pricing tier), operating system and worker count, with optional diagnostic settings.

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
- Each `diagnostics_configurations` entry needs a Log Analytics workspace identifier (ID), a storage account ID, or both.

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
