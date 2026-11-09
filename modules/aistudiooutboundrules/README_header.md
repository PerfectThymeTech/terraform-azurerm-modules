# 🤖 Azure AI Studio Hub Outbound Rules Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-aistudiooutboundrules.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-aistudiooutboundrules.yml)

Applies all user-defined managed network outbound rules of an existing Azure AI Hub in one batch, with optional managed network provisioning and private endpoint approval.

## 📦 Overview

- One `azapi_resource_action` that sets `managedNetwork.outboundRules` on an existing AI Hub.
- An optional `provisionManagedNetwork` action (`ai_studio_hub_provision_managed_network`, default `false`).
- An optional PowerShell step that approves the private endpoint connections created by private endpoint rules (`ai_studio_hub_approve_private_endpoints`, default `false`).
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- The managed network isolation mode is set to `AllowOnlyApprovedOutbound`.
- Default private endpoint rules point to the hub storage account for the `table` and `queue` subresources.
- Managed network provisioning and private endpoint approval are off by default.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- `ai_studio_hub_outbound_rules_fqdns`, `ai_studio_hub_outbound_rules_service_endpoints` and `ai_studio_hub_outbound_rules_private_endpoints` (default `{}`) add allowed outbound destinations. *Reason:* not stated in the module code. *Mitigation:* add only destinations the workloads need and prefer private endpoint rules over domain name rules.
- A default fully qualified domain name (FQDN) allow-list (for example `*.docker.io`, `*.anaconda.com`, `huggingface.co` and `*.vscode.dev`) and an `AzureOpenDatasets` service tag rule on Transmission Control Protocol (TCP) port 443 are always merged into the rules. There is no variable to remove them. *Reason:* code comments in `locals.tf` label the entries as dependencies (general, Python package index, R, Visual Studio Code, AI Studio and Azure Machine Learning samples, Hugging Face model catalogue, Ubuntu). *Mitigation:* review the list in `locals.tf` before you deploy, because the module cannot remove entries.
- With `ai_studio_hub_approve_private_endpoints = true` the module runs PowerShell and the Azure command-line interface (CLI) on the machine that runs Terraform (see [Scripted steps](../../docs/scripted-steps.md)). *Reason:* not stated in the module code. *Mitigation:* run Terraform from a trusted machine or pipeline whose identity can approve only the connections you intend.
- Known issue: two `depends_on` entries in `main.tf` reference `azapi_update_resource.ai_studio_hub_outbound_rules`, which is not declared (the resource is declared as `azapi_resource_action`), so the reference cannot be resolved.

**Prerequisites**

- An existing AI Hub: `ai_studio_hub_id` and `ai_studio_hub_storage_account_id`.
- For approval: `pwsh` and the Azure CLI (`az`), signed in, on the machine that runs Terraform.

> [!NOTE]
> **Info for user-defined outbound rule management**
>
> This module has been created to centrally manage user-defined outbound rules for an Azure AI Hub.
>
> New user-defined outbound rules can technically already be added individually via the `Microsoft.MachineLearningServices/workspaces/outboundRules` resource type. However, the next outbound rule in a list can only be added after the previous rule has been added successfully. Since, Terraform does not support a batch size parameter when creating resources using the `for_each` meta-argument, user-defined outbound rules must be added in batches and cannot be created individually. If you don't follow the batch approach, you will see unexpected behaviors and configuration results when adding a large number of rules individually via the `for_each` meta-argument.
>
> When working on larger projects, the outbound rules may also depend on other Terraform resources to be created. Due to these internal dependencies you may also require creating these outbound rules after creating the AI Hub. Hence, the outbound rules cannot be defined when creating the initial AI Hub resource. or you may end up with cyclic dependencies in your Terraform configuration. This can be avoided by using this Terraform module.
>
> This module has been created to manage all user-defined outbound rules centrally and apply the configuration in batches and overcome all aforementioned issues.

## 🚀 Usage

```hcl
module "ai_studio_outbound_rules" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/aistudiooutboundrules?ref=<release-tag>"

  ai_studio_hub_id                 = "<ai-hub-resource-id>"
  ai_studio_hub_storage_account_id = "<hub-storage-account-resource-id>"
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).
