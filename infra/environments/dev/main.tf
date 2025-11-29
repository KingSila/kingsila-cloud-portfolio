terraform {
  required_version = ">= 1.9.8"

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatekingsila"
    container_name       = "state"
    key                  = "dev.terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.52.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "random" {}

###############################################
# Resource Group (needed for fresh environment)
###############################################
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

data "azurerm_client_config" "current" {}

module "keyvault_dev" {
  source = "../../modules/keyvault" # adjust relative path

  name                = lower("kv-main${var.tags.owner}-${var.tags.environment}") # e.g. kv-kingsila-dev
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  tags = var.tags

  # access_identities = {
  #   app_service = {
  #     principal_id = azurerm_linux_web_app.app.identity[0].principal_id
  #     role         = "Key Vault Secrets User"
  #   }
  # }
}

# Terraform / current principal access to Key Vault
resource "azurerm_role_assignment" "kv_terraform_dev" {
  scope                = module.keyvault_dev.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}



module "vnet" {
  source              = "../../modules/vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  vnet_name           = "vnet-kingsila-dev"
  address_space       = ["10.10.0.0/16"]
  subnets = {
    app = {
      address_prefixes = ["10.10.1.0/24"]
    }
    data = {
      address_prefixes = ["10.10.2.0/24"]
    }
  }
  tags = var.tags
}

module "nsg_app" {
  source              = "../../modules/nsg"
  nsg_name            = "nsg-app-dev"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allowed_ssh_source  = var.allowed_ssh_source
  allowed_rdp_source  = var.allowed_rdp_source
  subnet_ids = {
    app  = module.vnet.subnet_ids["app"]
    data = module.vnet.subnet_ids["data"]
  }
  tags = var.tags

  depends_on = [module.vnet]
}

module "route_table" {
  source              = "../../modules/route_table"
  route_table_name    = "dev-route-table"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_ids = {
    app  = module.vnet.subnet_ids["app"]
    data = module.vnet.subnet_ids["data"]
  }
  tags = var.tags

  depends_on = [module.vnet]
}

# ---------------------------------------------------------------------
# App Service Infrastructure
# ---------------------------------------------------------------------

locals {
  name          = lower("${var.prefix}-app")
  keyvault_name = lower("kv-main${var.tags.owner}-${var.tags.environment}")

}

# Ensure an app service subnet exists + delegated
resource "azurerm_subnet" "appsvc" {
  name                 = var.appsvc_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = module.vnet.vnet_name
  address_prefixes     = ["10.10.20.0/27"] # adjust to your plan

  delegation {
    name = "appservice"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }

  depends_on = [module.vnet]
}

# Log Analytics
resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "${local.name}-law-${random_integer.rand.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days
}

# Application Insights (workspace-based)
resource "azurerm_application_insights" "appi" {
  name                = "${local.name}-appi-${random_integer.rand.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.law.id
}

# App Service Plan (Linux)
resource "azurerm_service_plan" "plan" {
  name                = "${local.name}-dev-asp"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = var.appservice_sku # B1 by default
}

# Web App
resource "azurerm_linux_web_app" "web" {
  name                = "${local.name}-dev-web"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      dotnet_version = "8.0"
    }
  }

  app_settings = {
    "ConnectionStrings__Db" = "@Microsoft.KeyVault(SecretUri=https://${local.keyvault_name}.vault.azure.net/secrets/connection-string/)"
  }


  # VNet Integration
  virtual_network_subnet_id = azurerm_subnet.appsvc.id
}

# App Service identity -> Key Vault access
resource "azurerm_role_assignment" "kv_appservice_dev" {
  scope                = module.keyvault_dev.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_web_app.web.identity[0].principal_id

  depends_on = [
    azurerm_linux_web_app.web,
    module.keyvault_dev
  ]
}
