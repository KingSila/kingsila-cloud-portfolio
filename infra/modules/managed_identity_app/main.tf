resource "azurerm_user_assigned_identity" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = merge(var.tags, { "mi-environment" = var.environment })
}

data "azurerm_role_definition" "key_vault_secrets_user" {
  name  = "Key Vault Secrets User"
  scope = var.key_vault_id
}

resource "azurerm_role_assignment" "kv_secrets_user" {
  scope              = var.key_vault_id
  role_definition_id = data.azurerm_role_definition.key_vault_secrets_user.id
  principal_id       = azurerm_user_assigned_identity.this.principal_id

  principal_type = "ServicePrincipal"

  # avoids AAD lookup flakiness in some tenants
  skip_service_principal_aad_check = true
}
