terraform {
  required_version = ">= 1.13.0"

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatekingsila"
    container_name       = "state"
    key                  = "test.terraform.tfstate"
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

module "vnet" {
  source              = "../../modules/vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  vnet_name           = "vnet-kingsila-test"
  address_space       = ["10.20.0.0/16"]
  subnets = {
    app = {
      address_prefixes = ["10.20.1.0/24"]
    }
    data = {
      address_prefixes = ["10.20.2.0/24"]
    }
  }
  tags = var.tags
}

module "nsg_app" {
  source              = "../../modules/nsg"
  nsg_name            = "nsg-app-test"
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
  route_table_name    = "test-route-table"
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
  name = lower("${var.prefix}-app")
}

# Ensure an app service subnet exists + delegated
resource "azurerm_subnet" "appsvc" {
  name                 = var.appsvc_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = module.vnet.vnet_name
  address_prefixes     = ["10.20.20.0/27"] # test environment subnet

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

# (Optional) Associate existing NSG if you already created one for appsvc subnet
# data "azurerm_network_security_group" "appsvc_nsg" {
#   name                = "nsg-appsvc"
#   resource_group_name = data.azurerm_resource_group.rg.name
# }
# resource "azurerm_subnet_network_security_group_association" "appsvc_assoc" {
#   subnet_id                 = azurerm_subnet.appsvc.id
#   network_security_group_id = data.azurerm_network_security_group.appsvc_nsg.id
# }

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
  name                = "${local.name}-test-asp"
  location            = var.location
  resource_group_name = "rg-kingsila-test-app"
  os_type             = "Linux"
  sku_name            = var.appservice_sku # B1 by default
}

# Web App
resource "azurerm_linux_web_app" "web" {
  name                = "${local.name}-dev-web"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      dotnet_version = "8.0"
    }
  }

  # VNet Integration
  virtual_network_subnet_id = azurerm_subnet.appsvc.id
}