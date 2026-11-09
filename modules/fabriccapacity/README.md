<!-- BEGIN_TF_DOCS -->
# 📊 Microsoft Fabric Capacity Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-fabriccapacity.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-fabriccapacity.yml)

Deploys a Microsoft Fabric capacity in Azure with the deploying identity and optional extra members as administrators.

## 📦 Overview

- One Microsoft Fabric capacity (`Microsoft.Fabric/capacities`) deployed through the `azapi` provider.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- None. The module only sets the SKU and the capacity administrators; it defines no network, identity or encryption settings.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- The object ID of the identity that runs Terraform is always added as a capacity administrator. `fabric_capacity_admin_emails` (default `[]`) adds further administrators.

**Prerequisites**

- An existing resource group.
- `fabric_capacity_name` must be alphanumeric and at least two characters long.
- `fabric_capacity_sku` must be one of `F2` to `F2048` (default `F2`).

## 🚀 Usage

```hcl
module "fabric_capacity" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/fabriccapacity?ref=<release-tag>"

  location             = "<azure-region>"
  resource_group_name  = "<resource-group-name>"
  fabric_capacity_name = "<fabriccapacityname>"
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

## Providers

The following providers are used by this module:

- <a name="provider_azapi"></a> [azapi](#provider\_azapi) (~> 2.0)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 5.0)

## Resources

The following resources are used by this module:

- [azapi_resource.fabric_capacity](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_fabric_capacity_name"></a> [fabric\_capacity\_name](#input\_fabric\_capacity\_name)

Description: Specifies the name of the fabric capacity.

Type: `string`

### <a name="input_location"></a> [location](#input\_location)

Description: Specifies the location of all resources.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: Specifies the resource group name in which all resources will get deployed.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_fabric_capacity_admin_emails"></a> [fabric\_capacity\_admin\_emails](#input\_fabric\_capacity\_admin\_emails)

Description: Specifies the list of admin email addresses of the fabric capacity.

Type: `list(string)`

Default: `[]`

### <a name="input_fabric_capacity_sku"></a> [fabric\_capacity\_sku](#input\_fabric\_capacity\_sku)

Description: Specifies the sku name of the fabric capacity.

Type: `string`

Default: `"F2"`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_fabric_capacity_id"></a> [fabric\_capacity\_id](#output\_fabric\_capacity\_id)

Description: Specifies the id of the fabric capacity.

### <a name="output_fabric_capacity_name"></a> [fabric\_capacity\_name](#output\_fabric\_capacity\_name)

Description: Specifies the name of the fabric capacity.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->