terraform {
  required_version = ">= 1.9.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.52.0"
    }
  }

  # 🔹 Remote backend (uncomment + adjust if you're using one)

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatekingsila"
    container_name       = "state"
    key                  = "infra/terraform.tfstate" # This will be overridden by -backend-config
  }
}

provider "azurerm" {
  features {}
}
