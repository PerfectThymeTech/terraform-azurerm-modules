variables {
  location            = "northeurope"
  resource_group_name = "tfmodule-test-rg"
  tags = {
    test = "dtaabricksworkspace"
  }
  virtual_network_id                       = "/subscriptions/1fdab118-1638-419a-8b12-06c9543714a0/resourceGroups/ptt-dev-networking-rg/providers/Microsoft.Network/virtualNetworks/spoke-ptt-dev-vnet001"
  nsg_id                                   = "/subscriptions/1fdab118-1638-419a-8b12-06c9543714a0/resourceGroups/ptt-dev-networking-rg/providers/Microsoft.Network/networkSecurityGroups/ptt-dev-default-nsg001"
  route_table_id                           = "/subscriptions/1fdab118-1638-419a-8b12-06c9543714a0/resourceGroups/ptt-dev-networking-rg/providers/Microsoft.Network/routeTables/ptt-dev-default-rt001"
  subnet_id                                = "/subscriptions/1fdab118-1638-419a-8b12-06c9543714a0/resourceGroups/ptt-dev-networking-rg/providers/Microsoft.Network/virtualNetworks/spoke-ptt-dev-vnet001/subnets/TerraformTestSubnet"
  databricks_workspace_private_subnet_name = "DatabricksPrivateSubnet"
  databricks_workspace_public_subnet_name  = "DatabricksPublicSubnet"
  connectivity_delay_in_seconds            = 0
}

provider "azurerm" {
  disable_correlation_request_id  = false
  environment                     = "public"
  resource_provider_registrations = "none"
  storage_use_azuread             = true
  use_oidc                        = true

  features {
    application_insights {
      disable_generated_rule = false
    }
    machine_learning {
      purge_soft_deleted_workspace_on_destroy = true
    }
    key_vault {
      purge_soft_delete_on_destroy               = false
      purge_soft_deleted_certificates_on_destroy = false
      purge_soft_deleted_keys_on_destroy         = false
      purge_soft_deleted_secrets_on_destroy      = false
      recover_soft_deleted_key_vaults            = true
      recover_soft_deleted_certificates          = true
      recover_soft_deleted_keys                  = true
      recover_soft_deleted_secrets               = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azapi" {
  default_location               = var.location
  default_tags                   = var.tags
  disable_correlation_request_id = false
  environment                    = "public"
  skip_provider_registration     = false
  # use_oidc                       = true
}

provider "time" {}

run "setup" {
  command = apply

  module {
    source = "./tests/setup"
  }

  providers = {
    azurerm = azurerm
    azapi   = azapi
  }

  variables {
    location                                 = var.location
    environment                              = "int"
    prefix                                   = "tfmdladb"
    virtual_network_id                       = var.virtual_network_id
    nsg_id                                   = var.nsg_id
    route_table_id                           = var.route_table_id
    databricks_private_subnet_address_prefix = "10.3.6.0/26"
    databricks_public_subnet_address_prefix  = "10.3.6.64/26"
  }
}

run "create_databricksworkspace" {
  command = apply

  providers = {
    azurerm = azurerm
    time    = time
  }

  variables {
    location                                                                  = "northeurope"
    location_private_endpoint                                                 = "northeurope"
    resource_group_name                                                       = "tfmodule-test-rg"
    tags                                                                      = var.tags
    databricks_workspace_name                                                 = "tftst-dbptt001"
    databricks_workspace_access_connector_id                                  = run.setup.databricks_access_connector_id
    databricks_workspace_machine_learning_workspace_id                        = null
    databricks_workspace_virtual_network_id                                   = var.virtual_network_id
    databricks_workspace_private_subnet_name                                  = run.setup.databricks_private_subnet_name
    databricks_workspace_private_subnet_network_security_group_association_id = run.setup.databricks_private_subnet_network_security_group_association_id
    databricks_workspace_public_subnet_name                                   = run.setup.databricks_public_subnet_name
    databricks_workspace_public_subnet_network_security_group_association_id  = run.setup.databricks_public_subnet_network_security_group_association_id
    databricks_workspace_storage_account_sku_name                             = "Standard_LRS"
    databricks_workspace_browser_authentication_private_endpoint_enabled      = true
    databricks_workspace_compliance_security_profile_standards                = []
    diagnostics_configurations                                                = []
    subnet_id                                                                 = var.subnet_id
    connectivity_delay_in_seconds                                             = var.connectivity_delay_in_seconds
    private_dns_zone_id_databricks                                            = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.azuredatabricks.net"
    customer_managed_key                                                      = null
  }

  assert {
    condition     = azurerm_databricks_workspace.databricks_workspace.resource_group_name == "tfmodule-test-rg"
    error_message = "Failed to deploy."
  }
}
