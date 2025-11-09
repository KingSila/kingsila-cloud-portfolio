terraform {
  required_version = ">= 1.13.0"

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
  }
}

provider "azurerm" {
  features {}
}

module "vnet" {
  source              = "../../modules/vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
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
  resource_group_name = var.resource_group_name
  allowed_ssh_source  = var.allowed_ssh_source
  allowed_rdp_source  = var.allowed_rdp_source
  subnet_ids = [
    module.vnet.subnet_ids["app"],
    module.vnet.subnet_ids["data"]
  ]
  tags = var.tags
}

module "route_table" {
  source              = "../../modules/route_table"
  route_table_name    = "dev-route-table"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_ids = [
    module.vnet.subnet_ids["app"],
    module.vnet.subnet_ids["data"]
  ]
  tags = var.tags
}

