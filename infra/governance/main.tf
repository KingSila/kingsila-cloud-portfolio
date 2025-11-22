terraform {
  required_version = ">= 1.9.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.52.0"
    }
  }

  # Optional: if you want remote state for governance as well,

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatekingsila"
    container_name       = "state"
    key                  = "governance.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Get the subscription that this Terraform context is authenticated against
data "azurerm_subscription" "current" {}
