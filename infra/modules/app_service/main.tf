#############################################
# App Service Plan
#############################################

resource "azurerm_service_plan" "this" {
  name                = "${var.name}-plan"
  resource_group_name = var.resource_group_name
  location            = var.location

  os_type  = "Linux"
  sku_name = var.app_sku

  tags = var.tags
}

#############################################
# Linux Web App
#############################################

resource "azurerm_linux_web_app" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.this.id

  tags = var.tags

  identity {
    type         = "UserAssigned"
    identity_ids = [var.identity_id]
  }

  site_config {
    ftps_state = "Disabled"

    application_stack {
      # tweak to whatever runtime you actually use
      node_version = "18-lts"
    }
  }

  app_settings = {
    # Example of a Key Vault reference-based connection string in an app setting.
    # Your app code can read this as an env var (e.g. CONNECTION_STRING)
    "CONNECTION_STRING" = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${var.connection_string_secret}/)"
  }
}
