# 🔐 Security

Every module is written to deploy in its most secure supported configuration when only the required inputs are supplied. This page explains the rules behind that statement, summarizes how the modules apply them, and lists the secure defaults and the documented exceptions of every module.

> [!NOTE]
> This is a point-in-time baseline (November 2026). The module code is authoritative: when it differs from this page, the code wins. The tables cite the source files that hold each setting.

## 📏 The secure-by-default rules

The rules come from Principle III of the repository [constitution](../.specify/memory/constitution.md).

- Public network access is disabled by default, and private connectivity uses Private Link private endpoints where the service supports them.
- Authentication uses Microsoft Entra ID and Azure role-based access control (RBAC). Shared keys, local authentication, access policies and anonymous access are disabled where the service allows.
- Encryption in transit (current minimum Transport Layer Security (TLS) version, HTTPS only) and at rest is enabled. Protection features such as soft delete and purge protection are enabled where available.
- Diagnostic settings are supported for services that expose logs or metrics.
- Secrets are never hard-coded, committed or output in plain text. Variables and outputs that carry secrets are marked `sensitive = true`.
- Insecure settings are not exposed as a convenience. Where a variable relaxes a secure setting, its default is the secure value.

### Exceptions

An exception is allowed only when the secure setting blocks critical functionality of the Azure service. Each exception must be:

1. as narrow as possible;
2. explained by a short inline code comment;
3. documented in the module's `README_header.md` with the setting, the reason and the recommended mitigation.

The module pages list exceptions under **Exceptions and prerequisites**. Where the code does not state a reason for an exception, the table below says so.

## 🧭 How the modules apply the rules

| Area | What the modules do | Where it differs |
|------|---------------------|------------------|
| Private connectivity | 18 modules create private endpoints; see [Common patterns](common-patterns.md#-private-connectivity) for the list | `applicationinsights`, `loganalytics`, `appserviceplan`, `communicationservice`, `databricksaccessconnector`, `fabriccapacity`, `userassignedidentity` and `aistudioproject` define no private endpoint |
| Public network access | Disabled by default in the modules with a network surface | `storage` defaults `storage_public_network_access_enabled` to `true` (network rules still deny by default); `purview` hard-codes the account to `Enabled`; `applicationinsights` enables internet ingestion and query by default; `loganalytics` hard-codes internet ingestion and query to `Enabled`; `fabricworkspace` defaults its network policy to `Allow` |
| Authentication | Local or key-based authentication is off by default in `aisearch`, `aiservice`, `botservice`, `containerregistry` (admin account and anonymous pull), `cosmosdb`, `eventhubnamespace`, `loganalytics`, `storage` (shared key), `mssqlserver` and `postgresqlflexible` (Microsoft Entra ID only) | `applicationinsights` keeps local authentication unless you disable it; `aifoundrybasic` has a known issue that inverts its local-authentication input (see below) |
| Transport security | `cosmosdb`, `eventhubnamespace`, `mssqlserver` and `storage` set a minimum TLS version of 1.2; `storage` also enforces HTTPS only; `botservice` validates HTTPS endpoints | Other modules rely on the service defaults |
| Identity | Modules that need an identity use a system-assigned managed identity (for example `aifoundrybasic`, `aisearch`, `aiservice`, `aistudiohub`, `aistudioproject`, `containerregistry`, `databricksaccessconnector`, `datafactory`, `eventgridnamespace`, `eventhubnamespace` and `purview`) | Some modules create a role assignment for the identity that runs Terraform; see the per-module table |
| Encryption and protection | `keyvault` enables purge protection and RBAC authorization; `storage` enables infrastructure encryption and soft delete; `databricksworkspace` enables infrastructure encryption; `cosmosdb` uses continuous backup | 13 modules declare `customer_managed_key`; it is opt-in and not applied the same way everywhere (see [Common patterns](common-patterns.md#-customer-managed-keys)) |
| Diagnostics | 22 modules accept `diagnostics_configurations`; it is opt-in, so no diagnostic setting exists until you pass an entry | `aistudiooutboundrules`, `databricksaccessconnector`, `fabriccapacity`, `fabricworkspace` and `userassignedidentity` do not declare it; `synapseprivetlinkhub` declares it but does not use it |
| Secrets | Key and connection-string outputs are marked `sensitive` in modules that expose them (for example `applicationinsights`, `communicationservice`, `cosmosdb`, `eventhubnamespace` and `databricksaccessconnector`) | `aistudiohub` and `aistudioproject` accept connection credentials in variables that are not marked sensitive |
| Scripted steps | Last-mile steps use `pwsh` and the Azure command-line interface (CLI) with the ambient Azure identity | See [Scripted steps](scripted-steps.md) for the steps and the deviations |

## 📋 Secure defaults and exceptions per module

Each row cites the files that contain the settings, relative to the module folder (for example `main.tf` of `keyvault` is `modules/keyvault/main.tf`). Module names link to the module page.

### 🤖 AI and Cognitive Services

| Module | Secure defaults | Documented exceptions | Source |
|--------|-----------------|-----------------------|--------|
| [aifoundrybasic](../modules/aifoundrybasic/) | Public access disabled; firewall `Deny`; outbound access restricted; system-assigned identity; private endpoint always created | Firewall bypass `AzureServices` through `ai_services_firewall_bypass_azure_services` (default `false`); outbound restriction can be removed and fully qualified domain names (FQDNs) allowed | `main.tf`, `connectivity.tf`, `variables.tf` |
| [aisearch](../modules/aisearch/) | Public access disabled; API-key authentication off; system-assigned identity; private endpoint always created | Network bypass hard-coded to `AzureServices`; `search_service_local_authentication_enabled = true` enables keys; approved shared private links run a script | `main.tf`, `connectivity.tf`, `sharedprivatelink.tf` |
| [aiservice](../modules/aiservice/) | Public access disabled; firewall `Deny`; key authentication off; outbound access restricted; system-assigned identity; private endpoint always created | `cognitive_account_local_auth_enabled = true`; optional firewall bypass `AzureServices`; outbound restriction can be removed | `main.tf`, `connectivity.tf`, `variables.tf` |
| [aistudiohub](../modules/aistudiohub/) | Public access disabled; managed network `AllowOnlyApprovedOutbound` with no rules; workspace-identity datastores; data isolation and high business impact on; system-assigned identity; private endpoint always created; connections use Entra ID (`AAD`) | Connections can use credential-based authentication and are shared with all projects (`isSharedToAll = true`, hard-coded); the connections variable is not marked sensitive | `main.tf`, `connectivity.tf`, `connections.tf` |
| [aistudiooutboundrules](../modules/aistudiooutboundrules/) | Isolation mode `AllowOnlyApprovedOutbound`; default private endpoint rules to the hub storage account (`table`, `queue`); provisioning and approval off | Variables add FQDN, service-endpoint and private-endpoint rules; a default FQDN allow-list and an `AzureOpenDatasets` service tag rule are always merged in; approval runs a script | `main.tf`, `locals.tf` |
| [aistudioproject](../modules/aistudioproject/) | System-assigned identity; connections not shared with other projects (`isSharedToAll = false`); connections use `AAD` by default | Connections can use credential-based authentication and the variable is not marked sensitive; no network or key settings in the module | `main.tf`, `connections.tf` |
| [botservice](../modules/botservice/) | Local authentication disabled; public access disabled; both private endpoints always created; HTTPS endpoints enforced | `bot_service_public_network_access_enabled = true`; an Application Insights read key is created and passed to the bot by default | `main.tf`, `connectivity.tf`, `variables.tf` |

### 📊 Data and Analytics

| Module | Secure defaults | Documented exceptions | Source |
|--------|-----------------|-----------------------|--------|
| [cosmosdb](../modules/cosmosdb/) | Public access disabled; key authentication disabled; TLS 1.2; virtual network filter on; no IP rules; continuous backup | Key authentication can be re-enabled; access key metadata writes and cross-origin resource sharing (CORS) rules can be set; the primary key is exposed as a sensitive output | `main.tf`, `connectivity.tf`, `variables.tf`, `outputs.tf` |
| [datafactory](../modules/datafactory/) | Public access disabled; managed virtual network enabled; system-assigned identity; private endpoint with automatic approval | Managed private endpoints are always approved by a script; optional trigger-start and pipeline-run steps run the Azure CLI | `main.tf`, `connectivity.tf`, `managedprivateendpoint.tf`, `content.tf` |
| [databricksaccessconnector](../modules/databricksaccessconnector/) | System-assigned identity; sensitive principal ID output | None | `main.tf`, `outputs.tf` |
| [databricksworkspace](../modules/databricksworkspace/) | Public access disabled; no public IP on clusters; infrastructure encryption; Databricks File System (DBFS) firewall; enhanced security and compliance; private endpoints always created | The browser authentication private endpoint is opt-in; no input relaxes the network or encryption defaults | `main.tf`, `connectivity.tf` |
| [fabriccapacity](../modules/fabriccapacity/) | None; the module sets only the SKU (pricing tier) and administrators | The identity that runs Terraform is always a capacity administrator | `main.tf` |
| [fabricworkspace](../modules/fabricworkspace/) | Workspace identity on by default; private endpoint with automatic approval when private link is enabled; scripts use a token from the Azure CLI session | Network communication policy defaults to `Allow` inbound and outbound; private link off by default; Git integration hard-coded to `PreferWorkspace`; several steps run scripts | `connectivity_inbound.tf`, `connectivity_outbound.tf`, `variables.tf` |
| [mssqlserver](../modules/mssqlserver/) | Public access disabled; Entra ID authentication only; TLS 1.2; outbound restriction; express vulnerability assessment; auditing to Azure Monitor; private endpoint | The identity that runs Terraform becomes the Entra administrator; no inputs relax the settings; `securityalertpolicy.tf` contains only commented-out code | `main.tf`, `connectivity.tf`, `securityalertpolicy.tf` |
| [postgresqlflexible](../modules/postgresqlflexible/) | Public access disabled; password authentication disabled; Entra ID authentication on; private endpoint; 30-day backup retention by default | No input re-enables public access or password authentication; arbitrary server parameters are accepted; without an administrator input no Entra administrator exists | `main.tf`, `connectivity.tf` |
| [purview](../modules/purview/) | Public access disabled for ingestion storage and managed resources; managed event hub disabled; system-assigned identity; private endpoints | The account has `publicNetworkAccess = "Enabled"` hard-coded (no reason in the code); ingestion blob and queue private endpoints use manual connections | `main.tf`, `connectivity.tf` |
| [storage](../modules/storage/) | Blob public access off; network rules `Deny`; shared key off; HTTPS only; TLS 1.2; infrastructure encryption; cross-tenant replication off; soft delete 7 days; SSH File Transfer Protocol (SFTP) and Network File System version 3 (NFSv3) off; private endpoint for `blob` | `storage_public_network_access_enabled` defaults to `true`; variables can enable shared keys, widen copy scope, add bypass, private link access, CORS, SFTP and NFSv3; shared access signature (SAS) expiration policy fixed at one day with action `Log` | `main.tf`, `connectivity.tf`, `variables.tf` |
| [synapseprivetlinkhub](../modules/synapseprivetlinkhub/) | Private endpoint always created with automatic approval | None | `connectivity.tf`, `variables.tf` |

### 🔌 Integration and Messaging

| Module | Secure defaults | Documented exceptions | Source |
|--------|-----------------|-----------------------|--------|
| [communicationservice](../modules/communicationservice/) | None; the module sets only name, resource group, tags and data location; sensitive key outputs | None | `main.tf` |
| [eventgridnamespace](../modules/eventgridnamespace/) | Public access disabled (hard-coded); system-assigned identity; private endpoint with automatic approval | None | `main.tf`, `connectivity.tf` |
| [eventhubnamespace](../modules/eventhubnamespace/) | Public access disabled (hard-coded); local authentication off; TLS 1.2; system-assigned identity; authorization rules listen-only by default; sensitive outputs | Local authentication and `manage` or `send` rights can be enabled; the network rule set default action is `Allow` (inert while public access is disabled, per a code comment); trusted service access hard-coded | `main.tf`, `connectivity.tf`, `variables.tf` |

### 🔐 Security and Identity

| Module | Secure defaults | Documented exceptions | Source |
|--------|-----------------|-----------------------|--------|
| [keyvault](../modules/keyvault/) | Public access disabled; firewall deny; purge protection; RBAC authorization; deployment, disk encryption and template access off; private endpoint | Firewall bypass hard-coded to `AzureServices`; a *Key Vault Administrator* role assignment for the identity that runs Terraform is always created | `main.tf`, `connectivity.tf`, `roleassignments.tf` |
| [userassignedidentity](../modules/userassignedidentity/) | None; the module sets only name, location, resource group and tags | None | `main.tf` |

### 📈 Monitoring and Management

| Module | Secure defaults | Documented exceptions | Source |
|--------|-----------------|-----------------------|--------|
| [applicationinsights](../modules/applicationinsights/) | IP masking on; sensitive instrumentation key and connection string outputs | Internet ingestion and query enabled by default; local authentication kept unless disabled; no private endpoint | `main.tf`, `variables.tf` |
| [loganalytics](../modules/loganalytics/) | Local authentication disabled (hard-coded) | Internet ingestion and query hard-coded to `Enabled` (no reason in the code); no private endpoint | `main.tf` |

### 🖥️ Compute and Containers

| Module | Secure defaults | Documented exceptions | Source |
|--------|-----------------|-----------------------|--------|
| [appserviceplan](../modules/appserviceplan/) | None; the module has no network, identity or encryption settings | None | `main.tf` |
| [containerregistry](../modules/containerregistry/) | Public access disabled; network rules deny by default; admin account off; anonymous pull off; private endpoint; system-assigned identity | Admin account and anonymous pull can be enabled; network bypass hard-coded to `AzureServices` | `main.tf`, `connectivity.tf`, `variables.tf` |

## ⚠️ Known gaps that affect security

These gaps exist in the code at the time of this baseline. The documentation baseline does not change code; they are reported so consumers can plan around them.

| Module | Gap |
|--------|-----|
| `aifoundrybasic` | The module negates `ai_services_local_auth_enabled` when it sets `local_authentication_enabled`, so the default value `false` creates the account with key-based authentication enabled. |
| `aisearch` | `customer_managed_key` only switches on enforcement; the key fields are not used and no role assignment exists. |
| `containerregistry`, `databricksworkspace`, `botservice`, `eventhubnamespace` | `customer_managed_key` is validated, but some fields (or the whole input in `eventhubnamespace`) are not used by any resource. |
| `postgresqlflexible` | The customer-managed key block passes the Key Vault resource ID where a key ID is expected. |
| `cosmosdb` | The default of `private_endpoint_subresource_names` is `["blob"]`, which its own validation rejects; always set the input. |
| `storage` | The diagnostic setting for the `file` service reads the diagnostic categories of the `blob` service. |
| `aistudiohub`, `aistudioproject` | Connection variables can carry credentials and are not marked sensitive. |
| `purview`, `loganalytics` | Public settings are hard-coded to `Enabled` without a code comment that states the reason, which Principle III requires. |
| `datafactory` | Two scripted steps use the default shell instead of `pwsh`; see [Scripted steps](scripted-steps.md). |
