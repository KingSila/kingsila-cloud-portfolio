# ---------------------------------------------------------
# Azure identity running terraform (OIDC or local)
# ---------------------------------------------------------
# data "azurerm_client_config" "current" {}
# 🔹 Already defined in provider.tf – keep only ONE copy per module.

# ---------------------------------------------------------
# Subscription + Built-in Policy Definition (Allowed locations)
# ---------------------------------------------------------
data "azurerm_subscription" "current" {
  subscription_id = data.azurerm_client_config.current.subscription_id
}

# Built-in "Allowed locations" policy definition
data "azurerm_policy_definition" "allowed_locations" {
  name = "e56962a6-4747-49cd-b67b-bf8b01975c4c"
}

module "policy_allowed_locations" {
  source = "../../modules/policy_assignment"

  name                 = "allowed-locations-${var.tags.environment}"
  subscription_id      = data.azurerm_client_config.current.subscription_id
  policy_definition_id = data.azurerm_policy_definition.allowed_locations.id
  enforce              = true

  display_name = "Allowed locations (${var.tags.environment})"
  description  = "Restrict locations for ${var.tags.environment} environment."

  parameters = {
    listOfAllowedLocations = {
      value = var.allowed_locations
    }
  }
}

# ---------------------------------------------------------
# Resource Group
# ---------------------------------------------------------
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.tags.owner}-${var.tags.environment}"
  location = var.location
  tags     = var.tags
}

# ---------------------------------------------------------
# Virtual Network
# ---------------------------------------------------------
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.tags.owner}-${var.tags.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.vnet_cidr]
  tags                = var.tags
}

# ---------------------------------------------------------
# Network Security Group
# ---------------------------------------------------------
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-app-${var.tags.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = var.tags
}

# ---------------------------------------------------------
# Route Table
# ---------------------------------------------------------
resource "azurerm_route_table" "rt" {
  name                = "${var.tags.environment}-route-table"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = var.tags
}

# ---------------------------------------------------------
# 🔻 OLD PER-ENV KEY VAULT – REMOVE THIS BLOCK
# ---------------------------------------------------------
# module "keyvault" {
#   source = "../../modules/keyvault"
#
#   name                = lower("kv-main${var.tags.owner}-${var.tags.environment}")
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   tenant_id           = data.azurerm_client_config.current.tenant_id
#
#   tags = var.tags
# }
#
# resource "azurerm_role_assignment" "kv_terraform" {
#   scope                = module.keyvault.id
#   role_definition_name = "Key Vault Secrets Officer"
#   principal_id         = data.azurerm_client_config.current.object_id
# }

# ---------------------------------------------------------
# App Service Plan
# ---------------------------------------------------------
resource "azurerm_service_plan" "app" {
  name                = "kingsila-app-${var.tags.environment}-asp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = var.app_sku
  tags                = var.tags
}

# ---------------------------------------------------------
# Web App (Linux) – now using central KV + user-assigned MI
# ---------------------------------------------------------
resource "azurerm_linux_web_app" "app" {
  name                = "kingsila-app-${var.tags.environment}-web"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.app.id

  # 🔹 Switch from SystemAssigned → UserAssigned MI from module.mi_app_dev
  identity {
    type         = "UserAssigned"
    identity_ids = [module.mi_app_dev.identity_id]
  }

  site_config {
    application_stack {
      dotnet_version = "8.0"
    }
  }

  app_settings = {
    # 🔹 Central Key Vault connection string (from provider.tf)
    ConnectionStrings__Db = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.dev_connection_string.id})"
  }

  tags = var.tags
}

# ---------------------------------------------------------
# Outputs (optional)
# ---------------------------------------------------------
# output "resource_group" {
#   value = azurerm_resource_group.rg.name
# }
#
# output "keyvault_uri" {
#   value = module.keyvault.vault_uri
# }
#
# output "web_app_url" {
#   value = azurerm_linux_web_app.app.default_hostname
# }
