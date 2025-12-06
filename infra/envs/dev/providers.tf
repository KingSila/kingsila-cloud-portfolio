terraform {
  required_version = ">= 1.9.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.52.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatekingsila"
    container_name       = "state"
    key                  = "dev/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# ─────────────────────────────────────────────
# Common data
# ─────────────────────────────────────────────

data "azurerm_client_config" "current" {}

# ─────────────────────────────────────────────
# 1) Central Key Vault (shared / platform-ish)
# ─────────────────────────────────────────────
# ---------------------------------------------------------
# Platform Resource Group (for shared / central resources)
# ---------------------------------------------------------
resource "azurerm_resource_group" "rg_platform" {
  name     = "rg-kingsila-platform"
  location = var.location

  tags = merge(var.tags, {
    environment = "platform"
    owner       = var.tags.owner
  })
}


module "central_key_vault" {
  source = "../../modules/keyvault_central"

  name                = "kv-kingsila-platform"
  resource_group_name = azurerm_resource_group.rg_platform.name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id

  tags = merge(var.tags, {
    environment = "platform"
    workload    = "shared-secrets"
  })
}

# ─────────────────────────────────────────────
# 2) Dev app managed identity with KV access
# ─────────────────────────────────────────────

module "mi_app_dev" {
  source = "../../modules/managed_identity_app"

  name                = "mi-kingsila-app-dev"
  resource_group_name = "rg-kingsila-dev"
  location            = var.location
  key_vault_id        = module.central_key_vault.id
  environment         = var.environment

  tags = merge(var.tags, {
    identity_role = "app-runtime"
  })
}

# ─────────────────────────────────────────────
# 3) Central secret for dev connection string
# ─────────────────────────────────────────────

resource "azurerm_key_vault_secret" "dev_connection_string" {
  name         = "dev-connection-string"
  value        = var.dev_connection_string
  key_vault_id = module.central_key_vault.id

  content_type = "sql-connection-string"

  tags = merge(var.tags, {
    environment = var.environment
    secret_role = "app-db-connection"
  })
}
