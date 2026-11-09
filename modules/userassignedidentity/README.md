<!-- BEGIN_TF_DOCS -->
# 🔐 Azure User Assigned Identity Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-userassignedidentity.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-userassignedidentity.yml)

Deploys an Azure user-assigned managed identity with optional federated identity credentials.

## 📦 Overview

- One user-assigned managed identity (`azurerm_user_assigned_identity`).
- Optional federated identity credentials, one per entry in `user_assigned_identity_federated_identity_credentials`.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- None. The module only sets the name, location, resource group and tags.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- No security exceptions.

**Prerequisites**

- Each federated identity credential needs an `audience`, an `issuer` and a `subject`. They have no defaults and no validation.

## 🚀 Usage

```hcl
module "user_assigned_identity" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/userassignedidentity?ref=<release-tag>"

  location                    = "<azure-region>"
  resource_group_name         = "<resource-group-name>"
  user_assigned_identity_name = "<identity-name>"
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

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 5.0)

## Resources

The following resources are used by this module:

- [azurerm_federated_identity_credential.federated_identity_credential](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) (resource)
- [azurerm_user_assigned_identity.user_assigned_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) (resource)

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