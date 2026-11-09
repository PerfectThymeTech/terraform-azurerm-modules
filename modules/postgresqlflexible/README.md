<!-- BEGIN_TF_DOCS -->
# 📊 Azure Postgresql Flexible Server Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-postgresqlflexible.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-postgresqlflexible.yml)

Deploys a PostgreSQL flexible server with Microsoft Entra ID authentication only and private endpoint connectivity, plus optional databases and server parameters.

## 📦 Overview

- An Azure Database for PostgreSQL flexible server (`azurerm_postgresql_flexible_server`).
- Optional databases (`postgresql_databases`), server parameters (`postgresql_configuration`) and a Microsoft Entra group administrator.
- A private endpoint for the `postgresqlServer` subresource and optional diagnostic settings.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Public network access is disabled.
- Password authentication is disabled and Microsoft Entra ID authentication is enabled; no administrator login or password is set.
- The private endpoint uses automatic approval.
- Backups are kept for 30 days by default (`postgresql_backup_retention_days`, validated between 7 and 35).
- Customer-managed key (`customer_managed_key`) and diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- No input re-enables public network access or password authentication.
- `postgresql_configuration` passes arbitrary server parameters (no validation). *Reason:* not stated in the module code. *Mitigation:* review the parameters in code review, because the module does not validate them.
- With the default `postgresql_active_directory_administrator = {}` no Microsoft Entra administrator is created, while password authentication is disabled. Set both `object_id` and `group_name` to create one.
- Known issue: the customer-managed key block passes the Key Vault resource ID where a key ID is expected, so the key configuration does not receive the key ID.
- Known issue: the `postgresql_storage_tier` validation compares `postgresql_storage_mb` instead of the tier, so any non-null tier fails validation.

**Prerequisites**

- `subnet_id`: the resource ID of the subnet for the private endpoint. The server itself is not injected into the virtual network.
- Optional private Domain Name System (DNS) zone ID in `private_dns_zone_id_postrgesql` (the variable name is spelled this way), ending in `privatelink.postgres.database.azure.com`. It is not required when DNS A-records are created through Azure Policy.
- `postgresql_active_directory_administrator` needs both `object_id` and `group_name` (a Microsoft Entra group), or neither.

## 🚀 Usage

```hcl
module "postgresql_flexible" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/postgresqlflexible?ref=<release-tag>"

  location            = "<azure-region>"
  resource_group_name = "<resource-group-name>"
  postgresql_name     = "<postgresql-server-name>"
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

- [azurerm_monitor_diagnostic_setting.diagnostic_setting_postgresql_flexible_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_postgresql_flexible_server.postgresql_flexible_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server) (resource)
- [azurerm_postgresql_flexible_server_active_directory_administrator.postgresql_flexible_server_active_directory_administrator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_active_directory_administrator) (resource)
- [azurerm_postgresql_flexible_server_configuration.postgresql_flexible_server_configuration](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration) (resource)
- [azurerm_postgresql_flexible_server_database.postgresql_flexible_server_database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_database) (resource)
- [azurerm_private_endpoint.private_endpoint_postgresql_flexible_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [time_sleep.sleep_connectivity](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_monitor_diagnostic_categories.diagnostic_categories_postgresql_flexible_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) (data source)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input\_location)

Description: Specifies the location of all resources.

Type: `string`

### <a name="input_postgresql_name"></a> [postgresql\_name](#input\_postgresql\_name)

Description: Specifies the name of the postgresql flexible server.

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

### <a name="input_postgresql_active_directory_administrator"></a> [postgresql\_active\_directory\_administrator](#input\_postgresql\_active\_directory\_administrator)

Description: Specifies the entra id admin configuration for the postgresql flexible server. Please provide a group name and the object id of teh group.

Type:

```hcl
object({
    object_id  = optional(string, "")
    group_name = optional(string, "")
  })
```

Default: `{}`

### <a name="input_postgresql_auto_grow_enabled"></a> [postgresql\_auto\_grow\_enabled](#input\_postgresql\_auto\_grow\_enabled)

Description: Specifies whether auto grow is enabled for the postgresql flexible server.

Type: `bool`

Default: `false`

### <a name="input_postgresql_backup_retention_days"></a> [postgresql\_backup\_retention\_days](#input\_postgresql\_backup\_retention\_days)

Description: Specifies the backup retention in days of the postgresql flexible server.

Type: `number`

Default: `30`

### <a name="input_postgresql_configuration"></a> [postgresql\_configuration](#input\_postgresql\_configuration)

Description: Specifies the configuration of the postgresql flexible server.

Type: `map(string)`

Default: `{}`

### <a name="input_postgresql_databases"></a> [postgresql\_databases](#input\_postgresql\_databases)

Description: Specifies the databases of the postgresql flexible server.

Type:

```hcl
map(object({
    charset   = optional(string, "UTF8")
    collation = optional(string, "en_US.utf8")
  }))
```

Default: `{}`

### <a name="input_postgresql_geo_redundant_backup_enabled"></a> [postgresql\_geo\_redundant\_backup\_enabled](#input\_postgresql\_geo\_redundant\_backup\_enabled)

Description: Specifies whether the geo redundant backup should be enabled for the postgresql storage account.

Type: `bool`

Default: `false`

### <a name="input_postgresql_high_availability_mode"></a> [postgresql\_high\_availability\_mode](#input\_postgresql\_high\_availability\_mode)

Description: Specifies whether zone redundancy should be enabled for the postgresql flexible server.

Type: `string`

Default: `"ZoneRedundant"`

### <a name="input_postgresql_maintenance_window"></a> [postgresql\_maintenance\_window](#input\_postgresql\_maintenance\_window)

Description: Specifies the maintenance window for the postgresql flexible server.

Type:

```hcl
object({
    day_of_week  = optional(number, 6)
    start_hour   = optional(number, 0)
    start_minute = optional(number, 0)
  })
```

Default: `{}`

### <a name="input_postgresql_sku_name"></a> [postgresql\_sku\_name](#input\_postgresql\_sku\_name)

Description: Specifies the sku of the postgresql flexible server.

Type: `string`

Default: `"B_Standard_B1ms"`

### <a name="input_postgresql_storage_mb"></a> [postgresql\_storage\_mb](#input\_postgresql\_storage\_mb)

Description: Specifies the storage mb of the postgresql flexible server.

Type: `number`

Default: `32768`

### <a name="input_postgresql_storage_tier"></a> [postgresql\_storage\_tier](#input\_postgresql\_storage\_tier)

Description: Specifies the storage tier of the postgresql flexible server.

Type: `string`

Default: `null`

### <a name="input_postgresql_version"></a> [postgresql\_version](#input\_postgresql\_version)

Description: Specifies the version of the postgresql flexible server.

Type: `number`

Default: `16`

### <a name="input_postgresql_zone_redundancy_enabled"></a> [postgresql\_zone\_redundancy\_enabled](#input\_postgresql\_zone\_redundancy\_enabled)

Description: Specifies whether zone redundancy should be enabled for the postgresql flexible server.

Type: `bool`

Default: `false`

### <a name="input_private_dns_zone_id_postrgesql"></a> [private\_dns\_zone\_id\_postrgesql](#input\_private\_dns\_zone\_id\_postrgesql)

Description: Specifies the resource ID of the private DNS zone for Azure Postgresql flexible server. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_postgresql_flexible_server_fqdn"></a> [postgresql\_flexible\_server\_fqdn](#output\_postgresql\_flexible\_server\_fqdn)

Description: Specifies the fqdn of the postgres flexible server.

### <a name="output_postgresql_flexible_server_id"></a> [postgresql\_flexible\_server\_id](#output\_postgresql\_flexible\_server\_id)

Description: Specifies the resource id of the postgres flexible server.

### <a name="output_postgresql_flexible_server_name"></a> [postgresql\_flexible\_server\_name](#output\_postgresql\_flexible\_server\_name)

Description: Specifies the resource name of the postgres flexible server.

### <a name="output_postgresql_flexible_server_setup_completed"></a> [postgresql\_flexible\_server\_setup\_completed](#output\_postgresql\_flexible\_server\_setup\_completed)

Description: Specifies whether the connectivity and identity has been successfully configured.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->