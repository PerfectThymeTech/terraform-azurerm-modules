# 📊 Azure Databricks Workspace Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-databricksworkspace.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-databricksworkspace.yml)

Deploys a premium Azure Databricks workspace that is injected into a virtual network, without public access, with private endpoints and optional customer-managed keys.

## 📦 Overview

- An Azure Databricks workspace (`azurerm_databricks_workspace`, SKU (pricing tier) `premium`) injected into an existing virtual network.
- Private endpoints for the user interface (UI) and application programming interface (API), the Databricks File System (DBFS) `blob` and the DBFS `dfs` endpoints, and optionally for browser authentication.
- Optional diagnostic settings and, when `customer_managed_key` is set, customer-managed keys for managed disks, managed services and root DBFS with the required role assignments.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Public network access is disabled; no variable changes it.
- Clusters have no public Internet Protocol (IP) address and the workspace requires no Azure Databricks network security group rules.
- Infrastructure encryption and the DBFS storage firewall are enabled.
- Enhanced security and compliance is on: automatic cluster update, compliance security profile and enhanced security monitoring.
- Private endpoints for UI and API, DBFS `blob` and DBFS `dfs` are always created with automatic approval.
- Customer-managed keys (`customer_managed_key`) and diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- No input relaxes the network or encryption defaults. The browser authentication private endpoint is only created when `databricks_workspace_browser_authentication_private_endpoint_enabled` is `true` (default `false`).
- Known issue: `customer_managed_key` requires and validates `key_vault_key_versionless_id`, `user_assigned_identity_id` and `user_assigned_identity_client_id`, but no resource uses them. Only `key_vault_id` and `key_vault_key_id` are used.

**Prerequisites**

- An existing virtual network with a private and a public subnet (by name) and their network security group association identifiers (IDs).
- An existing Azure Databricks access connector: `databricks_workspace_access_connector_id`.
- `subnet_id` for the private endpoints; optional `location_private_endpoint` when they must reside in another region.
- Optional private Domain Name System (DNS) zone IDs ending in `privatelink.azuredatabricks.net`, `privatelink.blob.core.windows.net` and `privatelink.dfs.core.windows.net`. They are not required when DNS A-records are created through Azure Policy.
- With `customer_managed_key` the module creates role assignments at the Key Vault scope, so the deploying identity must be allowed to create them.

## 🚀 Usage

```hcl
module "databricks_workspace" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/databricksworkspace?ref=<release-tag>"

  location                                                                = "<azure-region>"
  resource_group_name                                                     = "<resource-group-name>"
  databricks_workspace_name                                               = "<workspace-name>"
  databricks_workspace_access_connector_id                                = "<access-connector-resource-id>"
  databricks_workspace_virtual_network_id                                 = "<virtual-network-resource-id>"
  databricks_workspace_private_subnet_name                                = "<private-subnet-name>"
  databricks_workspace_private_subnet_network_security_group_association_id = "<private-subnet-nsg-association-resource-id>"
  databricks_workspace_public_subnet_name                                 = "<public-subnet-name>"
  databricks_workspace_public_subnet_network_security_group_association_id  = "<public-subnet-nsg-association-resource-id>"
  subnet_id                                                               = "<subnet-resource-id>"
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).
