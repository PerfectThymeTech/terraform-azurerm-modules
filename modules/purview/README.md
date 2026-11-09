<!-- BEGIN_TF_DOCS -->
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
- Optional private Domain Name System (DNS) zone IDs ending in `privatelink.purview-service.microsoft.com` (`private_dns_zone_id_purview_platform`), `privatelink.blob.core.windows.net` (`private_dns_zone_id_blob`) and `privatelink.queue.core.windows.net` (`private_dns_zone_id_queue`). They are not required when DNS A-records are created through Azure Policy.
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

- [azapi_resource.purview_account](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource_action.purview_account_root_collection_admin](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource_action) (resource)
- [azurerm_monitor_diagnostic_setting.diagnostic_setting_purview_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_private_endpoint.private_endpoint_purview_account_ingestion_storage_blob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.private_endpoint_purview_account_ingestion_storage_queue](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.private_endpoint_purview_account_platform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [time_sleep.sleep_connectivity](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_monitor_diagnostic_categories.diagnostic_categories_purview_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) (data source)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input\_location)

Description: Specifies the location of all resources.

Type: `string`

### <a name="input_purview_account_name"></a> [purview\_account\_name](#input\_purview\_account\_name)

Description: Specifies the name of the Purview account.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: Specifies the resource group name in which all resources will get deployed.

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

### <a name="input_location_private_endpoint"></a> [location\_private\_endpoint](#input\_location\_private\_endpoint)

Description: Specifies the location of the private endpoint. Use this variables only if the private endpoint(s) should reside in a different location than the service itself.

Type: `string`

Default: `null`

### <a name="input_private_dns_zone_id_blob"></a> [private\_dns\_zone\_id\_blob](#input\_private\_dns\_zone\_id\_blob)

Description: Specifies the resource ID of the private DNS zone for Azure Storage blob endpoints. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_purview_platform"></a> [private\_dns\_zone\_id\_purview\_platform](#input\_private\_dns\_zone\_id\_purview\_platform)

Description: Specifies the resource ID of the private DNS zone for Azure Key Vault. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_queue"></a> [private\_dns\_zone\_id\_queue](#input\_private\_dns\_zone\_id\_queue)

Description: Specifies the resource ID of the private DNS zone for Azure Storage queue endpoints. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_purview_account_root_collection_admins"></a> [purview\_account\_root\_collection\_admins](#input\_purview\_account\_root\_collection\_admins)

Description: Specifies the root collection admins of the Purview account.

Type:

```hcl
map(object({
    object_id = string
  }))
```

Default: `{}`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_purview_account_endpoints_catalog"></a> [purview\_account\_endpoints\_catalog](#output\_purview\_account\_endpoints\_catalog)

Description: Specifies the purview account catalog endpoint.

### <a name="output_purview_account_endpoints_scan"></a> [purview\_account\_endpoints\_scan](#output\_purview\_account\_endpoints\_scan)

Description: Specifies the purview account scan endpoint.

### <a name="output_purview_account_id"></a> [purview\_account\_id](#output\_purview\_account\_id)

Description: Specifies the purview account id.

### <a name="output_purview_account_ingestion_storage_id"></a> [purview\_account\_ingestion\_storage\_id](#output\_purview\_account\_ingestion\_storage\_id)

Description: Specifies the purview account ingestion storage id.

### <a name="output_purview_account_ingestion_storage_primary_endpoint"></a> [purview\_account\_ingestion\_storage\_primary\_endpoint](#output\_purview\_account\_ingestion\_storage\_primary\_endpoint)

Description: Specifies the purview account ingestion storage id.

### <a name="output_purview_account_name"></a> [purview\_account\_name](#output\_purview\_account\_name)

Description: Specifies the purview account name.

### <a name="output_purview_account_principal_id"></a> [purview\_account\_principal\_id](#output\_purview\_account\_principal\_id)

Description: Specifies the purview account name.

### <a name="output_purview_account_setup_completed"></a> [purview\_account\_setup\_completed](#output\_purview\_account\_setup\_completed)

Description: Specifies whether the connectivity and identity has been successfully configured.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->