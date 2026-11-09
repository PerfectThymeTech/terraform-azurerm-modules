# 🤖 Azure AI Services Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-aiservice.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-aiservice.yml)

Deploys a private-only Cognitive Services account of a chosen kind with optional model deployments and a customer-managed key.

## 📦 Overview

- A Cognitive Services account whose kind you choose with `cognitive_account_kind`, plus optional model deployments.
- A private endpoint for the `account` subresource, optional diagnostic settings, and, when `customer_managed_key` is set, the key configuration plus a *Key Vault Crypto Service Encryption User* role assignment on the Key Vault.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Public network access is disabled and the firewall default action is `Deny` with no IP rules.
- Key-based authentication is off (`cognitive_account_local_auth_enabled` defaults to `false`).
- Outbound network access is restricted (`cognitive_account_outbound_network_access_restricted` defaults to `true`).
- The account uses a system-assigned managed identity.
- The private endpoint is always created.
- Customer-managed key (`customer_managed_key`) and diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- `cognitive_account_local_auth_enabled = true` enables key-based access.
- `cognitive_account_firewall_bypass_azure_services` (default `false`) sets the firewall bypass to `AzureServices`. Not every AI service kind supports it.
- `cognitive_account_outbound_network_access_restricted = false` removes the outbound restriction, and `cognitive_account_outbound_network_access_allowed_fqdns` (default `[]`) adds allowed outbound FQDNs.

**Prerequisites**

- `subnet_id`: the resource ID of the subnet for the private endpoint.
- `cognitive_account_kind` must be one of the values allowed by the variable validation (for example `OpenAI`, `SpeechServices` or `FormRecognizer`).
- Optional `private_dns_zone_id_cognitive_account` must end with `privatelink.cognitiveservices.azure.com` or `privatelink.openai.azure.com`. It is not required when DNS A-records are created through Azure Policy.
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
