<!-- BEGIN_TF_DOCS -->
# 📊 Azure Databricks Access Connector Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-databricksaccessconnector.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-databricksaccessconnector.yml)

Deploys an Azure Databricks access connector with a system-assigned managed identity.

## 📦 Overview

- One Azure Databricks access connector (`azurerm_databricks_access_connector`).
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- The connector uses a system-assigned managed identity.
- The `databricks_access_connector_principal_id` output is marked sensitive.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- No security exceptions.

**Prerequisites**

- An existing resource group.

## 🚀 Usage

```hcl
module "databricks_access_connector" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/databricksaccessconnector?ref=<release-tag>"

  location                         = "<azure-region>"
  resource_group_name              = "<resource-group-name>"
  databricks_access_connector_name = "<access-connector-name>"
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

- [azurerm_databricks_access_connector.databricks_access_connector](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_access_connector) (resource)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_databricks_access_connector_name"></a> [databricks\_access\_connector\_name](#input\_databricks\_access\_connector\_name)

Description: Specifies the name of the Azure Databricks workspace.

Type: `string`

### <a name="input_location"></a> [location](#input\_location)

Description: Specifies the location of all resources.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: Specifies the resource group name in which all resources will get deployed.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_databricks_access_connector_id"></a> [databricks\_access\_connector\_id](#output\_databricks\_access\_connector\_id)

Description: Specifies the resource id of the Azure Databricks access connector.

### <a name="output_databricks_access_connector_name"></a> [databricks\_access\_connector\_name](#output\_databricks\_access\_connector\_name)

Description: Specifies the resource name of the Azure Databricks access connector.

### <a name="output_databricks_access_connector_principal_id"></a> [databricks\_access\_connector\_principal\_id](#output\_databricks\_access\_connector\_principal\_id)

Description: Specifies the principal id of the Azure Databricks access connector.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->