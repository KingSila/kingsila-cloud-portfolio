#############################################
# DEV ENV – EPHEMERAL INFRASTRUCTURE ONLY
# Platform services (KV, RBAC, identities)
# are managed in infra/envs/platform
#############################################

#######################################################
# 1. Resource Group (ephemeral)
#######################################################

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.tags.owner}-${var.tags.environment}" # e.g. rg-kingsila-dev
  location = var.location
  tags     = var.tags
}

#######################################################
# 2. Lookup Platform Key Vault (created in platform env)
#######################################################

data "azurerm_key_vault" "central" {
  name                = "kv-kingsila-platform"
  resource_group_name = "rg-kingsila-platform"
}

#######################################################
# 3. (Optional) App User Assigned Managed Identity
#######################################################

module "mi_app_dev" {
  source = "../../modules/managed_identity_app"

  name                = "mi-${var.app_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  tags        = var.tags
  environment = var.tags.environment

  # For role assignment inside the module
  key_vault_id = data.azurerm_key_vault.central.id
}

#######################################################
# 4. App Service (uses central KV + MI)
#######################################################

module "app_service_dev" {
  source = "../../modules/app_service"

  name                = var.app_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = var.tags

  # Identity from module above
  identity_id = module.mi_app_dev.identity_id

  # Key Vault integration
  key_vault_uri            = data.azurerm_key_vault.central.vault_uri
  connection_string_secret = var.connection_string_secret_name
}
