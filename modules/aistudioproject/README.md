<!-- BEGIN_TF_DOCS -->
# 🤖 Azure AI Studio Project Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-aistudioproject.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-aistudioproject.yml)

Deploys an Azure AI Project attached to an existing Azure AI Hub, with optional project-level connections.

## 📦 Overview

- An Azure AI Project (`Microsoft.MachineLearningServices/workspaces`, kind `Project`) deployed through the `azapi` provider and linked to the hub in `ai_studio_hub_id`.
- Optional project connections and optional diagnostic settings.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- The project uses a system-assigned managed identity.
- Connections are not shared with other projects (`isSharedToAll = false`).
- Connections authenticate with Microsoft Entra ID (`AAD`) by default.
- Diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- `ai_studio_project_connections[*].auth_type` can be set to credential-based types (for example `AccessKey`, `ApiKey` or `ServicePrincipal`) together with `credentials`. Note that `ai_studio_project_connections` is not marked sensitive. *Reason:* not stated in the module code. *Mitigation:* prefer `AAD`; if credentials are needed, pass them from a secret store and never commit them.
- The module defines no private endpoint, network or customer-managed key settings.

**Prerequisites**

- An existing Azure AI Hub: `ai_studio_hub_id`.
- Connection targets (`ai_studio_project_connections[*].target`) must start with `https://`.

## 🚀 Usage

```hcl
module "ai_studio_project" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/aistudioproject?ref=<release-tag>"

  location               = "<azure-region>"
  resource_group_name    = "<resource-group-name>"
  ai_studio_project_name = "<project-name>"
  ai_studio_hub_id       = "<ai-hub-resource-id>"
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

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 5.0)

## Providers

The following providers are used by this module:

- <a name="provider_azapi"></a> [azapi](#provider\_azapi) (~> 2.0)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 5.0)

## Resources

The following resources are used by this module:

- [azapi_resource.ai_studio_project](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource.ai_studio_project_connection](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) (resource)
- [azurerm_monitor_diagnostic_setting.diagnostic_setting_ai_studio_project](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_monitor_diagnostic_categories.diagnostic_categories_ai_studio_project](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) (data source)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_ai_studio_hub_id"></a> [ai\_studio\_hub\_id](#input\_ai\_studio\_hub\_id)

Description: Specifies the resource id of the ai studio hub.

Type: `string`

### <a name="input_ai_studio_project_name"></a> [ai\_studio\_project\_name](#input\_ai\_studio\_project\_name)

Description: Specifies the name of the ai studio project.

Type: `string`

### <a name="input_location"></a> [location](#input\_location)

Description: Specifies the location of all resources.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: Specifies the resource group name in which all resources will get deployed.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_ai_studio_project_connections"></a> [ai\_studio\_project\_connections](#input\_ai\_studio\_project\_connections)

Description: Specifies the connections that should be added to the AI Studio Hub. Only provide connections to be shared with all projects at the hub level.

Type:

```hcl
map(object({
    auth_type   = optional(string, "AAD")
    category    = string
    credentials = optional(any, null)
    target      = string
    metadata    = any
  }))
```

Default: `{}`

### <a name="input_diagnostics_configurations"></a> [diagnostics\_configurations](#input\_diagnostics\_configurations)

Description: Specifies the diagnostic configuration for the service.

Type:

```hcl
list(object({
    log_analytics_workspace_id = optional(string, ""),
    storage_account_id         = optional(string, "")
  }))
```

Default: `[]`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_ai_studio_project_id"></a> [ai\_studio\_project\_id](#output\_ai\_studio\_project\_id)

Description: Specifies the resource ID of the ai studio project.

### <a name="output_ai_studio_project_name"></a> [ai\_studio\_project\_name](#output\_ai\_studio\_project\_name)

Description: Specifies the name of the ai studio project.

### <a name="output_ai_studio_project_principal_id"></a> [ai\_studio\_project\_principal\_id](#output\_ai\_studio\_project\_principal\_id)

Description: Specifies the principal id of the ai studio project.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->