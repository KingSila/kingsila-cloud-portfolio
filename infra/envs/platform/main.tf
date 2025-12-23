# 1) Platform resource group (never destroyed)
# Platform Resource Group
############################################################

resource "azurerm_resource_group" "platform" {
  name     = "rg-kingsila-platform"
  location = var.location

  tags = merge(
    {
      environment = var.environment
    },
    var.tags,
  )
}

############################################################
# Platform VNet (lives in platform RG)
############################################################

resource "azurerm_virtual_network" "platform" {
  name                = "vnet-kingsila-platform"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name

  # Big address space for all shared stuff (AKS, maybe others later)
  address_space = [var.platform_vnet_address_space]

  tags = merge(
    {
      environment = var.environment
    },
    var.tags,
  )
}


############################################################
# AKS Subnets (dev / test / prod)
############################################################

resource "azurerm_subnet" "aks_dev" {
  name                 = var.aks_dev_subnet_name
  resource_group_name  = azurerm_resource_group.platform.name
  virtual_network_name = azurerm_virtual_network.platform.name
  address_prefixes     = [var.aks_dev_subnet_prefix]

  # if you later use Azure CNI powered by Cilium / UDRs etc, we can tweak here
}

resource "azurerm_subnet" "aks_test" {
  name                 = var.aks_test_subnet_name
  resource_group_name  = azurerm_resource_group.platform.name
  virtual_network_name = azurerm_virtual_network.platform.name
  address_prefixes     = [var.aks_test_subnet_prefix]
}

resource "azurerm_subnet" "aks_prod" {
  name                 = var.aks_prod_subnet_name
  resource_group_name  = azurerm_resource_group.platform.name
  virtual_network_name = azurerm_virtual_network.platform.name
  address_prefixes     = [var.aks_prod_subnet_prefix]
}

# 2) Central Key Vault
resource "azurerm_key_vault" "central" {
  name                = "kv-kingsila-platform"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name

  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name  = "standard"

  rbac_authorization_enabled = true

  soft_delete_retention_days = 7
  purge_protection_enabled   = true

  # 🔐 Disable public network access
  public_network_access_enabled = false

  # 🔐 Network ACLs – align with central module
  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"

    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

  tags = merge(var.tags, {
    environment = "platform"
  })
}


data "azurerm_client_config" "current" {}

# 3) Role assignment for Terraform / CI (GitHub OIDC SP)
#    Use object_id from your SP (AZURE_CLIENT_ID's underlying object)
variable "terraform_sp_object_id" {
  type        = string
  description = "Object ID of the Terraform/GitHub OIDC service principal"
}

data "azurerm_role_definition" "kv_secrets_officer" {
  name  = "Key Vault Secrets Officer"
  scope = azurerm_key_vault.central.id
}

resource "azurerm_role_assignment" "kv_terraform_central" {
  scope              = azurerm_key_vault.central.id
  role_definition_id = data.azurerm_role_definition.kv_secrets_officer.id
  principal_id       = var.terraform_sp_object_id
  principal_type     = "ServicePrincipal"

  skip_service_principal_aad_check = true
}

# 4) Secrets for each environment (live in platform KV)
resource "azurerm_key_vault_secret" "dev_connection_string" {
  name         = "dev-connection-string"
  value        = var.dev_connection_string
  key_vault_id = azurerm_key_vault.central.id
}

resource "azurerm_key_vault_secret" "test_connection_string" {
  name         = "test-connection-string"
  value        = var.test_connection_string
  key_vault_id = azurerm_key_vault.central.id
}

resource "azurerm_key_vault_secret" "prod_connection_string" {
  name         = "prod-connection-string"
  value        = var.prod_connection_string
  key_vault_id = azurerm_key_vault.central.id
}
