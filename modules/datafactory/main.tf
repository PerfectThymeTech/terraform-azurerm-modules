resource "azurerm_data_factory" "data_factory" {
  name                = var.data_factory_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  dynamic "identity" {
    for_each = var.customer_managed_key != null ? [{
      type = "SystemAssigned, UserAssigned"
      identity_ids = [
        var.customer_managed_key.user_assigned_identity_id
      ]
      }] : [{
      type         = "SystemAssigned"
      identity_ids = null
    }]
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  customer_managed_key_id          = var.customer_managed_key == null ? null : var.customer_managed_key.key_vault_key_id
  customer_managed_key_identity_id = var.customer_managed_key == null ? null : var.customer_managed_key.user_assigned_identity_id
  managed_virtual_network_enabled  = true
  purview_id                       = var.data_factory_purview_id
  public_network_enabled           = false

  dynamic "global_parameter" {
    for_each = var.data_factory_global_parameters
    content {
      name  = global_parameter.key
      type  = global_parameter.value.type
      value = global_parameter.value.value
    }
  }
  dynamic "github_configuration" {
    for_each = length(compact(values(var.data_factory_github_repo))) == 5 ? [var.data_factory_github_repo] : []
    content {
      account_name    = github_configuration.value["account_name"]
      branch_name     = github_configuration.value["branch_name"]
      git_url         = github_configuration.value["git_url"]
      repository_name = github_configuration.value["repository_name"]
      root_folder     = github_configuration.value["root_folder"]
    }
  }
  dynamic "vsts_configuration" {
    for_each = length(compact(values(var.data_factory_azure_devops_repo))) == 6 ? [var.data_factory_azure_devops_repo] : []
    content {
      account_name    = vsts_configuration.value["account_name"]
      branch_name     = vsts_configuration.value["branch_name"]
      project_name    = vsts_configuration.value["project_name"]
      repository_name = vsts_configuration.value["repository_name"]
      root_folder     = vsts_configuration.value["root_folder"]
      tenant_id       = vsts_configuration.value["tenant_id"]
    }
  }
}
