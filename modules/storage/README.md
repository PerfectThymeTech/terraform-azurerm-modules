<!-- BEGIN_TF_DOCS -->
# 📊 Azure Storage Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-storage.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-storage.yml)

Deploys a locked-down Azure Storage account with Microsoft Entra ID-first access, private endpoints and optional containers, static website and customer-managed key.

## 📦 Overview

- An Azure Storage account (`azurerm_storage_account`) with optional containers, static website and customer-managed key.
- One private endpoint per entry in `private_endpoint_subresource_names` (default `["blob"]`).
- A *Storage Blob Data Owner* role assignment for the identity that runs Terraform, used to create data plane artifacts.
- Optional diagnostic settings for the account and its `blob`, `file`, `table` and `queue` services.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Blob public access is disabled and containers are private.
- The network rules deny by default with no Internet Protocol (IP) or virtual network rules, and `bypass` defaults to `["None"]`.
- Shared key access is disabled (`storage_shared_access_key_enabled` defaults to `false`) and OAuth is the default authentication.
- Hypertext Transfer Protocol Secure (HTTPS) only and a minimum Transport Layer Security (TLS) version of 1.2; infrastructure encryption is enabled.
- Cross-tenant replication is disabled and the allowed copy scope defaults to `AAD`.
- Blob and container soft delete are enabled for 7 days by default.
- SSH File Transfer Protocol (SFTP) and Network File System version 3 (NFSv3) are disabled by default.
- The private endpoint for `blob` uses automatic approval.
- Customer-managed key (`customer_managed_key`) and diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- `storage_public_network_access_enabled` defaults to `true`. The network rules still deny by default, so the account is not open to the internet unless you add rules. *Reason:* not stated in the module code. *Mitigation:* set it to `false` when private endpoints cover all access, and add network rules only for known sources.
- `storage_shared_access_key_enabled = true` enables shared key access, and `storage_account_allowed_copy_scope = "All"` removes the copy scope restriction. *Reason:* not stated in the module code. *Mitigation:* keep shared key access off and use Microsoft Entra ID; keep the copy scope at `AAD`.
- `storage_network_bypass` (default `["None"]`), `storage_network_private_link_access` (default `[]`), `storage_blob_cors_rules` (default `{}`), `storage_sftp_enabled` and `storage_nfsv3_enabled` relax the corresponding settings. *Reason:* not stated in the module code. *Mitigation:* keep the defaults unless a workload needs the feature, and scope each rule narrowly.
- The shared access signature (SAS) policy is hard-coded to a one-day expiration period with the action `Log`. *Reason:* not stated in the module code. *Mitigation:* prefer Microsoft Entra ID authentication and monitor the logs for SAS use that exceeds the policy.
- Known issue: the diagnostic setting for the `file` service reads the diagnostic categories of the `blob` service.

**Prerequisites**

- `subnet_id`: the resource ID of the subnet for the private endpoints.
- Optional private Domain Name System (DNS) zone IDs `private_dns_zone_id_blob`, `_file`, `_table`, `_queue`, `_web` and `_dfs`, each validated against its `privatelink.<service>.core.windows.net` suffix. They are not required when DNS A-records are created through Azure Policy.
- `customer_managed_key` needs `key_vault_key_versionless_id` and `user_assigned_identity_id`. The module creates no role assignment for that identity.

## 🚀 Usage

```hcl
module "storage" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/storage?ref=<release-tag>"

  location             = "<azure-region>"
  resource_group_name  = "<resource-group-name>"
  storage_account_name = "<storageaccountname>"
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

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 5.0)

- <a name="requirement_time"></a> [time](#requirement\_time) (~> 0.9)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 5.0)

- <a name="provider_time"></a> [time](#provider\_time) (~> 0.9)

## Resources

The following resources are used by this module:

- [azurerm_monitor_diagnostic_setting.diagnostic_setting_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_monitor_diagnostic_setting.diagnostic_setting_storage_account_blob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_monitor_diagnostic_setting.diagnostic_setting_storage_account_file](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_monitor_diagnostic_setting.diagnostic_setting_storage_account_queue](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_monitor_diagnostic_setting.diagnostic_setting_storage_account_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_private_endpoint.private_endpoint_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_role_assignment.current_roleassignment_storage_blob_data_owner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_storage_account.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) (resource)
- [azurerm_storage_account_customer_managed_key.storage_account_customer_managed_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_customer_managed_key) (resource)
- [azurerm_storage_account_static_website.storage_account_static_website](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_static_website) (resource)
- [azurerm_storage_container.storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) (resource)
- [time_sleep.sleep_connectivity](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_monitor_diagnostic_categories.diagnostic_categories_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) (data source)
- [azurerm_monitor_diagnostic_categories.diagnostic_categories_storage_account_blob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) (data source)
- [azurerm_monitor_diagnostic_categories.diagnostic_categories_storage_account_file](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) (data source)
- [azurerm_monitor_diagnostic_categories.diagnostic_categories_storage_account_queue](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) (data source)
- [azurerm_monitor_diagnostic_categories.diagnostic_categories_storage_account_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) (data source)

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

### <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name)

Description: Specifies the name of the storage account.

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

### <a name="input_private_dns_zone_id_blob"></a> [private\_dns\_zone\_id\_blob](#input\_private\_dns\_zone\_id\_blob)

Description: Specifies the resource ID of the private DNS zone for Azure Storage blob endpoints. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_dfs"></a> [private\_dns\_zone\_id\_dfs](#input\_private\_dns\_zone\_id\_dfs)

Description: Specifies the resource ID of the private DNS zone for Azure Storage dfs endpoints. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_file"></a> [private\_dns\_zone\_id\_file](#input\_private\_dns\_zone\_id\_file)

Description: Specifies the resource ID of the private DNS zone for Azure Storage file endpoints. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_queue"></a> [private\_dns\_zone\_id\_queue](#input\_private\_dns\_zone\_id\_queue)

Description: Specifies the resource ID of the private DNS zone for Azure Storage queue endpoints. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_table"></a> [private\_dns\_zone\_id\_table](#input\_private\_dns\_zone\_id\_table)

Description: Specifies the resource ID of the private DNS zone for Azure Storage table endpoints. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_web"></a> [private\_dns\_zone\_id\_web](#input\_private\_dns\_zone\_id\_web)

Description: Specifies the resource ID of the private DNS zone for Azure Storage web endpoints. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_private_endpoint_subresource_names"></a> [private\_endpoint\_subresource\_names](#input\_private\_endpoint\_subresource\_names)

Description: Specifies a list of group ids for which private endpoints will be created (e.g. 'blob', 'file', etc.). If sub resource is defined a private endpoint will be created.

Type: `set(string)`

Default:

```json
[
  "blob"
]
```

### <a name="input_storage_access_tier"></a> [storage\_access\_tier](#input\_storage\_access\_tier)

Description: Specifies the access tier of the storage account. Valid options are 'Hot' and 'Cool' (Default: 'Hot').

Type: `string`

Default: `"Hot"`

### <a name="input_storage_account_allowed_copy_scope"></a> [storage\_account\_allowed\_copy\_scope](#input\_storage\_account\_allowed\_copy\_scope)

Description: Specifies the allowed copy scope of the storage account.

Type: `string`

Default: `"AAD"`

### <a name="input_storage_account_replication_type"></a> [storage\_account\_replication\_type](#input\_storage\_account\_replication\_type)

Description: Specifies the replication type of the storage account.

Type: `string`

Default: `"ZRS"`

### <a name="input_storage_account_tier"></a> [storage\_account\_tier](#input\_storage\_account\_tier)

Description: Specifies the account tier of the storage account.

Type: `string`

Default: `"Standard"`

### <a name="input_storage_account_type"></a> [storage\_account\_type](#input\_storage\_account\_type)

Description: Specifies the account tier of the storage account.

Type: `string`

Default: `"StorageV2"`

### <a name="input_storage_blob_change_feed_enabled"></a> [storage\_blob\_change\_feed\_enabled](#input\_storage\_blob\_change\_feed\_enabled)

Description: Specifies whether the blob change feed should be enabled.

Type: `bool`

Default: `false`

### <a name="input_storage_blob_container_delete_retention_in_days"></a> [storage\_blob\_container\_delete\_retention\_in\_days](#input\_storage\_blob\_container\_delete\_retention\_in\_days)

Description: Specifies the blob container delete retention policy in days (soft-delete).

Type: `number`

Default: `7`

### <a name="input_storage_blob_cors_rules"></a> [storage\_blob\_cors\_rules](#input\_storage\_blob\_cors\_rules)

Description: Specifies storage account blob cors rules.

Type:

```hcl
map(object({
    allowed_headers    = list(string)
    allowed_methods    = list(string)
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = optional(number, 1800)
  }))
```

Default: `{}`

### <a name="input_storage_blob_delete_retention_in_days"></a> [storage\_blob\_delete\_retention\_in\_days](#input\_storage\_blob\_delete\_retention\_in\_days)

Description: Specifies the blob delete retention policy in days (soft-delete).

Type: `number`

Default: `7`

### <a name="input_storage_blob_last_access_time_enabled"></a> [storage\_blob\_last\_access\_time\_enabled](#input\_storage\_blob\_last\_access\_time\_enabled)

Description: Specifies whether the blob last access time feature should be enabled.

Type: `bool`

Default: `false`

### <a name="input_storage_blob_versioning_enabled"></a> [storage\_blob\_versioning\_enabled](#input\_storage\_blob\_versioning\_enabled)

Description: Specifies whether the blob versioning feature should be enabled.

Type: `bool`

Default: `false`

### <a name="input_storage_container_names"></a> [storage\_container\_names](#input\_storage\_container\_names)

Description: Specifies the storage container names to create within the storage account.

Type: `list(string)`

Default: `[]`

### <a name="input_storage_is_hns_enabled"></a> [storage\_is\_hns\_enabled](#input\_storage\_is\_hns\_enabled)

Description: Specifies whetehr hierarchical namespace (Data Lake) should be enabled.

Type: `bool`

Default: `false`

### <a name="input_storage_network_bypass"></a> [storage\_network\_bypass](#input\_storage\_network\_bypass)

Description: Specifies bypass options for the storage account network rules. List can include "None", "AzureServices", "Metrics" and "Logs"

Type: `set(string)`

Default:

```json
[
  "None"
]
```

### <a name="input_storage_network_private_link_access"></a> [storage\_network\_private\_link\_access](#input\_storage\_network\_private\_link\_access)

Description: Specifies resource instance rules of the storage account.

Type: `set(string)`

Default: `[]`

### <a name="input_storage_nfsv3_enabled"></a> [storage\_nfsv3\_enabled](#input\_storage\_nfsv3\_enabled)

Description: Specifies whether NFSv3 should be enabled.

Type: `bool`

Default: `false`

### <a name="input_storage_public_network_access_enabled"></a> [storage\_public\_network\_access\_enabled](#input\_storage\_public\_network\_access\_enabled)

Description: Specifies whether the storage account should have public network access.

Type: `bool`

Default: `true`

### <a name="input_storage_sftp_enabled"></a> [storage\_sftp\_enabled](#input\_storage\_sftp\_enabled)

Description: Specifies whether the storage account should enable sftp.

Type: `bool`

Default: `false`

### <a name="input_storage_shared_access_key_enabled"></a> [storage\_shared\_access\_key\_enabled](#input\_storage\_shared\_access\_key\_enabled)

Description: Specifies whether the storage account should enable the shared key for access.

Type: `bool`

Default: `false`

### <a name="input_storage_static_website"></a> [storage\_static\_website](#input\_storage\_static\_website)

Description: Specifies the website configuration to enable static websites on the storage account.

Type:

```hcl
list(object({
    index_document     = string
    error_404_document = string
  }))
```

Default: `[]`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id)

Description: Specifies the resource id of the storage account.

### <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name)

Description: Specifies the resource name of the storage account.

### <a name="output_storage_account_primary_access_key"></a> [storage\_account\_primary\_access\_key](#output\_storage\_account\_primary\_access\_key)

Description: Specifies the primary access key of the storage account.

### <a name="output_storage_account_primary_blob_connection_string"></a> [storage\_account\_primary\_blob\_connection\_string](#output\_storage\_account\_primary\_blob\_connection\_string)

Description: Specifies the primary blob connection string of the storage account.

### <a name="output_storage_account_primary_blob_endpoint"></a> [storage\_account\_primary\_blob\_endpoint](#output\_storage\_account\_primary\_blob\_endpoint)

Description: Specifies the primary blob endpoint of the storage account.

### <a name="output_storage_account_primary_dfs_endpoint"></a> [storage\_account\_primary\_dfs\_endpoint](#output\_storage\_account\_primary\_dfs\_endpoint)

Description: Specifies the primary dfs endpoint of the storage account.

### <a name="output_storage_account_primary_file_endpoint"></a> [storage\_account\_primary\_file\_endpoint](#output\_storage\_account\_primary\_file\_endpoint)

Description: Specifies the primary file endpoint of the storage account.

### <a name="output_storage_account_primary_queue_endpoint"></a> [storage\_account\_primary\_queue\_endpoint](#output\_storage\_account\_primary\_queue\_endpoint)

Description: Specifies the primary queue endpoint of the storage account.

### <a name="output_storage_account_primary_table_endpoint"></a> [storage\_account\_primary\_table\_endpoint](#output\_storage\_account\_primary\_table\_endpoint)

Description: Specifies the primary table endpoint of the storage account.

### <a name="output_storage_account_primary_web_endpoint"></a> [storage\_account\_primary\_web\_endpoint](#output\_storage\_account\_primary\_web\_endpoint)

Description: Specifies the primary web endpoint of the storage account.

### <a name="output_storage_setup_completed"></a> [storage\_setup\_completed](#output\_storage\_setup\_completed)

Description: Specifies whether the connectivity and identity has been successfully configured.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->