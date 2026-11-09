<!-- BEGIN_TF_DOCS -->
# 📊 Azure SQL Server Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-mssqlserver.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-mssqlserver.yml)

Deploys an Azure SQL logical server that is reachable only through a private endpoint and uses Microsoft Entra ID authentication only.

## 📦 Overview

- An Azure SQL logical server (`azurerm_mssql_server`) with a system-assigned managed identity.
- A server auditing policy that sends audit logs to Azure Monitor.
- A private endpoint for the `sqlServer` subresource and optional diagnostic settings.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Public network access is disabled.
- Microsoft Entra ID authentication only; no administrator login or password is set.
- The minimum Transport Layer Security (TLS) version is 1.2 and outbound network restriction is enabled.
- Express vulnerability assessment is enabled.
- Server auditing is enabled and sent to Azure Monitor.
- The private endpoint uses automatic approval.
- Customer-managed key for transparent data encryption (`customer_managed_key`) and diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- No input relaxes the network, TLS or authentication settings; they are hard-coded.
- The identity that runs Terraform becomes the Microsoft Entra administrator of the server. *Reason:* not stated in the module code. *Mitigation:* limit who can run Terraform, because that identity becomes the server administrator.
- `securityalertpolicy.tf` contains only commented-out code; no security alert policy or vulnerability assessment storage is deployed from it.

**Prerequisites**

- `subnet_id`: the resource ID of the subnet for the private endpoint.
- Optional `private_dns_zone_id_sqlserver` ending in `privatelink.database.windows.net`. It is not required when Domain Name System (DNS) A-records are created through Azure Policy.
- `customer_managed_key` needs a Key Vault key ID and a user-assigned identity ID. The module creates no role assignment or access policy for that identity.

## 🚀 Usage

```hcl
module "mssql_server" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/mssqlserver?ref=<release-tag>"

  location            = "<azure-region>"
  resource_group_name = "<resource-group-name>"
  mssql_server_name   = "<sql-server-name>"
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

- [azurerm_monitor_diagnostic_setting.diagnostic_setting_mssql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_mssql_server.mssql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) (resource)
- [azurerm_mssql_server_extended_auditing_policy.mssql_server_extended_auditing_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_extended_auditing_policy) (resource)
- [azurerm_private_endpoint.private_endpoint_mssql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [time_sleep.sleep_connectivity](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_monitor_diagnostic_categories.diagnostic_categories_mssql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) (data source)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input\_location)

Description: Specifies the location of all resources.

Type: `string`

### <a name="input_mssql_server_name"></a> [mssql\_server\_name](#input\_mssql\_server\_name)

Description: Specifies the name of the MSSQL Server. Changing this forces a new resource to be created.

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

### <a name="input_mssql_server_connection_policy"></a> [mssql\_server\_connection\_policy](#input\_mssql\_server\_connection\_policy)

Description: Specifies the connection policy for the MSSQL Server. Possible values are 'Default', 'Proxy', and 'Redirect'.

Type: `string`

Default: `"Default"`

### <a name="input_mssql_server_version"></a> [mssql\_server\_version](#input\_mssql\_server\_version)

Description: Specifies the version of the MSSQL Server. Possible values are '2.0', and '12.0'.

Type: `string`

Default: `"12.0"`

### <a name="input_private_dns_zone_id_sqlserver"></a> [private\_dns\_zone\_id\_sqlserver](#input\_private\_dns\_zone\_id\_sqlserver)

Description: Specifies the resource ID of the private DNS zone for Azure SQL Server. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_mssql_server_fqdn"></a> [mssql\_server\_fqdn](#output\_mssql\_server\_fqdn)

Description: Specifies the SQL Server fully qualified domain name.

### <a name="output_mssql_server_id"></a> [mssql\_server\_id](#output\_mssql\_server\_id)

Description: Specifies the SQL Server resource id.

### <a name="output_mssql_server_name"></a> [mssql\_server\_name](#output\_mssql\_server\_name)

Description: Specifies the SQL Server resource name.

### <a name="output_mssql_server_setup_completed"></a> [mssql\_server\_setup\_completed](#output\_mssql\_server\_setup\_completed)

Description: Specifies whether the connectivity and identity has been successfully configured.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->