# 📊 Microsoft Purview Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-purview.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-purview.yml)

Deploys a Microsoft Purview account through the `azapi` provider with private endpoints for the platform and its ingestion storage, plus optional root collection administrators.

## 📦 Overview

- A Microsoft Purview account (`Microsoft.Purview/accounts`, SKU (pricing tier) `Standard`) with a system-assigned managed identity.
- Three private endpoints: `platform`, and `blob` and `queue` for the ingestion storage (the last two use manual connections).
- Optional root collection administrators and optional diagnostic settings.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Public network access is disabled for the ingestion storage and for the managed resources.
- The managed event hub is disabled.
- The account uses a system-assigned managed identity.
- Private endpoints exist for the platform, the ingestion blob storage and the ingestion queue storage.
- Diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- The account itself has `publicNetworkAccess = "Enabled"`. This is hard-coded; no variable changes it and no code comment gives a reason. *Reason:* not stated in the module code. *Mitigation:* control access with Microsoft Entra ID roles on the root collection and use the private endpoints for ingestion.
- The ingestion blob and queue private endpoints use manual connections. *Reason:* not stated in the module code. *Mitigation:* approve those connections only for the intended storage accounts.
- Customer-managed keys are not supported (the variables file states this).

**Prerequisites**

- `subnet_id` for all three private endpoints; optional `location_private_endpoint` when they must reside in another region.
- Optional private Domain Name System (DNS) zone identifiers (IDs) ending in `privatelink.purview-service.microsoft.com` (`private_dns_zone_id_purview_platform`), `privatelink.blob.core.windows.net` (`private_dns_zone_id_blob`) and `privatelink.queue.core.windows.net` (`private_dns_zone_id_queue`). They are not required when DNS A-records are created through Azure Policy.
- `purview_account_root_collection_admins` is a map of Microsoft Entra object IDs (default `{}`).
- The `azapi` provider (`~> 2.0`) in addition to `azurerm` and `time`.

## 🚀 Usage

```hcl
module "purview" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/purview?ref=<release-tag>"

  location             = "<azure-region>"
  resource_group_name  = "<resource-group-name>"
  purview_account_name = "<purview-account-name>"
  subnet_id            = "<subnet-resource-id>"
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).
