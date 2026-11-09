# 🔁 Common patterns

Inputs and behavior that many modules share. The counts below come from the module variables as of this baseline; always check the module page for the exact inputs of a module.

## 🧱 Inputs shared by the modules

| Input | What it does | Where it exists |
|-------|--------------|-----------------|
| `location` | Azure region of the resources | 26 of 27 modules (not `aistudiooutboundrules`) |
| `resource_group_name` | Resource group that receives the resources | 26 of 27 modules (not `aistudiooutboundrules`) |
| `tags` | Map of tags for taggable resources, default `{}` | 26 of 27 modules (not `aistudiooutboundrules`) |
| `subnet_id` | Resource ID of the subnet that receives the private endpoints | 18 modules, the ones that create private endpoints |
| `private_dns_zone_id_*` | Optional private Domain Name System (DNS) zone IDs for the private endpoints | Same 18 modules |
| `connectivity_delay_in_seconds` | Wait after the private endpoint is created, default `120` | Same 18 modules |
| `location_private_endpoint` | Region of the private endpoints when it differs from the service | `aifoundrybasic`, `aiservice`, `databricksworkspace` and `purview` |
| `diagnostics_configurations` | List of diagnostic settings, default `[]` | 22 modules |
| `customer_managed_key` | Customer-managed key object, default `null` | 13 modules (see the caution below) |

## 🔌 Private connectivity

The 18 modules that create private endpoints are `aifoundrybasic`, `aisearch`, `aiservice`, `aistudiohub`, `botservice`, `containerregistry`, `cosmosdb`, `databricksworkspace`, `datafactory`, `eventgridnamespace`, `eventhubnamespace`, `fabricworkspace`, `keyvault`, `mssqlserver`, `postgresqlflexible`, `purview`, `storage` and `synapseprivetlinkhub`.

- Pass the subnet in `subnet_id`. The private endpoint is created in that subnet.
- A `private_dns_zone_id_*` input defaults to an empty string. An empty value creates the private endpoint without a DNS zone group. The variable descriptions state that the zone ID is not required when DNS A-records are created through Azure Policy.
- `connectivity_delay_in_seconds` adds a wait after the private endpoint so that Azure Policy based DNS automation can finish. Its variable description says it is required for that automation.
- `fabricworkspace` creates a private endpoint only when `workspace_private_endpoint_enabled` is `true` (default `false`), and still requires `subnet_id`.

## 📈 Diagnostics

`diagnostics_configurations` is a list of objects with `log_analytics_workspace_id` and `storage_account_id`. Each entry needs at least one of them (enforced by variable validation). The default is an empty list, so no diagnostic setting exists until you pass an entry. The setting enables the log category groups and metrics that the service reports.

Five modules do not declare the input: `aistudiooutboundrules`, `databricksaccessconnector`, `fabriccapacity`, `fabricworkspace` and `userassignedidentity`. `synapseprivetlinkhub` declares it but does not use it.

## 🔑 Customer-managed keys

The modules `aifoundrybasic`, `aisearch`, `aiservice`, `aistudiohub`, `botservice`, `containerregistry`, `cosmosdb`, `databricksworkspace`, `datafactory`, `eventhubnamespace`, `mssqlserver`, `postgresqlflexible` and `storage` declare `customer_managed_key`.

> [!CAUTION]
> The inputs are not used the same way everywhere. Some modules create the role assignment for the key, others expect you to grant access outside the module, and in some modules not every field is used. Read the **Exceptions and prerequisites** section of the module page before you rely on it.

## 🛡️ Secure-default exceptions

A module relaxes a secure default only through a documented input or a documented hard-coded setting. The module pages list them under **Exceptions and prerequisites**, and the [Security](security.md) page summarizes them for all modules.

## 🖥️ Scripted steps

A few modules run PowerShell or the Azure command-line interface (CLI) from the machine that runs Terraform: `aisearch`, `aistudiooutboundrules`, `datafactory` and `fabricworkspace`. Install `pwsh` and the Azure CLI and sign in with `az login` before you use those features. See [Scripted steps](scripted-steps.md) for every step.
