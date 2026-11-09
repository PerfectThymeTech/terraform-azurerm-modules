# 📊 Azure Cosmos DB Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-cosmosdb.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-cosmosdb.yml)

Deploys an Azure Cosmos DB account with public access disabled, private endpoints and optional diagnostics and customer-managed key.

## 📦 Overview

- An Azure Cosmos DB account (`azurerm_cosmosdb_account`) with a system-assigned managed identity.
- One private endpoint per entry in `private_endpoint_subresource_names` (for example `Sql`).
- Optional diagnostic settings.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Public network access is disabled; no variable changes it.
- Key-based (local) authentication is disabled (`cosmosdb_account_local_authentication_disabled` defaults to `true`).
- The minimum Transport Layer Security (TLS) version is 1.2 (hard-coded).
- The virtual network filter is on, there is no Internet Protocol (IP) allow list and no Azure services bypass.
- Private endpoints use automatic approval (not manual connections).
- The free tier is off, and the backup policy is continuous (`Continuous7Days`) by default.
- Customer-managed key (`customer_managed_key`) and diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- `cosmosdb_account_local_authentication_disabled = false` enables key authentication. Its description reads inverted, but the code negates the value, so `true` disables local authentication. *Reason:* not stated in the module code. *Mitigation:* keep key authentication disabled and use Microsoft Entra ID.
- `cosmosdb_account_access_key_metadata_writes_enabled` (default `false`) and `cosmosdb_account_cors_rules` (default `{}`) relax the corresponding settings. *Reason:* not stated in the module code. *Mitigation:* keep metadata writes off and list only the origins that need cross-origin access.
- The output `cosmosdb_account_primary_key` exposes the account primary key (marked sensitive). *Reason:* not stated in the module code. *Mitigation:* prefer Microsoft Entra ID authentication and protect the Terraform state, because the output value is stored there.
- Known issue: the default of `private_endpoint_subresource_names` is `["blob"]`, but its own validation only allows `Sql`, `MongoDB`, `Cassandra`, `Gremlin`, `Table`, `Analytical` and `coordinator`. Always set the input.
- Known issue: `cosmosdb_account_mongo_server_version` is assigned to `multiple_write_locations_enabled`, and `mongo_server_version` is hard-coded to `null`, so the input does not set the Mongo server version.

**Prerequisites**

- `subnet_id`: the resource identifier (ID) of the subnet for the private endpoints.
- Optional private Domain Name System (DNS) zone IDs (`private_dns_zone_id_cosmos_sql`, `_mongodb`, `_cassandra`, `_gremlin`, `_table`, `_analytical`, `_coordinator`). Each must match the zone name of its subresource and is not required when DNS A-records are created through Azure Policy.
- `customer_managed_key` needs a Key Vault, key and user-assigned identity. The module creates no role assignment, so grant the identity access to the key outside the module.

## 🚀 Usage

```hcl
module "cosmosdb" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/cosmosdb?ref=<release-tag>"

  location             = "<azure-region>"
  resource_group_name  = "<resource-group-name>"
  cosmosdb_account_name = "<cosmos-account-name>"
  subnet_id            = "<subnet-resource-id>"

  cosmosdb_account_geo_location = [
    {
      location          = "<azure-region>"
      failover_priority = 0
    }
  ]

  private_endpoint_subresource_names = ["Sql"]
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).
