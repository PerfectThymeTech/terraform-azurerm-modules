<!-- BEGIN_TF_DOCS -->
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

## 📚 Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>=0.12)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (~> 2.0)

- <a name="requirement_null"></a> [null](#requirement\_null) (~> 3.2)

## Providers

The following providers are used by this module:

- <a name="provider_azapi"></a> [azapi](#provider\_azapi) (~> 2.0)

- <a name="provider_null"></a> [null](#provider\_null) (~> 3.2)

## Resources

The following resources are used by this module:

- [azapi_resource_action.ai_studio_hub_outbound_rules](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource_action) (resource)
- [azapi_resource_action.ai_studio_hub_provision_managed_network](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource_action) (resource)
- [null_resource.ai_studio_hub_private_endpoints_approval](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) (resource)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_ai_studio_hub_id"></a> [ai\_studio\_hub\_id](#input\_ai\_studio\_hub\_id)

Description: Specifies the resource id of the ai studio hub.

Type: `string`

### <a name="input_ai_studio_hub_storage_account_id"></a> [ai\_studio\_hub\_storage\_account\_id](#input\_ai\_studio\_hub\_storage\_account\_id)

Description: Specifies the id of the storage account that is connected to the ai studio hub.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_ai_studio_hub_approve_private_endpoints"></a> [ai\_studio\_hub\_approve\_private\_endpoints](#input\_ai\_studio\_hub\_approve\_private\_endpoints)

Description: Specifies whether the managed private endpoints should be approved as part of the ai studio hub deployment.

Type: `bool`

Default: `false`

### <a name="input_ai_studio_hub_firewall_sku"></a> [ai\_studio\_hub\_firewall\_sku](#input\_ai\_studio\_hub\_firewall\_sku)

Description: Specifies the firewall sku deployed in the managed vnet of the ai studio hub deployment.

Type: `string`

Default: `"Basic"`

### <a name="input_ai_studio_hub_outbound_rules_fqdns"></a> [ai\_studio\_hub\_outbound\_rules\_fqdns](#input\_ai\_studio\_hub\_outbound\_rules\_fqdns)

Description: Specifies the outbound FQDN rules that should be added to the AI Studio Hub. Only provide FQDNs without specific paths such as 'microsoft.com' or '*.microsoft.com' but NOT 'microsoft.com/mypath'.

Type: `map(string)`

Default: `{}`

### <a name="input_ai_studio_hub_outbound_rules_private_endpoints"></a> [ai\_studio\_hub\_outbound\_rules\_private\_endpoints](#input\_ai\_studio\_hub\_outbound\_rules\_private\_endpoints)

Description: Specifies the private endpoint rules that should be added to the AI Studio Hub.

Type:

```hcl
map(object({
    private_connection_resource_id = string
    subresource_name               = string
  }))
```

Default: `{}`

### <a name="input_ai_studio_hub_outbound_rules_service_endpoints"></a> [ai\_studio\_hub\_outbound\_rules\_service\_endpoints](#input\_ai\_studio\_hub\_outbound\_rules\_service\_endpoints)

Description: Specifies the service endpoint rules that should be added to the AI Studio Hub.

Type:

```hcl
map(object({
    service_tag = string
    protocol    = optional(string, "TCP")
    port_range  = optional(string, "443")
  }))
```

Default: `{}`

### <a name="input_ai_studio_hub_provision_managed_network"></a> [ai\_studio\_hub\_provision\_managed\_network](#input\_ai\_studio\_hub\_provision\_managed\_network)

Description: Specifies whether the managed vnet should be provisioned as part of the ai studio hub deployment.

Type: `bool`

Default: `false`

## Outputs

No outputs.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->