# 📊 Azure Synapse Private Link Hub Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-synapseprivetlinkhub.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-synapseprivetlinkhub.yml)

Deploys an Azure Synapse private link hub with a private endpoint for the `web` subresource.

## 📦 Overview

- One Synapse private link hub (`azurerm_synapse_private_link_hub`).
- A private endpoint for the `web` subresource.
- The full list of deployed resources is in [Resources](#resources).

> [!NOTE]
> The module folder is named `synapseprivetlinkhub` (sic). Use that exact name in links and in the module source.

## 🛡️ Secure defaults

- The private endpoint uses automatic approval and is always created.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- No security exceptions.
- The module declares `diagnostics_configurations`, but no resource uses it; no diagnostic setting is created.

**Prerequisites**

- `subnet_id`: the resource ID of the subnet for the private endpoint.
- Optional `private_dns_zone_id_synapse_portal` ending in `privatelink.azuresynapse.net`. It is not required when DNS A-records are created through Azure Policy.

## 🚀 Usage

```hcl
module "synapse_private_link_hub" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/synapseprivetlinkhub?ref=<release-tag>"

  location                      = "<azure-region>"
  resource_group_name           = "<resource-group-name>"
  synapse_private_link_hub_name = "<private-link-hub-name>"
  subnet_id                     = "<subnet-resource-id>"
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).
