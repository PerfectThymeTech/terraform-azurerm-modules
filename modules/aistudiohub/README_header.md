# 🤖 Azure AI Studio Hub Terraform Module

[![Test workflow](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-aistudiohub.yml/badge.svg?branch=main)](https://github.com/PerfectThymeTech/terraform-azurerm-modules/actions/workflows/terraform-aistudiohub.yml)

Deploys a network-isolated Azure AI Hub workspace with a private endpoint, optional shared connections and optional managed network provisioning.

## 📦 Overview

- An Azure AI Hub (`Microsoft.MachineLearningServices/workspaces`, kind `Hub`) deployed through the `azapi` provider.
- A private endpoint for the `amlworkspace` subresource and optional diagnostic settings.
- Optional hub connections and an optional `provisionManagedNetwork` action.
- User-defined outbound rules are managed by the separate [Azure AI Studio Outbound Rules](../aistudiooutboundrules/) module.
- The full list of deployed resources is in [Resources](#resources).

## 🛡️ Secure defaults

- Public network access is disabled, access when behind a virtual network is not allowed and the Internet Protocol (IP) allow list is empty.
- The managed network only allows approved outbound traffic (`AllowOnlyApprovedOutbound`) and starts with no outbound rules.
- System datastores authenticate with the workspace identity.
- Data isolation and the high business impact flag are enabled.
- The hub uses a system-assigned managed identity.
- The private endpoint is always created.
- Connections authenticate with Microsoft Entra ID (`AAD`) by default.
- Diagnostics (`diagnostics_configurations`) are opt-in.

## ⚠️ Exceptions and prerequisites

**Exceptions**

- `ai_studio_hub_connections[*].auth_type` can be set to credential-based types (for example `AccessKey`, `ApiKey` or `ServicePrincipal`) together with `credentials`. Note that `ai_studio_hub_connections` is not marked sensitive. *Reason:* not stated in the module code. *Mitigation:* prefer `AAD`; if credentials are needed, pass them from a secret store and never commit them.
- Every connection is shared with all projects of the hub (`isSharedToAll = true`, hard-coded). *Reason:* the variable description says to provide only connections that are shared with all projects at hub level. *Mitigation:* create project-specific connections with the `aistudioproject` module.
- The module has a `customer_managed_key` input, although the note below states that customer-managed key (CMK) deployments are not supported for hub workspaces today.

**Prerequisites**

- Existing resources: `application_insights_id`, `container_registry_id`, `key_vault_id` and `storage_account_id`, plus `subnet_id` for the private endpoint.
- Optional private Domain Name System (DNS) zone identifiers (IDs) `private_dns_zone_id_machine_learning_api` (`privatelink.api.azureml.ms`) and `private_dns_zone_id_machine_learning_notebooks` (`privatelink.notebooks.azure.net`). The DNS zone group is only created when both are set.

> [!WARNING]
> **Info for CMK Deployments**
>
> CMK deployments are currently not supported because the service-side encryption of metadata is not supported for hub workspaces today. Once this is supported, we can update the module and enable CMK deployments. More details: https://learn.microsoft.com/en-us/azure/machine-learning/concept-customer-managed-keys?view=azureml-api-2#preview-service-side-encryption-of-metadata
>
> The standard deployment is currently blocked because of a managed Cosmos DB that gets created inside the customer environment. The workspace requires the asignment of a contributor role on that managed resource group in which the cosmos DB will reside. This assignment is currently being blocked by Azure Policies.

> [!NOTE]
> **Info for user-defined outbound rule management**
>
> We have decided to manage the outbund rules using a separate Terraform module. Reasons for this decision and the module can be found here: [Azure AI Studio Outbound Rules](/modules/aistudiooutboundrules/)

## 🚀 Usage

```hcl
module "ai_studio_hub" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/aistudiohub?ref=<release-tag>"

  location                = "<azure-region>"
  resource_group_name     = "<resource-group-name>"
  ai_studio_hub_name      = "<hub-name>"
  application_insights_id = "<application-insights-resource-id>"
  container_registry_id   = "<container-registry-resource-id>"
  key_vault_id            = "<key-vault-resource-id>"
  storage_account_id      = "<storage-account-resource-id>"
  subnet_id               = "<subnet-resource-id>"
}
```

> [!TIP]
> Replace `<release-tag>` with a tag from the [releases page](https://github.com/PerfectThymeTech/terraform-azurerm-modules/releases).
