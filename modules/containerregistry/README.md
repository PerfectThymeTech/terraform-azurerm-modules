<!-- BEGIN_TF_DOCS -->
# 🖥️ Azure Container Registry Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-containerregistry.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-containerregistry.yml)

Deploys a Premium Azure Container Registry that is reachable only through a private endpoint, with optional customer-managed key and diagnostic settings.

## 📦 Overview

- One container registry (`azurerm_container_registry`, SKU (pricing tier) `Premium`).
- A private endpoint for the `registry` subresource and a wait of `connectivity_delay_in_seconds` after it (default `120`).
- Optional diagnostic settings and optional customer-managed key encryption.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Public network access is disabled and the network rule set denies by default with no Internet Protocol (IP) rules.
- The admin account is disabled (`container_registry_admin_enabled` defaults to `false`).
- Anonymous pull is disabled (`container_registry_anonymous_pull_enabled` defaults to `false`).
- The private endpoint is always created with automatic approval.
- The registry uses a system-assigned managed identity (plus a user-assigned identity when `customer_managed_key` is set).
- Customer-managed key (`customer_managed_key`) and diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- `container_registry_admin_enabled = true` enables the admin account, and `container_registry_anonymous_pull_enabled = true` enables anonymous pull. *Reason:* not stated in the module code. *Mitigation:* keep both `false` and use Microsoft Entra ID and managed identities to pull images.
- The network rule bypass option is hard-coded to `AzureServices`; there is no variable to change it. *Reason:* not stated in the module code. *Mitigation:* limit what trusted Azure services can do with Azure role-based access control.
- Known issue: `customer_managed_key` requires and validates `key_vault_id` and `key_vault_key_id`, but only `key_vault_key_versionless_id`, `user_assigned_identity_id` and `user_assigned_identity_client_id` are used. The module creates no role assignment.

**Prerequisites**

- `subnet_id`: the resource ID of the subnet for the private endpoint.
- Optional `private_dns_zone_id_container_registry` ending in `privatelink.azurecr.io`. It is not required when Domain Name System (DNS) A-records are created through Azure Policy.

## 🚀 Usage

```hcl
module "container_registry" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/containerregistry?ref=<release-tag>"

  location                = "<azure-region>"
  resource_group_name     = "<resource-group-name>"
  container_registry_name = "<containerregistryname>"
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

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 5.0)

- <a name="requirement_time"></a> [time](#requirement\_time) (~> 0.9)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 5.0)

- <a name="provider_time"></a> [time](#provider\_time) (~> 0.9)

## Resources

The following resources are used by this module:

- [azurerm_container_registry.container_registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) (resource)
- [azurerm_monitor_diagnostic_setting.diagnostic_setting_container_registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_private_endpoint.container_registry_private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [time_sleep.sleep_connectivity](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) (resource)
- [azurerm_monitor_diagnostic_categories.diagnostic_categories_container_registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) (data source)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_container_registry_name"></a> [container\_registry\_name](#input\_container\_registry\_name)

Description: Specifies the name of the container registry.

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

### <a name="input_container_registry_admin_enabled"></a> [container\_registry\_admin\_enabled](#input\_container\_registry\_admin\_enabled)

Description: Specifies whether admin users should be enabled for the container registry.

Type: `bool`

Default: `false`

### <a name="input_container_registry_anonymous_pull_enabled"></a> [container\_registry\_anonymous\_pull\_enabled](#input\_container\_registry\_anonymous\_pull\_enabled)

Description: Specifies whether anonymous pull should be enabled for the container registry.

Type: `bool`

Default: `false`

### <a name="input_container_registry_data_endpoint_enabled"></a> [container\_registry\_data\_endpoint\_enabled](#input\_container\_registry\_data\_endpoint\_enabled)

Description: Specifies whether data pull should be enabled for the container registry.

Type: `bool`

Default: `false`

### <a name="input_container_registry_export_policy_enabled"></a> [container\_registry\_export\_policy\_enabled](#input\_container\_registry\_export\_policy\_enabled)

Description: Specifies whether export policy should be enabled for the container registry.

Type: `bool`

Default: `false`

### <a name="input_container_registry_quarantine_policy_enabled"></a> [container\_registry\_quarantine\_policy\_enabled](#input\_container\_registry\_quarantine\_policy\_enabled)

Description: Specifies whether quarantine policy should be enabled for the container registry.

Type: `bool`

Default: `false`

### <a name="input_container_registry_retention_policy_in_days"></a> [container\_registry\_retention\_policy\_in\_days](#input\_container\_registry\_retention\_policy\_in\_days)

Description: Specifies retention policy in days for the container registry.

Type: `number`

Default: `7`

### <a name="input_container_registry_zone_redundancy_enabled"></a> [container\_registry\_zone\_redundancy\_enabled](#input\_container\_registry\_zone\_redundancy\_enabled)

Description: Specifies whether zone redundancy should be enabled for the container registry.

Type: `bool`

Default: `false`

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

### <a name="input_private_dns_zone_id_container_registry"></a> [private\_dns\_zone\_id\_container\_registry](#input\_private\_dns\_zone\_id\_container\_registry)

Description: Specifies the resource ID of the private DNS zone for the container registry. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_container_registry_id"></a> [container\_registry\_id](#output\_container\_registry\_id)

Description: Specifies the resource id of the container registry.

### <a name="output_container_registry_name"></a> [container\_registry\_name](#output\_container\_registry\_name)

Description: Specifies the resource name of the container registry.

### <a name="output_container_registry_principal_id"></a> [container\_registry\_principal\_id](#output\_container\_registry\_principal\_id)

Description: Specifies the principal id of the container registry.

### <a name="output_container_registry_setup_completed"></a> [container\_registry\_setup\_completed](#output\_container\_registry\_setup\_completed)

Description: Specifies whether the connectivity and identity has been successfully configured.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->