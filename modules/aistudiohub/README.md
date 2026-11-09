<!-- BEGIN_TF_DOCS -->
# 🤖 Azure AI Studio Hub Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-aistudiohub.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-aistudiohub.yml)

Deploys a network-isolated Azure AI Hub workspace with a private endpoint, optional shared connections and optional managed network provisioning.

## 📦 Overview

- An Azure AI Hub (`Microsoft.MachineLearningServices/workspaces`, kind `Hub`) deployed through the `azapi` provider.
- A private endpoint for the `amlworkspace` subresource and optional diagnostic settings.
- Optional hub connections and an optional `provisionManagedNetwork` action.
- User-defined outbound rules are managed by the separate [Azure AI Studio Outbound Rules](../aistudiooutboundrules/) module.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Public network access is disabled, access when behind a virtual network is not allowed and the Internet Protocol (IP) allow list is empty.
- The managed network only allows approved outbound traffic (`AllowOnlyApprovedOutbound`) and starts with no outbound rules.
- System datastores authenticate with the workspace identity.
- Data isolation and the high business impact flag are enabled.
- The hub uses a system-assigned managed identity.
- The private endpoint is always created.
- Connections authenticate with Microsoft Entra ID (`AAD`) by default.
- Diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- `ai_studio_hub_connections[*].auth_type` can be set to credential-based types (for example `AccessKey`, `ApiKey` or `ServicePrincipal`) together with `credentials`. Note that `ai_studio_hub_connections` is not marked sensitive. *Reason:* not stated in the module code. *Mitigation:* prefer `AAD`; if credentials are needed, pass them from a secret store and never commit them.
- Every connection is shared with all projects of the hub (`isSharedToAll = true`, hard-coded). *Reason:* the variable description says to provide only connections that are shared with all projects at hub level. *Mitigation:* create project-specific connections with the `aistudioproject` module.
- The module has a `customer_managed_key` input, although the note below states that customer-managed key (CMK) deployments are not supported for hub workspaces today.

**Prerequisites**

- Existing resources: `application_insights_id`, `container_registry_id`, `key_vault_id` and `storage_account_id`, plus `subnet_id` for the private endpoint.
- Optional private Domain Name System (DNS) zone IDs `private_dns_zone_id_machine_learning_api` (`privatelink.api.azureml.ms`) and `private_dns_zone_id_machine_learning_notebooks` (`privatelink.notebooks.azure.net`). The DNS zone group is only created when both are set.

> [!WARNING]
> **Info for CMK Deployments**
>
> CMK deployments are currently not supported because the service-side encryption of metadata is not supported for hub workspaces today. Once this is supported, we can update the module and enable CMK deployments. More details: https://learn.microsoft.com/en-us/azure/machine-learning/concept-customer-managed-keys?view=azureml-api-2#preview-service-side-encryption-of-metadata
>
> The standard deployment is currently blocked because of a managed Cosmos DB that gets created inside the customer environment. The workspace requires the asignment of a contributor role on that managed resource group in which the cosmos DB will reside. This assignment is currently being blocked by Azure Policies.

> [!NOTE]
> **Info for user-defined outbound rule management**
>
> We have decided to manage the outbund rules using a separate Terraform module. Reasons for this decision and the module can be found here: [Azure AI Studio Outbound Rules](/modules/aistudiooutboundrules/)

## 🚀 Usage

```hcl
module "ai_studio_hub" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/aistudiohub?ref=<release-tag>"

  location                = "<azure-region>"
  resource_group_name     = "<resource-group-name>"
  ai_studio_hub_name      = "<hub-name>"
  application_insights_id = "<application-insights-resource-id>"
  container_registry_id   = "<container-registry-resource-id>"
  key_vault_id            = "<key-vault-resource-id>"
  storage_account_id      = "<storage-account-resource-id>"
  subnet_id               = "<subnet-resource-id>"
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

- <a name="requirement_time"></a> [time](#requirement\_time) (~> 0.9)

## Providers

The following providers are used by this module:

- <a name="provider_azapi"></a> [azapi](#provider\_azapi) (~> 2.0)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 5.0)

- <a name="provider_time"></a> [time](#provider\_time) (~> 0.9)

## Resources

The following resources are used by this module:

- [azapi_resource.ai_studio_hub](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource.ai_studio_hub_connections](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource_action.ai_studio_hub_provision_managed_network](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource_action) (resource)
- [azurerm_monitor_diagnostic_setting.diagnostic_setting_ai_studio_hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_private_endpoint.private_endpoint_ai_studio_hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [time_sleep.sleep_connectivity](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_monitor_diagnostic_categories.diagnostic_categories_ai_studio_hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) (data source)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_ai_studio_hub_name"></a> [ai\_studio\_hub\_name](#input\_ai\_studio\_hub\_name)

Description: Specifies the name of the ai studio hub.

Type: `string`

### <a name="input_application_insights_id"></a> [application\_insights\_id](#input\_application\_insights\_id)

Description: Specifies the id of application insights that will be connected to the ai studio hub.

Type: `string`

### <a name="input_container_registry_id"></a> [container\_registry\_id](#input\_container\_registry\_id)

Description: Specifies the id of the container registry that will be connected to the ai studio hub.

Type: `string`

### <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id)

Description: Specifies the id of the key vaul that will be connected to the ai studio hub.

Type: `string`

### <a name="input_location"></a> [location](#input\_location)

Description: Specifies the location of all resources.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: Specifies the resource group name in which all resources will get deployed.

Type: `string`

### <a name="input_storage_account_id"></a> [storage\_account\_id](#input\_storage\_account\_id)

Description: Specifies the id of the storage account that will be connected to the ai studio hub.

Type: `string`

### <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id)

Description: Specifies the resource id of a subnet in which the private endpoints get created.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_ai_studio_hub_connections"></a> [ai\_studio\_hub\_connections](#input\_ai\_studio\_hub\_connections)

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

### <a name="input_ai_studio_hub_provision_managed_network"></a> [ai\_studio\_hub\_provision\_managed\_network](#input\_ai\_studio\_hub\_provision\_managed\_network)

Description: Specifies whether the managed vnet should be providioned as part of the ai studio hub deployment.

Type: `bool`

Default: `false`

### <a name="input_connectivity_delay_in_seconds"></a> [connectivity\_delay\_in\_seconds](#input\_connectivity\_delay\_in\_seconds)

Description: Specifies the delay in seconds after the private endpoint deployment (required for the DNS automation via Policies).

Type: `number`

Default: `120`

### <a name="input_customer_managed_key"></a> [customer\_managed\_key](#input\_customer\_managed\_key)

Description: Specifies the customer managed key configurations.

Type:

```hcl
object({
    key_vault_id                     = string,
    key_vault_key_id                 = string,
    key_vault_key_versionless_id     = string,
    user_assigned_identity_id        = string,
    user_assigned_identity_client_id = string,
  })
```

Default: `null`

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

### <a name="input_private_dns_zone_id_machine_learning_api"></a> [private\_dns\_zone\_id\_machine\_learning\_api](#input\_private\_dns\_zone\_id\_machine\_learning\_api)

Description: Specifies the resource ID of the private DNS zone for the Purview account. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_machine_learning_notebooks"></a> [private\_dns\_zone\_id\_machine\_learning\_notebooks](#input\_private\_dns\_zone\_id\_machine\_learning\_notebooks)

Description: Specifies the resource ID of the private DNS zone for the Purview account. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_ai_studio_hub_id"></a> [ai\_studio\_hub\_id](#output\_ai\_studio\_hub\_id)

Description: Specifies the resource id of the ai studio hub.

### <a name="output_ai_studio_hub_name"></a> [ai\_studio\_hub\_name](#output\_ai\_studio\_hub\_name)

Description: Specifies the name of the ai studio hub.

### <a name="output_ai_studio_hub_principal_id"></a> [ai\_studio\_hub\_principal\_id](#output\_ai\_studio\_hub\_principal\_id)

Description: Specifies the principal id of the ai studio hub.

### <a name="output_ai_studio_hub_setup_completed"></a> [ai\_studio\_hub\_setup\_completed](#output\_ai\_studio\_hub\_setup\_completed)

Description: Specifies whether the connectivity and identity has been successfully configured.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->