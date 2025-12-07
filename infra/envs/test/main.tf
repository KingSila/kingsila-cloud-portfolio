#############################################
# TEST ENV – EPHEMERAL INFRASTRUCTURE ONLY
#############################################

# 1. Resource Group (ephemeral)
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.tags.owner}-${var.tags.environment}" # e.g. rg-kingsila-test
  location = var.location
  tags     = var.tags
}

# 2. Lookup Platform Key Vault (created in platform env)
data "azurerm_key_vault" "central" {
  name                = "kv-kingsila-platform"
  resource_group_name = "rg-kingsila-platform"
}

# 3. App User Assigned Managed Identity
module "mi_app_test" {
  source = "../../modules/managed_identity_app"

  name                = "mi-${var.app_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  tags        = var.tags
  environment = var.tags.environment

  key_vault_id = data.azurerm_key_vault.central.id
}

# 4. App Service (uses central KV + MI)
module "app_service_test" {
  source = "../../modules/app_service"

  name                = var.app_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = var.tags

  app_sku = var.app_sku

  identity_id              = module.mi_app_test.identity_id
  key_vault_uri            = data.azurerm_key_vault.central.vault_uri
  connection_string_secret = var.connection_string_secret_name
}
