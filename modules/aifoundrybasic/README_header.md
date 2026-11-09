# 🤖 Azure AI Foundry (Basic) Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-aifoundrybasic.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-aifoundrybasic.yml)

Deploys a private-only Azure AI Foundry (AI Services) account with optional projects, model deployments and a customer-managed key.

## 📦 Overview

- An AI Services account (`kind = "AIServices"`) with optional Foundry projects and model deployments.
- A private endpoint for the `account` subresource, optional diagnostic settings, and, when `customer_managed_key` is set, the key configuration plus a *Key Vault Crypto Service Encryption User* role assignment on the Key Vault.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Public network access is disabled and the firewall default action is `Deny` with no Internet Protocol (IP) rules.
- Outbound network access is restricted (`ai_services_outbound_network_access_restricted` defaults to `true`).
- The account and its projects use a system-assigned managed identity.
- The private endpoint is always created.
- Customer-managed key (`customer_managed_key`) and diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- `ai_services_firewall_bypass_azure_services` (default `false`) sets the firewall bypass to `AzureServices`. *Reason:* the variable description says this is required for some common integration scenarios and is not supported by all AI services. *Mitigation:* enable it only when a trusted Azure service needs access, and limit that service with Azure role-based access control.
- `ai_services_outbound_network_access_restricted = false` removes the outbound restriction, and `ai_services_outbound_network_access_allowed_fqdns` (default `[]`) adds allowed outbound fully qualified domain names (FQDNs). *Reason:* not stated in the module code. *Mitigation:* keep the restriction on and list only the outbound domain names the workload needs.
- Known issue: the module negates `ai_services_local_auth_enabled` when it sets `local_authentication_enabled`, so the default value `false` creates the account with key-based (local) authentication enabled. The `aiservice` module does not negate it.

**Prerequisites**

- `subnet_id`: the resource ID of the subnet for the private endpoint.
- Optional private Domain Name System (DNS) zone IDs: `private_dns_zone_id_ai_services` (`privatelink.services.ai.azure.com`), `private_dns_zone_id_cognitive_account` (`privatelink.cognitiveservices.azure.com`) and `private_dns_zone_id_open_ai` (`privatelink.openai.azure.com`). They are not required when DNS A-records are created through Azure Policy.
- `customer_managed_key` needs a Key Vault, key and user-assigned identity (five validated fields).
- `ai_services_deployments` is only applicable to OpenAI models.

## 🚀 Usage

```hcl
module "ai_foundry" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/aifoundrybasic?ref=<release-tag>"

  location            = "<azure-region>"
  resource_group_name = "<resource-group-name>"
  ai_services_name    = "<ai-services-name>"
  ai_services_sku     = "S0"
  subnet_id           = "<subnet-resource-id>"
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).
