# 📊 Azure Postgresql Flexible Server Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-postgresqlflexible.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-postgresqlflexible.yml)

Deploys a PostgreSQL flexible server with Microsoft Entra ID authentication only and private endpoint connectivity, plus optional databases and server parameters.

## 📦 Overview

- An Azure Database for PostgreSQL flexible server (`azurerm_postgresql_flexible_server`).
- Optional databases (`postgresql_databases`), server parameters (`postgresql_configuration`) and a Microsoft Entra group administrator.
- A private endpoint for the `postgresqlServer` subresource and optional diagnostic settings.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Public network access is disabled.
- Password authentication is disabled and Microsoft Entra ID authentication is enabled; no administrator login or password is set.
- The private endpoint uses automatic approval.
- Backups are kept for 30 days by default (`postgresql_backup_retention_days`, validated between 7 and 35).
- Customer-managed key (`customer_managed_key`) and diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- No input re-enables public network access or password authentication.
- `postgresql_configuration` passes arbitrary server parameters (no validation). *Reason:* not stated in the module code. *Mitigation:* review the parameters in code review, because the module does not validate them.
- With the default `postgresql_active_directory_administrator = {}` no Microsoft Entra administrator is created, while password authentication is disabled. Set both `object_id` and `group_name` to create one.
- Known issue: the customer-managed key block passes the Key Vault resource identifier (ID) where a key ID is expected, so the key configuration does not receive the key ID.
- Known issue: the `postgresql_storage_tier` validation compares `postgresql_storage_mb` instead of the tier, so any non-null tier fails validation.

**Prerequisites**

- `subnet_id`: the resource ID of the subnet for the private endpoint. The server itself is not injected into the virtual network.
- Optional private Domain Name System (DNS) zone ID in `private_dns_zone_id_postrgesql` (the variable name is spelled this way), ending in `privatelink.postgres.database.azure.com`. It is not required when DNS A-records are created through Azure Policy.
- `postgresql_active_directory_administrator` needs both `object_id` and `group_name` (a Microsoft Entra group), or neither.

## 🚀 Usage

```hcl
module "postgresql_flexible" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/postgresqlflexible?ref=<release-tag>"

  location            = "<azure-region>"
  resource_group_name = "<resource-group-name>"
  postgresql_name     = "<postgresql-server-name>"
  subnet_id           = "<subnet-resource-id>"
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).
