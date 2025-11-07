terraform {
  required_version = ">= 1.6.0"

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatekingsila"
    container_name       = "state"
    key                  = "dev.terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.115.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "vnet" {
  source              = "../../modules/vnet"
  location            = "westeurope"
  resource_group_name = "rg-kingsila-dev"
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
  tags = {
    environment = "dev"
    owner       = "KingSila"
    project     = "CloudPortfolio"
  }
}
