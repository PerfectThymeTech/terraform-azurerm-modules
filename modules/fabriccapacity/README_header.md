# 📊 Microsoft Fabric Capacity Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-fabriccapacity.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-fabriccapacity.yml)

Deploys a Microsoft Fabric capacity in Azure with the deploying identity and optional extra members as administrators.

## 📦 Overview

- One Microsoft Fabric capacity (`Microsoft.Fabric/capacities`) deployed through the `azapi` provider.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- None. The module only sets the SKU (pricing tier) and the capacity administrators; it defines no network, identity or encryption settings.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- The object identifier (ID) of the identity that runs Terraform is always added as a capacity administrator. `fabric_capacity_admin_emails` (default `[]`) adds further administrators. *Reason:* not stated in the module code. *Mitigation:* limit who can run Terraform, and list further administrators only when needed.

**Prerequisites**

- An existing resource group.
- `fabric_capacity_name` must be alphanumeric and at least two characters long.
- `fabric_capacity_sku` must be one of `F2` to `F2048` (default `F2`).

## 🚀 Usage

```hcl
module "fabric_capacity" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/fabriccapacity?ref=<release-tag>"

  location             = "<azure-region>"
  resource_group_name  = "<resource-group-name>"
  fabric_capacity_name = "<fabriccapacityname>"
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).
