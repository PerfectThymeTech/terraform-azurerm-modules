# 🔌 Azure Event Hub Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-eventhubnamespace.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-eventhubnamespace.yml)

Deploys an Azure Event Hubs namespace with public access disabled, a private endpoint, event hubs and namespace authorization rules.

## 📦 Overview

- An Event Hubs namespace (`azurerm_eventhub_namespace`) with a system-assigned managed identity.
- The event hubs you list in `event_hubs` and the namespace authorization rules you list in `eventhub_namespace_authorization_rules`.
- A private endpoint for the `namespace` subresource and optional diagnostic settings.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Public network access is disabled (hard-coded), and the Internet Protocol (IP) and virtual network rule lists are empty.
- Local (key-based) authentication is off (`event_hub_namespace_local_authentication_enabled` defaults to `false`).
- The minimum Transport Layer Security (TLS) version is 1.2.
- The namespace uses a system-assigned managed identity.
- The private endpoint uses automatic approval.
- Authorization rules default to listen only (`listen = true`, `manage = false`, `send = false`).
- The default key and connection string outputs are marked sensitive.
- Diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- `event_hub_namespace_local_authentication_enabled = true` enables local authentication, and each authorization rule can set `manage` or `send` to `true`. *Reason:* not stated in the module code. *Mitigation:* keep local authentication off and grant only the rights each client needs.
- The network rule set has `default_action = "Allow"` (hard-coded). A code comment states that azurerm 5.3 and later reject `Deny` without rules and that the setting is inert while public access is disabled. *Reason:* as stated in that code comment. *Mitigation:* keep public network access disabled, which the module hard-codes.
- `trusted_service_access_enabled = true` is hard-coded. *Reason:* not stated in the module code. *Mitigation:* limit what trusted Azure services can do with Azure role-based access control.
- Known issue: `customer_managed_key` is declared and validated but no resource uses it, so no customer-managed key is applied.
- Known issue: `event_hub_namespace_dedicated_cluster_id` is declared as `bool` although its description and validation treat it as a resource ID.
- Known issue: the private endpoint, NIC and service connection names contain `datafactory`.

**Prerequisites**

- `subnet_id`: the resource ID of the subnet for the private endpoint.
- Optional `private_dns_zone_id_servicebus` ending in `privatelink.servicebus.windows.net`. It is not required when Domain Name System (DNS) A-records are created through Azure Policy.

## 🚀 Usage

```hcl
module "eventhub_namespace" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/eventhubnamespace?ref=<release-tag>"

  location                                    = "<azure-region>"
  resource_group_name                         = "<resource-group-name>"
  event_hub_namespace_name                    = "<event-hub-namespace-name>"
  event_hub_namespace_sku                     = "Standard"
  event_hub_namespace_maximum_throughput_units = 1
  subnet_id                                   = "<subnet-resource-id>"

  event_hubs = {
    "<event-hub-name>" = {}
  }

  eventhub_namespace_authorization_rules = {
    "<authorization-rule-name>" = {}
  }
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).
