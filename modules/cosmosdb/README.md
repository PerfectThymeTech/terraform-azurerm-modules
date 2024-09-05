<!-- BEGIN_TF_DOCS -->
# Azure Cosmos DB Terraform Module

## Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>=0.12)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 4.0.0)

- <a name="requirement_time"></a> [time](#requirement\_time) (>= 0.9.1)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_cosmosdb_account_geo_location"></a> [cosmosdb\_account\_geo\_location](#input\_cosmosdb\_account\_geo\_location)

Description: Specifies the geo locations for the cosmos db account.

Type:

```hcl
list(object({
    location          = string
    failover_priority = number
    zone_redundant    = optional(bool, false)
  }))
```

### <a name="input_cosmosdb_account_name"></a> [cosmosdb\_account\_name](#input\_cosmosdb\_account\_name)

Description: Specifies the name of the Cosmos DB Account. Changing this forces a new resource to be created.

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

### <a name="input_cosmosdb_account_analytical_storage_enabled"></a> [cosmosdb\_account\_analytical\_storage\_enabled](#input\_cosmosdb\_account\_analytical\_storage\_enabled)

Description: Specifies whether the analytical storage should be enabled for the cosmos db account.

Type: `bool`

Default: `false`

### <a name="input_cosmosdb_account_automatic_failover_enabled"></a> [cosmosdb\_account\_automatic\_failover\_enabled](#input\_cosmosdb\_account\_automatic\_failover\_enabled)

Description: Specifies whether the automatic failover should be enabled for the cosmos db account.

Type: `bool`

Default: `false`

### <a name="input_cosmosdb_account_backup"></a> [cosmosdb\_account\_backup](#input\_cosmosdb\_account\_backup)

Description: Specifies the cosmos db backup configuration.

Type:

```hcl
object({
    type                = optional(string, "Continuous"),
    tier                = optional(string, "Continuous7Days")
    storage_redundancy  = optional(string, null)
    retention_in_hours  = optional(number, null)
    interval_in_minutes = optional(number, null)
  })
```

Default:

```json
{
  "interval_in_minutes": null,
  "retention_in_hours": null,
  "storage_redundancy": null,
  "tier": "Continuous7Days",
  "type": "Continuous"
}
```

### <a name="input_cosmosdb_account_capabilities"></a> [cosmosdb\_account\_capabilities](#input\_cosmosdb\_account\_capabilities)

Description: Specifies the cpabilities to be enabled on the cosmos db account.

Type: `list(string)`

Default: `[]`

### <a name="input_cosmosdb_account_capacity_total_throughput_limit"></a> [cosmosdb\_account\_capacity\_total\_throughput\_limit](#input\_cosmosdb\_account\_capacity\_total\_throughput\_limit)

Description: Specifies the total throughput limit for the cosmos db account.

Type: `number`

Default: `-1`

### <a name="input_cosmosdb_account_consistency_policy"></a> [cosmosdb\_account\_consistency\_policy](#input\_cosmosdb\_account\_consistency\_policy)

Description: Specifies the cosmos db consistency policy.

Type:

```hcl
object({
    consistency_level       = optional(string, "Strong"),
    max_interval_in_seconds = optional(number, null)
    max_staleness_prefix    = optional(number, null)
  })
```

Default:

```json
{
  "consistency_level": "Strong",
  "max_interval_in_seconds": null,
  "max_staleness_prefix": null
}
```

### <a name="input_cosmosdb_account_cors_rules"></a> [cosmosdb\_account\_cors\_rules](#input\_cosmosdb\_account\_cors\_rules)

Description: Specifies cosmos db account cors rules.

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

### <a name="input_cosmosdb_account_default_identity_type"></a> [cosmosdb\_account\_default\_identity\_type](#input\_cosmosdb\_account\_default\_identity\_type)

Description: Specifies the default identity type for key vault access for customer-managed key.

Type: `string`

Default: `""`

### <a name="input_cosmosdb_account_kind"></a> [cosmosdb\_account\_kind](#input\_cosmosdb\_account\_kind)

Description: Specifies the kind of the cosmos db account.

Type: `string`

Default: `"GlobalDocumentDB"`

### <a name="input_cosmosdb_account_local_authentication_disabled"></a> [cosmosdb\_account\_local\_authentication\_disabled](#input\_cosmosdb\_account\_local\_authentication\_disabled)

Description: Specifies whether local authentication should be enabled for the cosmos db account.

Type: `bool`

Default: `true`

### <a name="input_cosmosdb_account_mongo_server_version"></a> [cosmosdb\_account\_mongo\_server\_version](#input\_cosmosdb\_account\_mongo\_server\_version)

Description: Specifies the mongo server version of the cosmos db account.

Type: `string`

Default: `null`

### <a name="input_cosmosdb_account_partition_merge_enabled"></a> [cosmosdb\_account\_partition\_merge\_enabled](#input\_cosmosdb\_account\_partition\_merge\_enabled)

Description: Specifies whether partition merge should be enabled for the cosmos db account.

Type: `bool`

Default: `false`

### <a name="input_customer_managed_key"></a> [customer\_managed\_key](#input\_customer\_managed\_key)

Description: Specifies the customer managed key configurations.

Type:

```hcl
object({
    key_vault_id                     = string,
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

### <a name="input_private_dns_zone_id_cosmos_analytical"></a> [private\_dns\_zone\_id\_cosmos\_analytical](#input\_private\_dns\_zone\_id\_cosmos\_analytical)

Description: Specifies the resource ID of the private DNS zone for cosmos db analytical storage. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_cosmos_cassandra"></a> [private\_dns\_zone\_id\_cosmos\_cassandra](#input\_private\_dns\_zone\_id\_cosmos\_cassandra)

Description: Specifies the resource ID of the private DNS zone for cosmos db cassandry. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_cosmos_coordinator"></a> [private\_dns\_zone\_id\_cosmos\_coordinator](#input\_private\_dns\_zone\_id\_cosmos\_coordinator)

Description: Specifies the resource ID of the private DNS zone for cosmos db coordinator. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_cosmos_gremlin"></a> [private\_dns\_zone\_id\_cosmos\_gremlin](#input\_private\_dns\_zone\_id\_cosmos\_gremlin)

Description: Specifies the resource ID of the private DNS zone for cosmos db gramlin. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_cosmos_mongodb"></a> [private\_dns\_zone\_id\_cosmos\_mongodb](#input\_private\_dns\_zone\_id\_cosmos\_mongodb)

Description: Specifies the resource ID of the private DNS zone for cosmos db mongo db. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_cosmos_sql"></a> [private\_dns\_zone\_id\_cosmos\_sql](#input\_private\_dns\_zone\_id\_cosmos\_sql)

Description: Specifies the resource ID of the private DNS zone for cosmos db sql. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_private_dns_zone_id_cosmos_table"></a> [private\_dns\_zone\_id\_cosmos\_table](#input\_private\_dns\_zone\_id\_cosmos\_table)

Description: Specifies the resource ID of the private DNS zone for cosmos db table. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_private_endpoint_subresource_names"></a> [private\_endpoint\_subresource\_names](#input\_private\_endpoint\_subresource\_names)

Description: Specifies a list of group ids for which private endpoints will be created (e.g. 'Sql', 'MongoDB', etc.). If sub resource is defined a private endpoint will be created.

Type: `set(string)`

Default:

```json
[
  "blob"
]
```

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_cosmosdb_account_completed"></a> [cosmosdb\_account\_completed](#output\_cosmosdb\_account\_completed)

Description: Specifies whether the connectivity and identity has been successfully configured.

### <a name="output_cosmosdb_account_endpoint"></a> [cosmosdb\_account\_endpoint](#output\_cosmosdb\_account\_endpoint)

Description: Specifies the endpoint of the cosmos db account.

### <a name="output_cosmosdb_account_id"></a> [cosmosdb\_account\_id](#output\_cosmosdb\_account\_id)

Description: Specifies the resource id of the cosmos db account.

### <a name="output_cosmosdb_account_name"></a> [cosmosdb\_account\_name](#output\_cosmosdb\_account\_name)

Description: Specifies the resource name of the cosmos db account.

### <a name="output_cosmosdb_account_primary_key"></a> [cosmosdb\_account\_primary\_key](#output\_cosmosdb\_account\_primary\_key)

Description: Specifies the primary key of the cosmos db account.

### <a name="output_cosmosdb_account_read_endpoints"></a> [cosmosdb\_account\_read\_endpoints](#output\_cosmosdb\_account\_read\_endpoints)

Description: Specifies the list of read endpoints of the cosmos db account.

### <a name="output_cosmosdb_account_write_endpoints"></a> [cosmosdb\_account\_write\_endpoints](#output\_cosmosdb\_account\_write\_endpoints)

Description: Specifies the list of write endpoints of the cosmos db account.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->