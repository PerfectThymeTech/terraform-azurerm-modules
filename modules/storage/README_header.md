# 📊 Azure Storage Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-storage.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-storage.yml)

Deploys a locked-down Azure Storage account with Microsoft Entra ID-first access, private endpoints and optional containers, static website and customer-managed key.

## 📦 Overview

- An Azure Storage account (`azurerm_storage_account`) with optional containers, static website and customer-managed key.
- One private endpoint per entry in `private_endpoint_subresource_names` (default `["blob"]`).
- A *Storage Blob Data Owner* role assignment for the identity that runs Terraform, used to create data plane artifacts.
- Optional diagnostic settings for the account and its `blob`, `file`, `table` and `queue` services.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Blob public access is disabled and containers are private.
- The network rules deny by default with no Internet Protocol (IP) or virtual network rules, and `bypass` defaults to `["None"]`.
- Shared key access is disabled (`storage_shared_access_key_enabled` defaults to `false`) and OAuth is the default authentication.
- Hypertext Transfer Protocol Secure (HTTPS) only and a minimum Transport Layer Security (TLS) version of 1.2; infrastructure encryption is enabled.
- Cross-tenant replication is disabled and the allowed copy scope defaults to `AAD`.
- Blob and container soft delete are enabled for 7 days by default.
- SSH File Transfer Protocol (SFTP) and Network File System version 3 (NFSv3) are disabled by default.
- The private endpoint for `blob` uses automatic approval.
- Customer-managed key (`customer_managed_key`) and diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- `storage_public_network_access_enabled` defaults to `true`. The network rules still deny by default, so the account is not open to the internet unless you add rules. *Reason:* not stated in the module code. *Mitigation:* set it to `false` when private endpoints cover all access, and add network rules only for known sources.
- `storage_shared_access_key_enabled = true` enables shared key access, and `storage_account_allowed_copy_scope = "All"` removes the copy scope restriction. *Reason:* not stated in the module code. *Mitigation:* keep shared key access off and use Microsoft Entra ID; keep the copy scope at `AAD`.
- `storage_network_bypass` (default `["None"]`), `storage_network_private_link_access` (default `[]`), `storage_blob_cors_rules` (default `{}`), `storage_sftp_enabled` and `storage_nfsv3_enabled` relax the corresponding settings. *Reason:* not stated in the module code. *Mitigation:* keep the defaults unless a workload needs the feature, and scope each rule narrowly.
- The shared access signature (SAS) policy is hard-coded to a one-day expiration period with the action `Log`. *Reason:* not stated in the module code. *Mitigation:* prefer Microsoft Entra ID authentication and monitor the logs for SAS use that exceeds the policy.
- Known issue: the diagnostic setting for the `file` service reads the diagnostic categories of the `blob` service.

**Prerequisites**

- `subnet_id`: the resource identifier (ID) of the subnet for the private endpoints.
- Optional private Domain Name System (DNS) zone IDs `private_dns_zone_id_blob`, `_file`, `_table`, `_queue`, `_web` and `_dfs`, each validated against its `privatelink.<service>.core.windows.net` suffix. They are not required when DNS A-records are created through Azure Policy.
- `customer_managed_key` needs `key_vault_key_versionless_id` and `user_assigned_identity_id`. The module creates no role assignment for that identity.

## 🚀 Usage

```hcl
module "storage" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/storage?ref=<release-tag>"

  location             = "<azure-region>"
  resource_group_name  = "<resource-group-name>"
  storage_account_name = "<storageaccountname>"
  subnet_id            = "<subnet-resource-id>"
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).
