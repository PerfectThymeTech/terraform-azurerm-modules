locals {
  # Encryption configuration
  encryption = var.customer_managed_key == null ? null : {
    keyVaultProperties = {
      keyIdentifier    = var.customer_managed_key.key_vault_key_versionless_id
      keyVaultArmId    = var.customer_managed_key.key_vault_id
      identityClientId = var.customer_managed_key.user_assigned_identity_client_id
    }
    status = "Enabled"
    identity = {
      userAssignedIdentity = var.customer_managed_key.user_assigned_identity_id
    }
  }

  # # Will be managed using a separate module due to service limitations: https://github.com/PerfectThymeTech/terraform-azurerm-modules/tree/main/modules/aistudiooutboundrules
  # # Outbound rules - private endpoints
  # default_ai_studio_hub_outbound_rules_private_endpoints = [
  #   {
  #     private_connection_resource_id = var.storage_account_id
  #     subresource_name               = "table"
  #   },
  #   {
  #     private_connection_resource_id = var.storage_account_id
  #     subresource_name               = "queue"
  #   }
  # ]
  # ai_studio_hub_outbound_rules_private_endpoints = {
  #   for item in toset(setunion(var.ai_studio_hub_outbound_rules_private_endpoints, local.default_ai_studio_hub_outbound_rules_private_endpoints)) :
  #   "${reverse(split("/", item.private_connection_resource_id))[0]}-${item.subresource_name}" => {
  #     type     = "PrivateEndpoint"
  #     category = "UserDefined"
  #     status   = "Active"
  #     destination = {
  #       serviceResourceId = item.private_connection_resource_id
  #       subresourceTarget = item.subresource_name
  #       sparkEnabled      = true
  #       sparkStatus       = "Active"
  #     }
  #   }
  # }

  # # Outbound rules - service endpoints
  # default_ai_studio_hub_outbound_rules_service_endpoints = [
  #   {
  #     service_tag = "AzureOpenDatasets"
  #     protocol    = "TCP"
  #     port_range  = "443"
  #   }
  # ]
  # ai_studio_hub_outbound_rules_service_endpoints = {
  #   for item in toset(setunion(var.ai_studio_hub_outbound_rules_service_endpoints, local.default_ai_studio_hub_outbound_rules_service_endpoints)) :
  #   "${item.service_tag}-${item.protocol}-${item.port_range}" => {
  #     type     = "ServiceTag"
  #     category = "UserDefined"
  #     destination = {
  #       serviceTag = item.service_tag,
  #       protocol   = item.protocol,
  #       portRanges = item.port_range,
  #       action     = "Allow"
  #     },
  #     status = "Active"
  #   }
  # }

  # # Outbound rules - fqdns
  # default_ai_studio_hub_outbound_rules_fqdns = [
  #   # General dependencies
  #   "graph.microsoft.com",
  #   "*.aznbcontent.net",
  #   "aka.ms",
  #   "automlresources-prod.azureedge.net",

  #   # Required pypi dependencies
  #   "pypi.org",
  #   "pythonhosted.org",
  #   "*.pythonhosted.org",
  #   "pypi.python.org",
  #   "anaconda.com",
  #   "*.anaconda.com",
  #   "*.anaconda.org",
  #   "pytorch.org",
  #   "*.pytorch.org",
  #   "*.tensorflow.org",

  #   # Required R dependencies
  #   "cloud.r-project.org",

  #   # VSCode dependencies (Docs: https://code.visualstudio.com/docs/setup/network#_common-hostnames)
  #   "*.vscode.dev",
  #   "vscode.dev",
  #   "vscode.blob.core.windows.net",
  #   "*.gallerycdn.vsassets.io",
  #   "raw.githubusercontent.com",
  #   "*.vscode-unpkg.net",
  #   "*.vscode-cdn.net",
  #   "*.vscodeexperiments.azureedge.net",
  #   "default.exp-tas.com",
  #   "code.visualstudio.com",
  #   "update.code.visualstudio.com",
  #   "*.vo.msecnd.net",
  #   "marketplace.visualstudio.com",
  #   "vscode.download.prss.microsoft.com",
  #   "*.gallery.vsassets.io",
  #   "vscode.search.windows.net",
  #   "vsmarketplacebadges.dev",
  #   "download.visualstudio.microsoft.com",
  #   "vscode-sync.trafficmanager.net",

  #   # Azure ML dependencies
  #   "azclientextensionsync.blob.core.windows.net",
  #   "azureexamples.blob.core.windows.net",
  #   "azuremlexamples.blob.core.windows.net",
  #   "openaipublic.blob.core.windows.net",
  #   "notebiwesteurope.blob.core.windows.net",
  #   "i40vsblobprodsu6weus59.blob.core.windows.net",

  #   # Huggingface dependencies
  #   "docker.io",
  #   "*.docker.io",
  #   "*.docker.com",
  #   "production.cloudflare.docker.com",
  #   "cdn.auth0.com",
  #   "cdn-lfs.huggingface.co",

  #   # Ubuntu dependencies
  #   "*.maven.org",
  #   "snapcraft.io",
  #   "*.snapcraft.io",
  #   "snapcraftcontent.com",
  #   "*.snapcraftcontent.com",
  #   "ubuntu.com",
  #   "*.ubuntu.com"
  # ]
  # ai_studio_hub_outbound_rules_fqdns = {
  #   for item in toset(setunion(var.ai_studio_hub_outbound_rules_fqdns, local.default_ai_studio_hub_outbound_rules_fqdns)) :
  #   replace(replace(item, "*", "all"), "/[^[:alnum:]]/", "-") => {
  #     type        = "FQDN"
  #     category    = "UserDefined"
  #     destination = item
  #     status      = "Active"
  #   }
  # }

  # ai_studio_hub_outbound_rules = merge(local.ai_studio_hub_outbound_rules_private_endpoints, local.ai_studio_hub_outbound_rules_service_endpoints, local.ai_studio_hub_outbound_rules_fqdns)
}
