# 📊 Azure SQL Server Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-mssqlserver.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-mssqlserver.yml)

Deploys an Azure SQL logical server that is reachable only through a private endpoint and uses Microsoft Entra ID authentication only.

## 📦 Overview

- An Azure SQL logical server (`azurerm_mssql_server`) with a system-assigned managed identity.
- A server auditing policy that sends audit logs to Azure Monitor.
- A private endpoint for the `sqlServer` subresource and optional diagnostic settings.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Public network access is disabled.
- Microsoft Entra ID authentication only; no administrator login or password is set.
- The minimum TLS version is 1.2 and outbound network restriction is enabled.
- Express vulnerability assessment is enabled.
- Server auditing is enabled and sent to Azure Monitor.
- The private endpoint uses automatic approval.
- Customer-managed key for transparent data encryption (`customer_managed_key`) and diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- No input relaxes the network, TLS or authentication settings; they are hard-coded.
- The identity that runs Terraform becomes the Microsoft Entra administrator of the server.
- `securityalertpolicy.tf` contains only commented-out code; no security alert policy or vulnerability assessment storage is deployed from it.

**Prerequisites**

- `subnet_id`: the resource ID of the subnet for the private endpoint.
- Optional `private_dns_zone_id_sqlserver` ending in `privatelink.database.windows.net`. It is not required when DNS A-records are created through Azure Policy.
- `customer_managed_key` needs a Key Vault key ID and a user-assigned identity ID. The module creates no role assignment or access policy for that identity.

## 🚀 Usage

```hcl
module "mssql_server" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/mssqlserver?ref=<release-tag>"

  location            = "<azure-region>"
  resource_group_name = "<resource-group-name>"
  mssql_server_name   = "<sql-server-name>"
  subnet_id           = "<subnet-resource-id>"
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).
