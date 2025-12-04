terraform {
  required_version = ">= 1.9.8"

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

# Resource Group for Terraform State
resource "azurerm_resource_group" "tfstate" {
  name     = "rg-tfstate"
  location = "South Africa North"

  tags = {
    purpose    = "terraform-state"
    managed_by = "terraform"
    project    = "CloudPortfolio"
  }
}

# Storage Account for Terraform State
resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstatekingsila"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  blob_properties {
    versioning_enabled = true
  }

  tags = {
    purpose    = "terraform-state"
    managed_by = "terraform"
    project    = "CloudPortfolio"
  }
}

# Storage Container for State Files
resource "azurerm_storage_container" "tfstate" {
  name                  = "state"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

# Outputs
output "resource_group_name" {
  value       = azurerm_resource_group.tfstate.name
  description = "The name of the resource group"
}

output "storage_account_name" {
  value       = azurerm_storage_account.tfstate.name
  description = "The name of the storage account"
}

output "container_name" {
  value       = azurerm_storage_container.tfstate.name
  description = "The name of the storage container"
}
