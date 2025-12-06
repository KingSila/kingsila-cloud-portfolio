terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.52.0"
    }
  }
}

# Optional: in case this module is ever used standalone
provider "azurerm" {
  features {}
}

# We rely on the current subscription (no ID input needed)
data "azurerm_client_config" "current" {}

# Defender for Cloud Free tier for key resource types
# NOTE: tier = "Free" -> no additional cost beyond normal Azure usage.

resource "azurerm_security_center_subscription_pricing" "appservices" {
  resource_type = "AppServices"
  tier          = "Free"
}

resource "azurerm_security_center_subscription_pricing" "sqlservers" {
  resource_type = "SqlServers"
  tier          = "Free"
}

resource "azurerm_security_center_subscription_pricing" "storageaccounts" {
  resource_type = "StorageAccounts"
  tier          = "Free"
}

resource "azurerm_security_center_subscription_pricing" "containers" {
  resource_type = "Containers"
  tier          = "Free"
}

resource "azurerm_security_center_subscription_pricing" "virtualmachines" {
  resource_type = "VirtualMachines"
  tier          = "Free"
}

# Optional: you can still set a security contact (free)
variable "security_contact_email" {
  type        = string
  description = "Email address for security alerts (informational in free tier)."
  default     = "smokone@gmail.com"
}

variable "security_contact_phone" {
  type        = string
  description = "Phone number for security alerts (optional)."
  default     = "+27829000497"
}

resource "azurerm_security_center_contact" "example" {
  name  = "KingSila"
  email = "smokone@gmail.com"
  phone = "+27829000497"

  alert_notifications = true
  alerts_to_admins    = true
}
