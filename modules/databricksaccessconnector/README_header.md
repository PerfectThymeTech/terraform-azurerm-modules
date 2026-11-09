# 📊 Azure Databricks Access Connector Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-databricksaccessconnector.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-databricksaccessconnector.yml)

Deploys an Azure Databricks access connector with a system-assigned managed identity.

## 📦 Overview

- One Azure Databricks access connector (`azurerm_databricks_access_connector`).
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- The connector uses a system-assigned managed identity.
- The `databricks_access_connector_principal_id` output is marked sensitive.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- No security exceptions.

**Prerequisites**

- An existing resource group.

## 🚀 Usage

```hcl
module "databricks_access_connector" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/databricksaccessconnector?ref=<release-tag>"

  location                         = "<azure-region>"
  resource_group_name              = "<resource-group-name>"
  databricks_access_connector_name = "<access-connector-name>"
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).
