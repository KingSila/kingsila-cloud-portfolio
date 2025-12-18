#############################################
# TEST ENV – EPHEMERAL INFRASTRUCTURE ONLY
#############################################
data "azurerm_client_config" "current" {}

module "policy_definition_allowed_locations" {
  source = "../../modules/policy_definition_allowed_locations"

  name            = "allowed-locations-${var.environment}"
  display_name    = "Allowed locations (${var.environment})"
  description     = "Only allow resources in the approved regions for ${var.environment}."
  policy_category = "General"

  allowed_locations = var.allowed_locations
}

module "policy_allowed_locations_assignment" {
  source = "../../modules/policy_assignment"

  name            = "allowed-locations-${var.environment}"
  display_name    = "Allowed locations (${var.environment})"
  description     = "Deny deployments outside approved regions for ${var.environment}."
  subscription_id = data.azurerm_client_config.current.subscription_id

  policy_definition_id = module.policy_definition_allowed_locations.policy_definition_id
  enforce              = true

  parameters = {
    listOfAllowedLocations = {
      value = var.allowed_locations
    }
  }
}

# 1. Resource Group (ephemeral)
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.tags.owner}-${var.tags.environment}" # e.g. rg-kingsila-test
  location = var.location
  tags     = var.tags
}

# 2. Lookup Platform Key Vault (created in platform env)
data "azurerm_key_vault" "central" {
  name                = "kv-kingsila-platform"
  resource_group_name = "rg-kingsila-platform"
}

# 3. App User Assigned Managed Identity
module "mi_app_test" {
  source = "../../modules/managed_identity_app"

  name                = "mi-${var.app_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  tags        = var.tags
  environment = var.tags.environment

  key_vault_id = data.azurerm_key_vault.central.id
}

# 4. App Service (uses central KV + MI)
module "app_service_test" {
  source = "../../modules/app_service"

  name                = var.app_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = var.tags

  app_sku = var.app_sku

  identity_id              = module.mi_app_test.identity_id
  key_vault_uri            = data.azurerm_key_vault.central.vault_uri
  connection_string_secret = var.connection_string_secret_name
}


#######################################################
# 5. Lookup Platform VNet + AKS Subnet (from platform env)
#######################################################

data "azurerm_virtual_network" "platform" {
  name                = "vnet-kingsila-platform"
  resource_group_name = "rg-kingsila-platform"
}

data "azurerm_subnet" "aks" {
  name                 = "snet-aks-test"
  virtual_network_name = data.azurerm_virtual_network.platform.name
  resource_group_name  = data.azurerm_virtual_network.platform.resource_group_name
}

#######################################################
# 6. AKS Cluster (small, private, in dev RG)
#######################################################

module "aks" {
  source = "../../modules/aks"

  name = "aks-kingsila-${var.environment}"

  # AKS lives in the existing dev RG
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  dns_prefix         = "kingsila-${var.environment}"
  kubernetes_version = var.kubernetes_version

  # Subnet lives in the PLATFORM RG – looked up via data source
  aks_subnet_id = data.azurerm_subnet.aks.id



  # Control plane Free tier for dev
  sku_tier = "Free"

  enable_azure_rbac         = true
  private_cluster_enabled   = true
  workload_identity_enabled = true

  tags = {
    environment = var.environment
    project     = "cloud-native-portfolio"
    owner       = "kingsila"
  }
}

module "wi_app_test" {
  source = "../../modules/workload_identity"

  name                = "id-aks-app-test"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  oidc_issuer_url     = module.aks.oidc_issuer_url

  # This is the K8s service account identity we’re binding to
  # namespace: app-test
  # service account: api-sa
  subject = "system:serviceaccount:app-test:api-sa"

  tags = var.tags
}

resource "azurerm_role_assignment" "wi_app_test_kv_central_secrets_user" {
  scope                = data.azurerm_key_vault.central.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.wi_app_test.principal_id
}
