<!-- BEGIN_TF_DOCS -->
# Azure Key Vault Terraform Module

## Documentation
<!-- markdownlint-disable MD033 -->

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>=0.12)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.50.0)

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

### <a name="input_user_assigned_identity_name"></a> [user\_assigned\_identity\_name](#input\_user\_assigned\_identity\_name)

Description: Specifies the name of the User Assigned Identity. Changing this forces a new resource to be created.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

### <a name="input_user_assigned_identity_federated_identity_credentials"></a> [user\_assigned\_identity\_federated\_identity\_credentials](#input\_user\_assigned\_identity\_federated\_identity\_credentials)

Description: Specifies the federated identity credentials to be added to the user assigned identity.

Type:

```hcl
map(object({
    audience = string,
    issuer   = string,
    subject  = string
  }))
```

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_user_assigned_identity_client_id"></a> [user\_assigned\_identity\_client\_id](#output\_user\_assigned\_identity\_client\_id)

Description: Specifies the client id of the user assigned identity.

### <a name="output_user_assigned_identity_id"></a> [user\_assigned\_identity\_id](#output\_user\_assigned\_identity\_id)

Description: Specifies the resource id of the user assigned identity.

### <a name="output_user_assigned_identity_name"></a> [user\_assigned\_identity\_name](#output\_user\_assigned\_identity\_name)

Description: Specifies the name of the user assigned identity.

### <a name="output_user_assigned_identity_principal_id"></a> [user\_assigned\_identity\_principal\_id](#output\_user\_assigned\_identity\_principal\_id)

Description: Specifies the client id of the user assigned identity.

### <a name="output_user_assigned_identity_tenant_id"></a> [user\_assigned\_identity\_tenant\_id](#output\_user\_assigned\_identity\_tenant\_id)

Description: Specifies the client id of the user assigned identity.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->