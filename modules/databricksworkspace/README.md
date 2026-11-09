<!-- BEGIN_TF_DOCS -->
# 📊 Azure Databricks Workspace Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-databricksworkspace.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-databricksworkspace.yml)

Deploys a VNet-injected, premium Azure Databricks workspace without public access, with private endpoints and optional customer-managed keys.

## 📦 Overview

- An Azure Databricks workspace (`azurerm_databricks_workspace`, SKU `premium`) injected into an existing virtual network.
- Private endpoints for the UI and API, the DBFS `blob` and the DBFS `dfs` endpoints, and optionally for browser authentication.
- Optional diagnostic settings and, when `customer_managed_key` is set, customer-managed keys for managed disks, managed services and root DBFS with the required role assignments.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Public network access is disabled; no variable changes it.
- Clusters have no public IP and the workspace requires no Azure Databricks network security group rules.
- Infrastructure encryption and the DBFS storage firewall are enabled.
- Enhanced security and compliance is on: automatic cluster update, compliance security profile and enhanced security monitoring.
- Private endpoints for UI and API, DBFS `blob` and DBFS `dfs` are always created with automatic approval.
- Customer-managed keys (`customer_managed_key`) and diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- No input relaxes the network or encryption defaults. The browser authentication private endpoint is only created when `databricks_workspace_browser_authentication_private_endpoint_enabled` is `true` (default `false`).
- Known issue: `customer_managed_key` requires and validates `key_vault_key_versionless_id`, `user_assigned_identity_id` and `user_assigned_identity_client_id`, but no resource uses them. Only `key_vault_id` and `key_vault_key_id` are used.

**Prerequisites**

- An existing virtual network with a private and a public subnet (by name) and their network security group association IDs.
- An existing Azure Databricks access connector: `databricks_workspace_access_connector_id`.
- `subnet_id` for the private endpoints; optional `location_private_endpoint` when they must reside in another region.
- Optional private DNS zone IDs ending in `privatelink.azuredatabricks.net`, `privatelink.blob.core.windows.net` and `privatelink.dfs.core.windows.net`. They are not required when DNS A-records are created through Azure Policy.
- With `customer_managed_key` the module creates role assignments at the Key Vault scope, so the deploying identity must be allowed to create them.

## 🚀 Usage

```hcl
module "databricks_workspace" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/databricksworkspace?ref=<release-tag>"

  location                                                                = "<azure-region>"
  resource_group_name                                                     = "<resource-group-name>"
  databricks_workspace_name                                               = "<workspace-name>"
  databricks_workspace_access_connector_id                                = "<access-connector-resource-id>"
  databricks_workspace_virtual_network_id                                 = "<virtual-network-resource-id>"
  databricks_workspace_private_subnet_name                                = "<private-subnet-name>"
  databricks_workspace_private_subnet_network_security_group_association_id = "<private-subnet-nsg-association-resource-id>"
  databricks_workspace_public_subnet_name                                 = "<public-subnet-name>"
  databricks_workspace_public_subnet_network_security_group_association_id  = "<public-subnet-nsg-association-resource-id>"
  subnet_id                                                               = "<subnet-resource-id>"
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

- [azurerm_databricks_workspace.databricks_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace) (resource)
- [azurerm_databricks_workspace_root_dbfs_customer_managed_key.databricks_workspace_root_dbfs_customer_managed_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace_root_dbfs_customer_managed_key) (resource)
- [azurerm_monitor_diagnostic_setting.diagnostic_setting_databricks_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_private_endpoint.private_endpoint_databricks_workspace_browser_authentication](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.private_endpoint_databricks_workspace_databricks_ui_api](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.private_endpoint_databricks_workspace_dbfs_blob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.private_endpoint_databricks_workspace_dbfs_dfs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_role_assignment.role_assignment_key_vault_crypto_encryption_user_databricks_managed_disk_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.role_assignment_key_vault_crypto_encryption_user_databricks_storage_account_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [time_sleep.sleep_cmk](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) (resource)
- [time_sleep.sleep_connectivity](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) (resource)
- [azurerm_monitor_diagnostic_categories.diagnostic_categories_databricks_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) (data source)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_databricks_workspace_access_connector_id"></a> [databricks\_workspace\_access\_connector\_id](#input\_databricks\_workspace\_access\_connector\_id)

Description: Specifies the id of the databricks access connector used for accessing the dbfs.

Type: `string`

### <a name="input_databricks_workspace_name"></a> [databricks\_workspace\_name](#input\_databricks\_workspace\_name)

Description: Specifies the name of the Azure Databricks workspace.

Type: `string`

### <a name="input_databricks_workspace_private_subnet_name"></a> [databricks\_workspace\_private\_subnet\_name](#input\_databricks\_workspace\_private\_subnet\_name)

Description: Specifies the name private subnet of the Azure Databricks workspace.

Type: `string`

### <a name="input_databricks_workspace_private_subnet_network_security_group_association_id"></a> [databricks\_workspace\_private\_subnet\_network\_security\_group\_association\_id](#input\_databricks\_workspace\_private\_subnet\_network\_security\_group\_association\_id)

Description: Specifies the id of the network group association of the private subnet used for the Azure Databricks workspace.

Type: `string`

### <a name="input_databricks_workspace_public_subnet_name"></a> [databricks\_workspace\_public\_subnet\_name](#input\_databricks\_workspace\_public\_subnet\_name)

Description: Specifies the name public subnet of the Azure Databricks workspace.

Type: `string`

### <a name="input_databricks_workspace_public_subnet_network_security_group_association_id"></a> [databricks\_workspace\_public\_subnet\_network\_security\_group\_association\_id](#input\_databricks\_workspace\_public\_subnet\_network\_security\_group\_association\_id)

Description: Specifies the id of the network group association of the public subnet used for the Azure Databricks workspace.

Type: `string`

### <a name="input_databricks_workspace_virtual_network_id"></a> [databricks\_workspace\_virtual\_network\_id](#input\_databricks\_workspace\_virtual\_network\_id)

Description: Specifies the id of the virtual network used for the Azure Databricks workspace.

Type: `string`

### <a name="input_location"></a> [location](#input\_location)

Description: Specifies the location of all resources.

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

### <a name="input_databricks_workspace_browser_authentication_private_endpoint_enabled"></a> [databricks\_workspace\_browser\_authentication\_private\_endpoint\_enabled](#input\_databricks\_workspace\_browser\_authentication\_private\_endpoint\_enabled)

Description: Specifies whether the 'browser\_authentication' private endpoint should be deployed for the Azure Databricks workspace.

Type: `bool`

Default: `false`

### <a name="input_databricks_workspace_compliance_security_profile_standards"></a> [databricks\_workspace\_compliance\_security\_profile\_standards](#input\_databricks\_workspace\_compliance\_security\_profile\_standards)

Description: Specifies which enhanced compliance security profiles ('HIPAA', 'PCI\_DSS') should be enabled for the Azure Databricks workspace.

Type: `list(string)`

Default: `[]`

### <a name="input_databricks_workspace_machine_learning_workspace_id"></a> [databricks\_workspace\_machine\_learning\_workspace\_id](#input\_databricks\_workspace\_machine\_learning\_workspace\_id)

Description: Specifies the id of the databricks access connector used for accessing the dbfs.

Type: `string`

Default: `null`

### <a name="input_databricks_workspace_storage_account_sku_name"></a> [databricks\_workspace\_storage\_account\_sku\_name](#input\_databricks\_workspace\_storage\_account\_sku\_name)

Description: Specifies the storage account sku for the dbfs storage of the Azure Databricks workspace.

Type: `string`

Default: `"Standard_LRS"`

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

### <a name="input_private_dns_zone_id_databricks"></a> [private\_dns\_zone\_id\_databricks](#input\_private\_dns\_zone\_id\_databricks)

Description: Specifies the resource ID of the private DNS zone for Azure Databricks. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_dfs"></a> [private\_dns\_zone\_id\_dfs](#input\_private\_dns\_zone\_id\_dfs)

Description: Specifies the resource ID of the private DNS zone for Azure Storage dfs endpoints. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_databricks_workspace_completed"></a> [databricks\_workspace\_completed](#output\_databricks\_workspace\_completed)

Description: Specifies whether the connectivity and identity has been successfully configured.

### <a name="output_databricks_workspace_id"></a> [databricks\_workspace\_id](#output\_databricks\_workspace\_id)

Description: Specifies the resource id of the Azure Databricks workspace.

### <a name="output_databricks_workspace_managed_resource_group_id"></a> [databricks\_workspace\_managed\_resource\_group\_id](#output\_databricks\_workspace\_managed\_resource\_group\_id)

Description: Specifies the id of the managed resource group of the Azure Databricks workspace.

### <a name="output_databricks_workspace_managed_resource_group_name"></a> [databricks\_workspace\_managed\_resource\_group\_name](#output\_databricks\_workspace\_managed\_resource\_group\_name)

Description: Specifies the name of the managed resource group of the Azure Databricks workspace.

### <a name="output_databricks_workspace_managed_storage_account_name"></a> [databricks\_workspace\_managed\_storage\_account\_name](#output\_databricks\_workspace\_managed\_storage\_account\_name)

Description: Specifies the name of the managed dbfs storage account of the Azure Databricks workspace.

### <a name="output_databricks_workspace_name"></a> [databricks\_workspace\_name](#output\_databricks\_workspace\_name)

Description: Specifies the resource name of the Azure Databricks workspace.

### <a name="output_databricks_workspace_storage_account_identity_principal_id"></a> [databricks\_workspace\_storage\_account\_identity\_principal\_id](#output\_databricks\_workspace\_storage\_account\_identity\_principal\_id)

Description: Specifies the principal id of the managed dbfs storage account of the Azure Databricks workspace.

### <a name="output_databricks_workspace_workspace_id"></a> [databricks\_workspace\_workspace\_id](#output\_databricks\_workspace\_workspace\_id)

Description: Specifies the workspace id of the Azure Databricks workspace.

### <a name="output_databricks_workspace_workspace_url"></a> [databricks\_workspace\_workspace\_url](#output\_databricks\_workspace\_workspace\_url)

Description: Specifies the workspace url of the Azure Databricks workspace.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->