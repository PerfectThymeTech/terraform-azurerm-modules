# 📊 Azure Data Factory Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-datafactory.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-datafactory.yml)

Deploys an Azure Data Factory with a managed virtual network, with public access disabled, a private endpoint and optional content deployment, trigger start and pipeline run steps.

## 📦 Overview

- An Azure Data Factory (`azurerm_data_factory`) with a system-assigned managed identity and an optional GitHub or Azure DevOps repository.
- A private endpoint for the `dataFactory` subresource and optional diagnostic settings.
- Optional managed private endpoints, an optional ARM template deployment of published content, and optional trigger start and pipeline run steps.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Public network access is disabled and the managed virtual network is enabled; no variable changes either.
- The factory uses a system-assigned managed identity.
- The private endpoint uses automatic approval (not a manual connection).
- Customer-managed key (`customer_managed_key`) and diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- Every entry in `data_factory_managed_private_endpoints` is approved automatically by a PowerShell script at create time. There is no opt-out flag. *Reason:* not stated in the module code. *Mitigation:* list only managed private endpoints to targets you trust and review them in code review.
- `data_factory_triggers_start` and `data_factory_pipelines_run` (default `[]`) run Azure command-line interface (CLI) commands (`az datafactory ...`) from the machine that runs Terraform. These two steps set no interpreter, so they use the default shell of that machine. *Reason:* not stated in the module code. *Mitigation:* use them only from a trusted machine or pipeline whose identity has least privilege on the factory.
- The approval step uses `pwsh` and the Azure CLI.

**Prerequisites**

- `subnet_id`: the resource ID of the subnet for the private endpoint.
- Optional `private_dns_zone_id_data_factory` ending in `privatelink.datafactory.azure.net`. It is not required when Domain Name System (DNS) A-records are created through Azure Policy.
- `data_factory_published_content` needs both a `parameters_file` and a `template_file`; triggers and pipelines only run when published content is set.
- `data_factory_managed_private_endpoints` entries need `subresource_name` and `target_resource_id`.
- The Azure CLI (`az`), signed in, and `pwsh` on `PATH` on the machine that runs Terraform when you use these features.

> [!NOTE]
> The `data_factory_triggers_start` and `data_factory_pipelines_run` features rely on Azure CLI and therefore require you to be authenticated.

## 🚀 Usage

```hcl
module "data_factory" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/datafactory?ref=<release-tag>"

  location            = "<azure-region>"
  resource_group_name = "<resource-group-name>"
  data_factory_name   = "<data-factory-name>"
  subnet_id           = "<subnet-resource-id>"
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).
