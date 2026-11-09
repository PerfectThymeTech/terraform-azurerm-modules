# 🔌 Azure Event Grid Namespace Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-eventgridnamespace.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-eventgridnamespace.yml)

Deploys an Azure Event Grid namespace with public access disabled, a private endpoint and optional namespace topics.

## 📦 Overview

- An Event Grid namespace (`azurerm_eventgrid_namespace`) with a system-assigned managed identity.
- Optional namespace topics deployed through the `azapi` provider.
- A private endpoint for the `topic` subresource and optional diagnostic settings.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Public network access is disabled (hard-coded); no variable changes it.
- The namespace uses a system-assigned managed identity.
- The private endpoint uses automatic approval.
- Diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- No security exceptions.

**Prerequisites**

- `subnet_id`: the resource ID of the subnet for the private endpoint.
- Optional `private_dns_zone_id_topic` ending in `privatelink.eventgrid.azure.net`. It is not required when DNS A-records are created through Azure Policy.
- The `azapi` provider (`~> 2.0`) in addition to `azurerm` and `time`, and Terraform `>=1.3`.

## 🚀 Usage

```hcl
module "eventgrid_namespace" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/eventgridnamespace?ref=<release-tag>"

  location                 = "<azure-region>"
  resource_group_name      = "<resource-group-name>"
  eventgrid_namespace_name = "<eventgrid-namespace-name>"
  subnet_id                = "<subnet-resource-id>"
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).
