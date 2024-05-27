run "create_userassignedidentity" {
  command = apply

  variables {
    location            = "northeurope"
    resource_group_name = "tfmdltst-dev-rg"
    tags = {
      test = "userassignedidentity"
    }
    user_assigned_identity_name = "mytftst-001"
    user_assigned_identity_federated_identity_credentials = {
      example = {
        audience = "foo"
        issuer   = "https://foo"
        subject  = "foo"
      }
    }
  }

  assert {
    condition     = azurerm_user_assigned_identity.user_assigned_identity.resource_group_name == "tfmdltst-dev-rg"
    error_message = "Failed to deploy."
  }
}
