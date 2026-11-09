<!-- BEGIN_TF_DOCS -->
# 🤖 Azure AI Services Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-aiservice.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-aiservice.yml)

Deploys a private-only Cognitive Services account of a chosen kind with optional model deployments and a customer-managed key.

## 📦 Overview

- A Cognitive Services account whose kind you choose with `cognitive_account_kind`, plus optional model deployments.
- A private endpoint for the `account` subresource, optional diagnostic settings, and, when `customer_managed_key` is set, the key configuration plus a *Key Vault Crypto Service Encryption User* role assignment on the Key Vault.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Public network access is disabled and the firewall default action is `Deny` with no Internet Protocol (IP) rules.
- Key-based authentication is off (`cognitive_account_local_auth_enabled` defaults to `false`).
- Outbound network access is restricted (`cognitive_account_outbound_network_access_restricted` defaults to `true`).
- The account uses a system-assigned managed identity.
- The private endpoint is always created.
- Customer-managed key (`customer_managed_key`) and diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- `cognitive_account_local_auth_enabled = true` enables key-based access. *Reason:* not stated in the module code. *Mitigation:* keep it `false` and use Microsoft Entra ID with Azure role-based access control; if keys are unavoidable, store and rotate them in a key vault.
- `cognitive_account_firewall_bypass_azure_services` (default `false`) sets the firewall bypass to `AzureServices`. Not every AI service kind supports it. *Reason:* the variable description says this is required for some common integration scenarios. *Mitigation:* enable it only when a trusted Azure service needs access, and limit that service with Azure role-based access control.
- `cognitive_account_outbound_network_access_restricted = false` removes the outbound restriction, and `cognitive_account_outbound_network_access_allowed_fqdns` (default `[]`) adds allowed outbound fully qualified domain names (FQDNs). *Reason:* not stated in the module code. *Mitigation:* keep the restriction on and list only the outbound domain names the workload needs.

**Prerequisites**

- `subnet_id`: the resource identifier (ID) of the subnet for the private endpoint.
- `cognitive_account_kind` must be one of the values allowed by the variable validation (for example `OpenAI`, `SpeechServices` or `FormRecognizer`).
- Optional `private_dns_zone_id_cognitive_account` must end with `privatelink.cognitiveservices.azure.com` or `privatelink.openai.azure.com`. It is not required when Domain Name System (DNS) A-records are created through Azure Policy.
- `customer_managed_key` needs a Key Vault, key and user-assigned identity (five validated fields).
- `cognitive_account_deployments` is only applicable to accounts of kind OpenAI.

## 🚀 Usage

```hcl
module "ai_service" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/aiservice?ref=<release-tag>"

  location               = "<azure-region>"
  resource_group_name    = "<resource-group-name>"
  cognitive_account_name = "<cognitive-account-name>"
  cognitive_account_kind = "OpenAI"
  cognitive_account_sku  = "S0"
  subnet_id              = "<subnet-resource-id>"
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

- <a name="requirement_time"></a> [time](#requirement\_time) (~> 0.9)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 5.0)

- <a name="provider_time"></a> [time](#provider\_time) (~> 0.9)

## Resources

The following resources are used by this module:

- [azurerm_cognitive_account.cognitive_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_account) (resource)
- [azurerm_cognitive_account_customer_managed_key.cognitive_account_customer_managed_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_account_customer_managed_key) (resource)
- [azurerm_cognitive_deployment.cognitive_deployments](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_deployment) (resource)
- [azurerm_monitor_diagnostic_setting.diagnostic_setting_cognitive_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_private_endpoint.private_endpoint_cognitive_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_role_assignment.role_assignment_key_vault_crypto_encryption_user_cognitive_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [time_sleep.sleep_connectivity](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_monitor_diagnostic_categories.diagnostic_categories_cognitive_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) (data source)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD034 -->
## Required Inputs

The following input variables are required:

### <a name="input_cognitive_account_kind"></a> [cognitive\_account\_kind](#input\_cognitive\_account\_kind)

Description: Specifies the kind of the cognitive service.

Type: `string`

### <a name="input_cognitive_account_name"></a> [cognitive\_account\_name](#input\_cognitive\_account\_name)

Description: Specifies the name of the cognitive service.

Type: `string`

### <a name="input_cognitive_account_sku"></a> [cognitive\_account\_sku](#input\_cognitive\_account\_sku)

Description: Specifies the sku of the cognitive service.

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

### <a name="input_cognitive_account_deployments"></a> [cognitive\_account\_deployments](#input\_cognitive\_account\_deployments)

Description: Specifies the models that should be deployed within your ai service. Only applicable to ai services of kind openai.

Type:

```hcl
map(object({
    model_name        = string
    model_version     = string
    model_api_version = optional(string, "2024-02-15-preview")
    sku_name          = optional(string, "Standard")
    sku_tier          = optional(string, "Standard")
    sku_size          = optional(string, null)
    sku_family        = optional(string, null)
    sku_capacity      = optional(number, 1)
  }))
```

Default: `{}`

### <a name="input_cognitive_account_firewall_bypass_azure_services"></a> [cognitive\_account\_firewall\_bypass\_azure\_services](#input\_cognitive\_account\_firewall\_bypass\_azure\_services)

Description: Specifies whether Azure Services should be allowed to bypass the firewall of the cognitive service. This is required for some common integration sceanrios but not supported by all ai services.

Type: `bool`

Default: `false`

### <a name="input_cognitive_account_local_auth_enabled"></a> [cognitive\_account\_local\_auth\_enabled](#input\_cognitive\_account\_local\_auth\_enabled)

Description: Specifies whether key-based acces should be enabled for the cognitive service.

Type: `bool`

Default: `false`

### <a name="input_cognitive_account_outbound_network_access_allowed_fqdns"></a> [cognitive\_account\_outbound\_network\_access\_allowed\_fqdns](#input\_cognitive\_account\_outbound\_network\_access\_allowed\_fqdns)

Description: Specifies the outbound network allowed fqdns of the cognitive service.

Type: `list(string)`

Default: `[]`

### <a name="input_cognitive_account_outbound_network_access_restricted"></a> [cognitive\_account\_outbound\_network\_access\_restricted](#input\_cognitive\_account\_outbound\_network\_access\_restricted)

Description: Specifies the outbound network restrictions of the cognitive service.

Type: `bool`

Default: `true`

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

### <a name="input_location_private_endpoint"></a> [location\_private\_endpoint](#input\_location\_private\_endpoint)

Description: Specifies the location of the private endpoint. Use this variables only if the private endpoint(s) should reside in a different location than the service itself.

Type: `string`

Default: `null`

### <a name="input_private_dns_zone_id_cognitive_account"></a> [private\_dns\_zone\_id\_cognitive\_account](#input\_private\_dns\_zone\_id\_cognitive\_account)

Description: Specifies the resource ID of the private DNS zone for Azure Cognitive Services. Not required if DNS A-records get created via Azure Policy.

Type: `string`

Default: `""`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Specifies a key value map of tags to set on every taggable resources.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_cognitive_account_endpoint"></a> [cognitive\_account\_endpoint](#output\_cognitive\_account\_endpoint)

Description: The base URL of the cognitive service account.

### <a name="output_cognitive_account_id"></a> [cognitive\_account\_id](#output\_cognitive\_account\_id)

Description: The ID of the cognitive service account.

### <a name="output_cognitive_account_name"></a> [cognitive\_account\_name](#output\_cognitive\_account\_name)

Description: The name of the cognitive service account.

### <a name="output_cognitive_account_primary_access_key"></a> [cognitive\_account\_primary\_access\_key](#output\_cognitive\_account\_primary\_access\_key)

Description: The primary access key of the cognitive service account.

### <a name="output_cognitive_account_principal_id"></a> [cognitive\_account\_principal\_id](#output\_cognitive\_account\_principal\_id)

Description: The principal id of the cognitive service account.

### <a name="output_cognitive_account_setup_completed"></a> [cognitive\_account\_setup\_completed](#output\_cognitive\_account\_setup\_completed)

Description: Specifies whether the connectivity and identity has been successfully configured.

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->