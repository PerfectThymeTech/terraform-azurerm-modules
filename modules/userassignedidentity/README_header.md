# 🔐 Azure User Assigned Identity Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-userassignedidentity.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-userassignedidentity.yml)

Deploys an Azure user-assigned managed identity with optional federated identity credentials.

## 📦 Overview

- One user-assigned managed identity (`azurerm_user_assigned_identity`).
- Optional federated identity credentials, one per entry in `user_assigned_identity_federated_identity_credentials`.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- None. The module only sets the name, location, resource group and tags.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- No security exceptions.

**Prerequisites**

- Each federated identity credential needs an `audience`, an `issuer` and a `subject`. They have no defaults and no validation.

## 🚀 Usage

```hcl
module "user_assigned_identity" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/userassignedidentity?ref=<release-tag>"

  location                    = "<azure-region>"
  resource_group_name         = "<resource-group-name>"
  user_assigned_identity_name = "<identity-name>"
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).
