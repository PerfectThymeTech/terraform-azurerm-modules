# 🔌 Azure Communication Service Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-communicationservice.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-communicationservice.yml)

Deploys an Azure Communication Services resource with optional diagnostic settings.

## 📦 Overview

- One Azure Communication Services resource (`azurerm_communication_service`) with the data location you choose in `communication_service_data_location`.
- Optional diagnostic settings.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- None. The module sets only the name, resource group, tags and data location; it has no private endpoint and no identity.
- The key and connection string outputs are marked sensitive.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- No security exceptions.
- The `location` input is required but not used by any resource in the module.

**Prerequisites**

- Each `diagnostics_configurations` entry needs a Log Analytics workspace identifier (ID), a storage account ID, or both.

## 🚀 Usage

```hcl
module "communication_service" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/communicationservice?ref=<release-tag>"

  location                  = "<azure-region>"
  resource_group_name       = "<resource-group-name>"
  communication_service_name = "<communication-service-name>"
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).
