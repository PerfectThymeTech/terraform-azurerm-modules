# 🤖 Azure AI Studio Project Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-aistudioproject.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-aistudioproject.yml)

Deploys an Azure AI Project attached to an existing Azure AI Hub, with optional project-level connections.

## 📦 Overview

- An Azure AI Project (`Microsoft.MachineLearningServices/workspaces`, kind `Project`) deployed through the `azapi` provider and linked to the hub in `ai_studio_hub_id`.
- Optional project connections and optional diagnostic settings.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- The project uses a system-assigned managed identity.
- Connections are not shared with other projects (`isSharedToAll = false`).
- Connections authenticate with Microsoft Entra ID (`AAD`) by default.
- Diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- `ai_studio_project_connections[*].auth_type` can be set to credential-based types (for example `AccessKey`, `ApiKey` or `ServicePrincipal`) together with `credentials`. Note that `ai_studio_project_connections` is not marked sensitive. *Reason:* not stated in the module code. *Mitigation:* prefer `AAD`; if credentials are needed, pass them from a secret store and never commit them.
- The module defines no private endpoint, network or customer-managed key settings.

**Prerequisites**

- An existing Azure AI Hub: `ai_studio_hub_id`.
- Connection targets (`ai_studio_project_connections[*].target`) must start with `https://`.

## 🚀 Usage

```hcl
module "ai_studio_project" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/aistudioproject?ref=<release-tag>"

  location               = "<azure-region>"
  resource_group_name    = "<resource-group-name>"
  ai_studio_project_name = "<project-name>"
  ai_studio_hub_id       = "<ai-hub-resource-id>"
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).
