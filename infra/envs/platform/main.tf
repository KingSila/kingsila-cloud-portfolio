# 1) Platform resource group (never destroyed)
resource "azurerm_resource_group" "platform" {
  name     = "rg-kingsila-platform"
  location = var.location
  tags = merge(var.tags, {
    environment = "platform"
  })
}

# 2) Central Key Vault
resource "azurerm_key_vault" "central" {
  name                = "kv-kingsila-platform"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name

  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name  = "standard"

  purge_protection_enabled   = true
  soft_delete_retention_days = 7
  rbac_authorization_enabled = true

  tags = merge(var.tags, {
    environment = "platform"
  })
}

data "azurerm_client_config" "current" {}

# 3) Role assignment for Terraform / CI (GitHub OIDC SP)
#    Use object_id from your SP (AZURE_CLIENT_ID's underlying object)
variable "terraform_sp_object_id" {
  type        = string
  description = "Object ID of the Terraform/GitHub OIDC service principal"
}

data "azurerm_role_definition" "kv_secrets_officer" {
  name  = "Key Vault Secrets Officer"
  scope = azurerm_key_vault.central.id
}

resource "azurerm_role_assignment" "kv_terraform_central" {
  scope              = azurerm_key_vault.central.id
  role_definition_id = data.azurerm_role_definition.kv_secrets_officer.id
  principal_id       = var.terraform_sp_object_id
  principal_type     = "ServicePrincipal"

  skip_service_principal_aad_check = true
}

# 4) Secrets for each environment (live in platform KV)
resource "azurerm_key_vault_secret" "dev_connection_string" {
  name         = "dev-connection-string"
  value        = var.dev_connection_string
  key_vault_id = azurerm_key_vault.central.id
}

resource "azurerm_key_vault_secret" "test_connection_string" {
  name         = "test-connection-string"
  value        = var.test_connection_string
  key_vault_id = azurerm_key_vault.central.id
}

resource "azurerm_key_vault_secret" "prod_connection_string" {
  name         = "prod-connection-string"
  value        = var.prod_connection_string
  key_vault_id = azurerm_key_vault.central.id
}
