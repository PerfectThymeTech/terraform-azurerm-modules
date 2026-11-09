# 🚀 Getting started

This page shows how to use a module from this repository in your own Terraform configuration. Each module page is the authoritative source for that module's inputs and outputs; this page covers what is common to all of them.

> [!NOTE]
> This documentation is a point-in-time baseline of the repository (November 2026). When a statement here differs from a module's code, the code wins.

## 📋 Prerequisites

| Requirement | Details |
|-------------|---------|
| Terraform | The test workflows run Terraform `1.17.1`. Each module declares its own minimum version in the **Requirements** section of its page: most declare `>=0.12`, `eventgridnamespace` declares `>=1.3` and `fabricworkspace` declares `~> 1.8`. |
| Providers | Modules that deploy Azure resources through `azurerm` require `~> 5.0`. Several modules also use `azapi` (`~> 2.0`) and `time` (`~> 0.9`), and `fabricworkspace` also uses the `microsoft/fabric` provider (`~> 1.0`). The exact list is in the **Providers** section of each module page. |
| Provider configuration | Modules do not contain `provider` blocks. Configure the providers in your own root configuration. |
| Azure access | Terraform needs an identity that can create the module's resources. Some modules also create role assignments for the identity running Terraform (for example `keyvault` assigns *Key Vault Administrator* and `storage` assigns *Storage Blob Data Owner*), so that identity must be allowed to create role assignments. |
| Network | Modules for services that support Private Link create private endpoints and take the resource ID of an existing subnet in `subnet_id`. |
| Scripts | A few modules run PowerShell or the Azure command-line interface (CLI) from the machine that runs Terraform (`aisearch`, `aistudiooutboundrules`, `datafactory` and `fabricworkspace`). Install `pwsh` and the Azure CLI and run `az login` before `terraform apply` when you use those features. |

## 🚀 Reference a module

Modules are consumed directly from Git. Pin every reference to a release tag:

```hcl
module "key_vault" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/keyvault?ref=<release-tag>"

  location            = "<azure-region>"
  resource_group_name = "<resource-group-name>"
  key_vault_name      = "<key-vault-name>"
  subnet_id           = "<subnet-resource-id>"
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases). The four inputs above are the required inputs listed on the Key Vault module page.

Run `terraform init` to download the module, then `terraform plan` to review what it will create.

## 🔌 Private connectivity inputs

Several modules share the same pattern for private endpoints:

- `subnet_id` is the resource ID of the subnet that receives the private endpoints.
- `private_dns_zone_id_*` inputs are optional and default to an empty string, which creates the private endpoint without a Domain Name System (DNS) zone group. The variable descriptions state that they are not required when DNS A-records are created through Azure Policy.
- `connectivity_delay_in_seconds` adds a wait after the private endpoint is created (default `120` in the modules that have it). Its description says the delay is required for DNS automation through Azure Policy.

## 📈 Diagnostics

Many modules accept `diagnostics_configurations`. It defaults to an empty list, so no diagnostic setting is created until you pass at least one entry. Each entry needs a Log Analytics workspace ID, a storage account ID, or both.

## 📖 Read a module page

Every module page starts with a hand-written overview (what is deployed, secure defaults, exceptions and prerequisites, and a usage example). A generated reference follows with the requirements, providers, resources, inputs and outputs. Start from the module list in the [repository README](../README.md) and open the module you need.

## ➡️ Next steps

- Browse all modules in the [repository README](../README.md).
- See every documentation page in the [documentation index](README.md).
