############################################################
# Identity / Context
############################################################

# Identity of the caller (Terraform – either OIDC or local)
data "azurerm_client_config" "current" {}

############################################################
# Subscription Policies – Tags & Allowed Locations
############################################################

# Require "environment" tag on all resources
module "policy_require_environment_tag" {
  source = "./modules/policy_assignment"

  name                 = "require-environment-tag"
  display_name         = "Require environment tag on resources"
  description          = "Ensures all resources have the 'environment' tag."
  subscription_id      = data.azurerm_client_config.current.subscription_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99"
  enforce              = true

  parameters = {
    tagName = {
      value = "environment"
    }
  }
}

# Require "owner" tag on all resources
module "policy_require_owner_tag" {
  source = "./modules/policy_assignment"

  name                 = "require-owner-tag"
  display_name         = "Require owner tag on resources"
  description          = "Ensures all resources have the 'owner' tag."
  subscription_id      = data.azurerm_client_config.current.subscription_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99"
  enforce              = true

  parameters = {
    tagName = {
      value = "owner"
    }
  }
}

# Built-in "Allowed locations" policy definition
# ID: /providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c
data "azurerm_policy_definition" "allowed_locations" {
  name = "e56962a6-4747-49cd-b67b-bf8b01975c4c"
}

module "policy_allowed_locations" {
  source = "./modules/policy_assignment"

  name                 = "allowed-locations"
  subscription_id      = data.azurerm_client_config.current.subscription_id
  policy_definition_id = data.azurerm_policy_definition.allowed_locations.id
  enforce              = true

  display_name = "Allowed locations"
  description  = "Restrict allowed Azure regions for this subscription."

  parameters = {
    listOfAllowedLocations = {
      value = var.allowed_locations
    }
  }
}

# Deny public network access for Key Vaults
module "policy_kv_deny_public_access" {
  source = "./modules/policy_assignment"

  name                 = "kv-deny-public-access"
  display_name         = "Key vaults should disable public network access"
  description          = "Ensures Key Vaults cannot be created or updated with public network access enabled."
  subscription_id      = data.azurerm_client_config.current.subscription_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/405c5871-3e91-4644-8a63-58e19d68ff5b"
  enforce              = true

  parameters = {
    effect = {
      value = "Deny"
    }
  }
}

# Restrict storage account network access
module "policy_storage_deny_public_access" {
  source = "./modules/policy_assignment"

  name                 = "storage-deny-public-access"
  display_name         = "Storage accounts should restrict network access"
  description          = "Restricts storage accounts from being created with open network access."
  subscription_id      = data.azurerm_client_config.current.subscription_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/34c877ad-507e-4c82-993e-3452a6e0ad3c"
  enforce              = true

  parameters = {
    effect = {
      value = "Deny"
    }
  }
}

module "policy_deny_public_storage" {
  source = "./modules/policy_assignment" # adjust path as needed

  name                 = "deny-public-storage"
  display_name         = "Deny public network access for Storage Accounts"
  description          = "Ensures storage accounts have public network access disabled."
  subscription_id      = data.azurerm_client_config.current.subscription_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/4fa4b6c0-31ca-4c0d-b10d-24b96f62a751"
  enforce              = true

  parameters = {
    effect = {
      value = "Deny"
    }
  }
}

module "policy_deny_public_key_vault" {
  source = "./modules/policy_assignment"

  name                 = "deny-public-key-vault"
  display_name         = "Deny public network access for Key Vaults"
  description          = "Prevents Key Vaults from allowing public network access."
  subscription_id      = data.azurerm_client_config.current.subscription_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/405c5871-3e91-4644-8a63-58e19d68ff5b"
  enforce              = true
  parameters           = null
}

module "policy_deny_public_sql" {
  source = "./modules/policy_assignment"

  name                 = "deny-public-sql"
  display_name         = "Deny public network access for SQL servers"
  description          = "Prevents SQL servers from having public network access enabled."
  subscription_id      = data.azurerm_client_config.current.subscription_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/1b8ca024-1d5c-4dec-8995-b1a932b41780"
  enforce              = true
  parameters           = null
}

############################################################
# Defender for Cloud (baseline)
############################################################

module "defender_free" {
  source = "./modules/defender_free"

  # Optional: set if you want emails
  security_contact_email = "smokone@gmail.com"
  security_contact_phone = "+27-82-900-0497"
}
