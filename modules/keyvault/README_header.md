# 🔐 Azure Key Vault Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-keyvault.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-keyvault.yml)

Deploys a locked-down Azure Key Vault with role-based access control (RBAC) authorization, a private endpoint and a role assignment for the identity that runs Terraform.

## 📦 Overview

- An Azure Key Vault (`azurerm_key_vault`).
- A private endpoint for the `vault` subresource and optional diagnostic settings.
- A *Key Vault Administrator* role assignment on the vault for the identity that runs Terraform.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Public network access is disabled; no variable changes it.
- The firewall denies by default and has no Internet Protocol (IP) or virtual network rules.
- Purge protection is enabled, and soft delete retention is set by `key_vault_soft_delete_retention_days` (default `7`, minimum `7`).
- Authorization uses Azure RBAC; access policies are not used.
- Access for deployment, disk encryption and template deployment is off.
- The private endpoint uses automatic approval.
- Diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- The firewall bypass is hard-coded to `AzureServices`. *Reason:* not stated in the module code. *Mitigation:* limit what trusted Azure services can do with Azure role-based access control.
- The role assignment *Key Vault Administrator* for the identity running Terraform is always created. No variable disables it. *Reason:* not stated in the module code. *Mitigation:* limit who can run Terraform, because that identity becomes Key Vault Administrator.

**Prerequisites**

- `subnet_id`: the resource identifier (ID) of the subnet for the private endpoint.
- Optional `private_dns_zone_id_vault` ending in `privatelink.vaultcore.azure.net`. It is not required when Domain Name System (DNS) A-records are created through Azure Policy.
- The identity that runs Terraform must be allowed to create the role assignment on the vault.

## 🚀 Usage

```hcl
module "key_vault" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/keyvault?ref=<release-tag>"

  location            = "<azure-region>"
  resource_group_name = "<resource-group-name>"
  key_vault_name      = "<key-vault-name>"
  subnet_id           = "<subnet-resource-id>"
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).
