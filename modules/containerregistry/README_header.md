# 🖥️ Azure Container Registry Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-containerregistry.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-containerregistry.yml)

Deploys a Premium Azure Container Registry that is reachable only through a private endpoint, with optional customer-managed key and diagnostic settings.

## 📦 Overview

- One container registry (`azurerm_container_registry`, SKU (pricing tier) `Premium`).
- A private endpoint for the `registry` subresource and a wait of `connectivity_delay_in_seconds` after it (default `120`).
- Optional diagnostic settings and optional customer-managed key encryption.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Public network access is disabled and the network rule set denies by default with no Internet Protocol (IP) rules.
- The admin account is disabled (`container_registry_admin_enabled` defaults to `false`).
- Anonymous pull is disabled (`container_registry_anonymous_pull_enabled` defaults to `false`).
- The private endpoint is always created with automatic approval.
- The registry uses a system-assigned managed identity (plus a user-assigned identity when `customer_managed_key` is set).
- Customer-managed key (`customer_managed_key`) and diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- `container_registry_admin_enabled = true` enables the admin account, and `container_registry_anonymous_pull_enabled = true` enables anonymous pull. *Reason:* not stated in the module code. *Mitigation:* keep both `false` and use Microsoft Entra ID and managed identities to pull images.
- The network rule bypass option is hard-coded to `AzureServices`; there is no variable to change it. *Reason:* not stated in the module code. *Mitigation:* limit what trusted Azure services can do with Azure role-based access control.
- Known issue: `customer_managed_key` requires and validates `key_vault_id` and `key_vault_key_id`, but only `key_vault_key_versionless_id`, `user_assigned_identity_id` and `user_assigned_identity_client_id` are used. The module creates no role assignment.

**Prerequisites**

- `subnet_id`: the resource ID of the subnet for the private endpoint.
- Optional `private_dns_zone_id_container_registry` ending in `privatelink.azurecr.io`. It is not required when Domain Name System (DNS) A-records are created through Azure Policy.

## 🚀 Usage

```hcl
module "container_registry" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/containerregistry?ref=<release-tag>"

  location                = "<azure-region>"
  resource_group_name     = "<resource-group-name>"
  container_registry_name = "<containerregistryname>"
  subnet_id               = "<subnet-resource-id>"
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).
