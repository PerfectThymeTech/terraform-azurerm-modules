<!-- BEGIN_TF_DOCS -->
# 🔐 Azure Key Vault Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-keyvault.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-keyvault.yml)

Deploys a locked-down Azure Key Vault with role-based access control (RBAC) authorization, a private endpoint and a role assignment for the identity that runs Terraform.

## 📦 Overview

- An Azure Key Vault (`azurerm_key_vault`).
- A private endpoint for the `vault` subresource and optional diagnostic settings.
- A *Key Vault Administrator* role assignment on the vault for the identity that runs Terraform.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Public network access is disabled; no variable changes it.
- The firewall denies by default and has no Internet Protocol (IP) or virtual network rules.
- Purge protection is enabled, and soft delete retention is set by `key_vault_soft_delete_retention_days` (default `7`, minimum `7`).
- Authorization uses Azure RBAC; access policies are not used.
- Access for deployment, disk encryption and template deployment is off.
- The private endpoint uses automatic approval.
- Diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- The firewall bypass is hard-coded to `AzureServices`. *Reason:* not stated in the module code. *Mitigation:* limit what trusted Azure services can do with Azure role-based access control.
- The role assignment *Key Vault Administrator* for the identity running Terraform is always created. No variable disables it. *Reason:* not stated in the module code. *Mitigation:* limit who can run Terraform, because that identity becomes Key Vault Administrator.

**Prerequisites**

- `subnet_id`: the resource identifier (ID) of the subnet for the private endpoint.
- Optional `private_dns_zone_id_vault` ending in `privatelink.vaultcore.azure.net`. It is not required when Domain Name System (DNS) A-records are created through Azure Policy.
- The identity that runs Terraform must be allowed to create the role assignment on the vault.

## 🚀 Usage

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

- [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) (resource)
- [azurerm_monitor_diagnostic_setting.diagnostic_setting_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_private_endpoint.private_endpoint_cognitive_account_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_role_assignment.current_roleassignment_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [time_sleep.sleep_connectivity](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_monitor_diagnostic_categories.diagnostic_categories_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) (data source)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name)

Description: Specifies the name of the Key Vault. Changing this forces a new resource to be created.

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

### <a name="input_key_vault_sku_name"></a> [key\_vault\_sku\_name](#input\_key\_vault\_sku\_name)

Description: Specifies the name of the SKU used for this Key Vault. Possible values are standard and premium.

Type: `string`

Default: `"standard"`

### <a name="input_key_vault_soft_delete_retention_days"></a> [key\_vault\_soft\_delete\_retention\_days](#input\_key\_vault\_soft\_delete\_retention\_days)

Description: Specifies the number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days.

Type: `number`

Default: `7`

### <a name="input_private_dns_zone_id_vault"></a> [private\_dns\_zone\_id\_vault](#input\_private\_dns\_zone\_id\_vault)

Description: Specifies the resource ID of the private DNS zone for Azure Key Vault. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id)

Description: Specifies the key vault resource id.

### <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name)

Description: Specifies the key vault resource name.

### <a name="output_key_vault_setup_completed"></a> [key\_vault\_setup\_completed](#output\_key\_vault\_setup\_completed)

Description: Specifies whether the connectivity and identity has been successfully configured.

### <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri)

Description: Specifies the key vault resource vault uri.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->