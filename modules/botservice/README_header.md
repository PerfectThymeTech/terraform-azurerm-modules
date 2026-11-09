# 🤖 Azure Bot Service Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-botservice.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-botservice.yml)

Deploys an Azure Bot with local authentication disabled, public network access off by default and private endpoints for the Bot and Token endpoints.

## 📦 Overview

- An Azure Bot resource linked to an existing Application Insights component.
- Two private endpoints: one for the `Bot` subresource and one for the `Token` subresource.
- An optional Application Insights application programming interface (API) key (created by default) and optional diagnostic settings.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Local authentication is disabled (hard-coded).
- Public network access is disabled (`bot_service_public_network_access_enabled` defaults to `false`).
- Both private endpoints are always created.
- The bot endpoint and the icon Uniform Resource Locator (URL) must use Hypertext Transfer Protocol Secure (HTTPS); variable validation enforces this.
- Customer-managed key (`customer_managed_key`) and diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- `bot_service_public_network_access_enabled = true` allows public network access. *Reason:* not stated in the module code. *Mitigation:* keep it `false` (default) and use the private endpoints.
- `bot_service_application_insights_key_enabled` defaults to `true`: the module creates an Application Insights API key with read permissions (`aggregate`, `api`, `draft`, `extendqueries`, `search`) and no write permissions, and passes it to the bot. *Reason:* not stated in the module code. *Mitigation:* set `bot_service_application_insights_key_enabled = false` if the bot does not need the key.
- Known issue: `customer_managed_key` is validated for several fields, but only `key_vault_key_versionless_id` is used and the module creates no identity or role assignment for the key.

**Prerequisites**

- An existing Application Insights component: `bot_service_application_insights_id`.
- `bot_service_microsoft_app` with `app_id`, `app_msi_id`, `app_tenant_id` and `app_type` (`MultiTenant`, `SingleTenant` or `UserAssignedMSI`).
- `bot_service_endpoint` must start with `https://`.
- `subnet_id` for the private endpoints, and optional private Domain Name System (DNS) zone identifiers (IDs) `private_dns_zone_id_bot_framework_directline` (`privatelink.directline.botframework.com`) and `private_dns_zone_id_bot_framework_token` (`privatelink.token.botframework.com`).
- `bot_service_location` is one of `global`, `westeurope`, `westus` or `centralindia` (default `global`); `location` is only used for the private endpoints.

## 🚀 Usage

```hcl
module "bot_service" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/botservice?ref=<release-tag>"

  location                            = "<azure-region>"
  resource_group_name                 = "<resource-group-name>"
  bot_service_name                    = "<bot-name>"
  bot_service_endpoint                = "https://<bot-endpoint-host>/api/messages"
  bot_service_application_insights_id = "<application-insights-resource-id>"
  subnet_id                           = "<subnet-resource-id>"

  bot_service_microsoft_app = {
    app_id        = "<microsoft-app-id>"
    app_msi_id    = "<user-assigned-identity-resource-id>"
    app_tenant_id = "<tenant-id>"
    app_type      = "UserAssignedMSI"
  }
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).
