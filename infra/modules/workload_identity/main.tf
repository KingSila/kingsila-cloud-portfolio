#############################################
# 1) User-assigned managed identity
#############################################

resource "azurerm_user_assigned_identity" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

#############################################
# 2) Federated identity credential
#############################################

resource "azurerm_federated_identity_credential" "this" {
  name                = "${var.name}-fic"
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.this.id

  issuer   = var.oidc_issuer_url
  subject  = var.subject
  audience = ["api://AzureADTokenExchange"]
}
