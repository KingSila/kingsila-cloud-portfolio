# ---------------------------------------------------------
# Azure identity running terraform (OIDC or local)
# ---------------------------------------------------------
data "azurerm_client_config" "current" {}

# ---------------------------------------------------------
# Subscription + Built-in Policy Definition (Allowed locations)
# ---------------------------------------------------------
data "azurerm_subscription" "current" {
  # Explicit, though optional – makes intent clear
  subscription_id = data.azurerm_client_config.current.subscription_id
}

# Built-in "Allowed locations" policy definition
# ID: /providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c
data "azurerm_policy_definition" "allowed_locations" {
  name = "e56962a6-4747-49cd-b67b-bf8b01975c4c"
}

module "policy_allowed_locations" {
  source = "./modules/policy_assignment"

  name                 = "allowed-locations-${var.tags.environment}"
  subscription_id      = data.azurerm_client_config.current.subscription_id
  policy_definition_id = data.azurerm_policy_definition.allowed_locations.id
  enforce              = true

  display_name = "Allowed locations (${var.tags.environment})"
  description  = "Restrict locations for ${var.tags.environment} environment."

  # parameters is a simple JSON string argument in azurerm 4.x, passed via module
  parameters = {
    listOfAllowedLocations = {
      value = var.allowed_locations
    }
  }
}

# ---------------------------------------------------------
# Resource Group
# Driven by var.tags.environment (dev/test/prod)
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
# Key Vault (single module used for all environments)
# ---------------------------------------------------------
module "keyvault" {
  source = "./modules/keyvault"

  name                = lower("kv-main${var.tags.owner}-${var.tags.environment}")
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  tags = var.tags
}

# Terraform identity access to Key Vault
resource "azurerm_role_assignment" "kv_terraform" {
  scope                = module.keyvault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

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
# Web App (Linux)
# ---------------------------------------------------------
resource "azurerm_linux_web_app" "app" {
  name                = "kingsila-app-${var.tags.environment}-web"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.app.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      dotnet_version = "8.0"
    }
  }

  app_settings = {
    ConnectionStrings__Db = "@Microsoft.KeyVault(SecretUri=${module.keyvault.vault_uri}secrets/connection-string/)"
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
