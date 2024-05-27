resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  name                = var.user_assigned_identity_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_federated_identity_credential" "federated_identity_credential" {
  for_each = var.user_assigned_identity_federated_identity_credentials

  name                = each.key
  resource_group_name = azurerm_user_assigned_identity.user_assigned_identity.resource_group_name
  parent_id           = azurerm_user_assigned_identity.user_assigned_identity.id

  audience = [each.value.audience]
  issuer   = each.value.issuer
  subject  = each.value.subject
}
