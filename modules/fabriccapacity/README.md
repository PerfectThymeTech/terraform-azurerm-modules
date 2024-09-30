<!-- BEGIN_TF_DOCS -->
# Microsoft Fabric Capacity Terraform Module

## Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>=0.12)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (>= 1.14.0)

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

### <a name="input_fabric_capacity_admin_email"></a> [fabric\_capacity\_admin\_email](#input\_fabric\_capacity\_admin\_email)

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

No outputs.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->