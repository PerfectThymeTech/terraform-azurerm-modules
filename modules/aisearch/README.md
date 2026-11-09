<!-- BEGIN_TF_DOCS -->
# 🤖 Azure AI Search Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-aisearch.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-aisearch.yml)

Deploys a private-only Azure AI Search service with optional shared private links that a script can approve.

## 📦 Overview

- An Azure AI Search service with a system-assigned managed identity.
- A private endpoint for the `searchService` subresource and optional diagnostic settings.
- Optional shared private links to other resources and, for links with `approve = true`, a PowerShell step that approves the connection on the target resource.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Public network access is disabled and no Internet Protocol (IP) addresses are allowed.
- Application programming interface (API) key (local) authentication is off (`search_service_local_authentication_enabled` defaults to `false`).
- The service uses a system-assigned managed identity.
- The private endpoint is always created.
- Diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- The network rule bypass option is hard-coded to `AzureServices`; there is no variable to change it. *Reason:* not stated in the module code. *Mitigation:* limit what trusted Azure services can do with Azure role-based access control.
- `search_service_local_authentication_enabled = true` enables key-based authentication. *Reason:* not stated in the module code. *Mitigation:* keep it `false` and use Microsoft Entra ID with Azure role-based access control; if keys are unavoidable, store and rotate them in a key vault.
- Shared private links with `approve = true` run PowerShell and the Azure command-line interface (CLI) on the machine that runs Terraform (see [Scripted steps](../../docs/scripted-steps.md)). *Reason:* not stated in the module code. *Mitigation:* run Terraform from a trusted machine or pipeline whose identity can approve only the connections you intend.
- Known issue: `customer_managed_key` only switches on customer-managed key enforcement. The key fields are not used by any resource, and the module has no role assignment for the key.

**Prerequisites**

- `subnet_id`: the resource identifier (ID) of the subnet for the private endpoint.
- Optional `private_dns_zone_id_search_service` (`privatelink.search.windows.net`). It is not required when Domain Name System (DNS) A-records are created through Azure Policy.
- Each shared private link needs a `target_resource_id` and a `subresource_name`.
- For `approve = true`: `pwsh` and the Azure CLI (`az`), signed in, on the machine that runs Terraform.

## 🚀 Usage

```hcl
module "ai_search" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/aisearch?ref=<release-tag>"

  location            = "<azure-region>"
  resource_group_name = "<resource-group-name>"
  search_service_name = "<search-service-name>"
  subnet_id           = "<subnet-resource-id>"
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).

## 📚 Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>=0.12)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 5.0)

- <a name="requirement_time"></a> [time](#requirement\_time) (~> 0.9)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 5.0)

- <a name="provider_null"></a> [null](#provider\_null)

- <a name="provider_time"></a> [time](#provider\_time) (~> 0.9)

## Resources

The following resources are used by this module:

- [azurerm_monitor_diagnostic_setting.diagnostic_setting_search_service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_private_endpoint.private_endpoint_search_service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_search_service.search_service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/search_service) (resource)
- [azurerm_search_shared_private_link_service.search_shared_private_link_service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/search_shared_private_link_service) (resource)
- [null_resource.search_shared_private_link_service_approval](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) (resource)
- [time_sleep.sleep_connectivity](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_monitor_diagnostic_categories.diagnostic_categories_search_service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) (data source)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input\_location)

Description: Specifies the location of all resources.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: Specifies the resource group name in which all resources will get deployed.

Type: `string`

### <a name="input_search_service_name"></a> [search\_service\_name](#input\_search\_service\_name)

Description: Specifies the name of the search service.

Type: `string`

### <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id)

Description: Specifies the resource id of a subnet in which the private endpoints get created.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

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

### <a name="input_private_dns_zone_id_search_service"></a> [private\_dns\_zone\_id\_search\_service](#input\_private\_dns\_zone\_id\_search\_service)

Description: Specifies the resource ID of the private DNS zone for Azure Cognitive Search endpoints. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_search_service_authentication_failure_mode"></a> [search\_service\_authentication\_failure\_mode](#input\_search\_service\_authentication\_failure\_mode)

Description: Specifies the authentication failure mode for the search service

Type: `string`

Default: `null`

### <a name="input_search_service_hosting_mode"></a> [search\_service\_hosting\_mode](#input\_search\_service\_hosting\_mode)

Description: Specifies the hosting mode for the search service

Type: `string`

Default: `"default"`

### <a name="input_search_service_local_authentication_enabled"></a> [search\_service\_local\_authentication\_enabled](#input\_search\_service\_local\_authentication\_enabled)

Description: Specifies whether local auth should be enabled for the search service

Type: `bool`

Default: `false`

### <a name="input_search_service_partition_count"></a> [search\_service\_partition\_count](#input\_search\_service\_partition\_count)

Description: Specifies the number of partitions in the search service.

Type: `number`

Default: `1`

### <a name="input_search_service_replica_count"></a> [search\_service\_replica\_count](#input\_search\_service\_replica\_count)

Description: Specifies the number of replicas in the search service.

Type: `number`

Default: `1`

### <a name="input_search_service_semantic_search_sku"></a> [search\_service\_semantic\_search\_sku](#input\_search\_service\_semantic\_search\_sku)

Description: Specifies the semantic search SKU for the search service

Type: `string`

Default: `"standard"`

### <a name="input_search_service_shared_private_links"></a> [search\_service\_shared\_private\_links](#input\_search\_service\_shared\_private\_links)

Description: Specifies the shared private links that should be connected to the search service.

Type:

```hcl
map(object({
    subresource_name   = string
    target_resource_id = string
    approve            = optional(bool, false)
  }))
```

Default: `{}`

### <a name="input_search_service_sku"></a> [search\_service\_sku](#input\_search\_service\_sku)

Description: Specifies the SKU for the search service

Type: `string`

Default: `"standard"`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_search_service_id"></a> [search\_service\_id](#output\_search\_service\_id)

Description: Specifies the resource id of the ai search service.

### <a name="output_search_service_name"></a> [search\_service\_name](#output\_search\_service\_name)

Description: Specifies the name of the ai search service.

### <a name="output_search_service_primary_key"></a> [search\_service\_primary\_key](#output\_search\_service\_primary\_key)

Description: Specifies the primary key of the ai search service.

### <a name="output_search_service_principal_id"></a> [search\_service\_principal\_id](#output\_search\_service\_principal\_id)

Description: Specifies the principal id of the ai search service.

### <a name="output_search_service_setup_completed"></a> [search\_service\_setup\_completed](#output\_search\_service\_setup\_completed)

Description: Specifies whether the connectivity and identity has been successfully configured.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->