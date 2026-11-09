# 🔐 Terraform Modules for Azure - Secure by default

[![Release](https://img.shields.io/github/v/release/PerfectThymeTech/terraform-azurerm-modules)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases)

Reusable Terraform modules for Azure and Microsoft services that deploy in a secure-by-default configuration, with every deviation documented on the module's page.

## 🛡️ What "secure by default" means here

A module picks the most restrictive setting the service supports and only exposes a variable where callers may need to relax it.

- **Private connectivity**: modules for services that support Private Link create private endpoints, and most of them also disable public network access.
- **Identity-based access**: key-based access is off by default where the module controls it, for example `keyvault` uses Azure role-based access control (RBAC) authorization, and `storage`, `cosmosdb` and `aisearch` disable shared or local keys.
- **Protection features**: examples are purge protection in `keyvault`, a minimum Transport Layer Security (TLS) version in `mssqlserver`, `cosmosdb` and `storage`, and Microsoft Entra ID-only authentication in `mssqlserver` and `postgresqlflexible`.
- **Opt-in diagnostics**: modules accept `diagnostics_configurations`; nothing is created until you pass an entry.

The [Security](docs/security.md) page lists the rules and the secure defaults and exceptions of every module.

> [!IMPORTANT]
> Not every module can follow every rule. Known exceptions include `storage` (public network access enabled behind a deny-by-default firewall), `purview` (public account endpoint), `loganalytics` and `applicationinsights` (internet ingestion and query enabled). Each module page lists its exceptions under **Exceptions and prerequisites**.

## 📦 Modules

### 🤖 AI and Cognitive Services

| Module | What it deploys |
|--------|-----------------|
| [Azure AI Foundry Basic](modules/aifoundrybasic/) | Private-only AI Foundry (AI Services) account with optional projects, model deployments and customer-managed key |
| [Azure AI Search](modules/aisearch/) | Private-only AI Search service with optional shared private links |
| [Azure AI Service](modules/aiservice/) | Private-only Cognitive Services account of a chosen kind with optional model deployments |
| [Azure AI Studio Hub](modules/aistudiohub/) | Network-isolated AI Hub workspace with a private endpoint and optional connections |
| [Azure AI Studio Outbound Rules](modules/aistudiooutboundrules/) | All user-defined outbound rules of an existing AI Hub, applied in one batch |
| [Azure AI Studio Project](modules/aistudioproject/) | AI Project attached to an existing AI Hub, with optional connections |
| [Azure AI Bot Service](modules/botservice/) | Azure Bot with local authentication disabled and private endpoints |

### 📊 Data and Analytics

| Module | What it deploys |
|--------|-----------------|
| [Azure Cosmos DB](modules/cosmosdb/) | Cosmos DB account with public access disabled and private endpoints |
| [Azure Data Factory](modules/datafactory/) | Managed virtual network Data Factory with a private endpoint and optional content deployment steps |
| [Azure Databricks Access Connector](modules/databricksaccessconnector/) | Databricks access connector with a system-assigned managed identity |
| [Azure Databricks Workspace](modules/databricksworkspace/) | Premium Databricks workspace injected into a virtual network, without public access |
| [Microsoft Fabric Capacity](modules/fabriccapacity/) | Fabric capacity with the deploying identity as administrator |
| [Microsoft Fabric Workspace](modules/fabricworkspace/) | Fabric workspace on an existing capacity with optional Git, network policy and private link |
| [Azure SQL Server](modules/mssqlserver/) | Structured Query Language (SQL) logical server with Entra ID-only authentication and a private endpoint |
| [Azure Postgresql Flexible Server](modules/postgresqlflexible/) | PostgreSQL flexible server with Entra ID authentication only and a private endpoint |
| [Microsoft Purview](modules/purview/) | Purview account with private endpoints for the platform and ingestion storage |
| [Azure Storage Account](modules/storage/) | Locked-down storage account with Entra ID-first access and private endpoints |
| [Azure Synapse Private Link Hub](modules/synapseprivetlinkhub/) | Synapse private link hub with a private endpoint for the web subresource |

### 🔌 Integration and Messaging

| Module | What it deploys |
|--------|-----------------|
| [Azure Communication Service](modules/communicationservice/) | Communication Services resource with optional diagnostic settings |
| [Azure Event Grid Namespace](modules/eventgridnamespace/) | Event Grid namespace with public access disabled, a private endpoint and optional topics |
| [Azure Event Hub Namespace](modules/eventhubnamespace/) | Event Hubs namespace with public access disabled, a private endpoint, event hubs and authorization rules |

### 🔐 Security and Identity

| Module | What it deploys |
|--------|-----------------|
| [Azure Key Vault](modules/keyvault/) | Key Vault with RBAC authorization, purge protection and a private endpoint |
| [Azure User Assigned Identity](modules/userassignedidentity/) | User-assigned managed identity with optional federated identity credentials |

### 📈 Monitoring and Management

| Module | What it deploys |
|--------|-----------------|
| [Azure Application Insights](modules/applicationinsights/) | Application Insights component linked to a Log Analytics workspace |
| [Azure Log Analytics Workspace](modules/loganalytics/) | Log Analytics workspace with optional diagnostic settings |

### 🖥️ Compute and Containers

| Module | What it deploys |
|--------|-----------------|
| [Azure App Service Plan](modules/appserviceplan/) | App Service plan with configurable SKU (pricing tier), operating system type and worker count |
| [Azure Container Registry](modules/containerregistry/) | Premium container registry reachable only through a private endpoint |

## ➡️ Where to go next

- [Getting started](docs/getting-started.md): prerequisites and how to reference a module.
- [Module catalog](docs/module-catalog.md): all modules by category and how they combine.
- [Repository structure](docs/repository-structure.md): what each folder and root file is for.
- [Contributing](docs/contributing.md): how to change or add a module and regenerate the docs.
- [Security](docs/security.md): secure defaults and exceptions of every module.
- [Documentation index](docs/README.md): every documentation page.
