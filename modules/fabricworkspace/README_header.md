# 📊 Microsoft Fabric Workspace Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-fabricworkspace.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-fabricworkspace.yml)

Creates a Microsoft Fabric workspace on an existing capacity with optional Git integration, Spark settings, role assignments, network policy, private link and managed private endpoints.

## 📦 Overview

- A Fabric workspace (`fabric_workspace`) on the capacity named in `workspace_capacity_name`, with optional Spark settings and Git integration.
- A workspace network communication policy and, when `workspace_outbound_gateway_rules` applies, outbound gateway rules.
- Optional inbound private link (a private link service for Fabric and a private endpoint), role assignments and managed private endpoints.
- Optional PowerShell steps for domain assignment, tags, OneLake diagnostics and managed private endpoint approval.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- The workspace identity is on by default (`workspace_identity_enabled` defaults to `true`).
- When private link is enabled (`workspace_private_endpoint_enabled`), the private endpoint uses automatic approval.
- The scripts obtain the Fabric API token from the Azure CLI session at run time; no secret is stored in the module.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- The network communication policy defaults to `Allow` for both inbound and outbound public access, and the outbound gateway rules default to `Allow`.
- Private link is off by default (`workspace_private_endpoint_enabled = false`).
- With `workspace_managed_private_endpoints[*].approve = true`, connections are approved by a script (the attribute has no default).
- The Git integration is hard-coded to `PreferWorkspace` with `allow_override_items = true`.
- Several steps run PowerShell and the Azure CLI on the machine that runs Terraform (domain, tags, OneLake diagnostics and approval).

**Prerequisites**

- An existing Fabric capacity looked up by `workspace_capacity_name`. In practice the input is required: its validation and the capacity lookup do not tolerate `null`, although it has a `null` default.
- `subnet_id` has no default and is required even when private link is disabled.
- `workspace_git` is not supported when deploying with a service principal.
- `pwsh` and the Azure CLI (`az`), signed in, on the machine that runs Terraform. The signed-in identity must be allowed to call the Fabric REST API and, for approvals, to approve private endpoint connections on the target resource.
- Terraform `~> 1.8` and the `microsoft/fabric` provider (`~> 1.0`).

> [!NOTE]
> Be aware that support for service principal authentication is limited today. For most of the API endpoints, service principal authentication will be added over time.

## 🚀 Usage

```hcl
module "fabric_workspace" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/fabricworkspace?ref=<release-tag>"

  location                = "<azure-region>"
  resource_group_name     = "<resource-group-name>"
  workspace_display_name  = "<workspace-display-name>"
  workspace_capacity_name = "<fabric-capacity-name>"
  subnet_id               = "<subnet-resource-id>"
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).
