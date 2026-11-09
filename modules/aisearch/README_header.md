# 🤖 Azure AI Search Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-aisearch.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-aisearch.yml)

Deploys a private-only Azure AI Search service with optional shared private links that a script can approve.

## 📦 Overview

- An Azure AI Search service with a system-assigned managed identity.
- A private endpoint for the `searchService` subresource and optional diagnostic settings.
- Optional shared private links to other resources and, for links with `approve = true`, a PowerShell step that approves the connection on the target resource.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Public network access is disabled and no IP addresses are allowed.
- API-key (local) authentication is off (`search_service_local_authentication_enabled` defaults to `false`).
- The service uses a system-assigned managed identity.
- The private endpoint is always created.
- Diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- The network rule bypass option is hard-coded to `AzureServices`; there is no variable to change it.
- `search_service_local_authentication_enabled = true` enables key-based authentication.
- Shared private links with `approve = true` run PowerShell and the Azure CLI on the machine that runs Terraform.
- Known issue: `customer_managed_key` only switches on customer-managed key enforcement. The key fields are not used by any resource, and the module has no role assignment for the key.

**Prerequisites**

- `subnet_id`: the resource ID of the subnet for the private endpoint.
- Optional `private_dns_zone_id_search_service` (`privatelink.search.windows.net`). It is not required when DNS A-records are created through Azure Policy.
- Each shared private link needs a `target_resource_id` and a `subresource_name`.
- For `approve = true`: `pwsh` and the Azure CLI (`az`), signed in, on the machine that runs Terraform.

## 🚀 Usage

```hcl
module "ai_search" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/aisearch?ref=<release-tag>"

  location            = "<azure-region>"
  resource_group_name = "<resource-group-name>"
  search_service_name = "<search-service-name>"
  subnet_id           = "<subnet-resource-id>"
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).
