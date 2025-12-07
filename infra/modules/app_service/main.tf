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
# App Settings (KV + optional App Insights)
#############################################

locals {
  # Base settings
  base_app_settings = {
    "CONNECTION_STRING" = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${var.connection_string_secret}/)"
  }

  # Include App Insights only if connection string is not null or empty
  app_settings_with_ai = (
    var.app_insights_connection_string != null &&
    trim(var.app_insights_connection_string) != ""
    ) ? merge(
    local.base_app_settings,
    {
      "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.app_insights_connection_string
    }
  ) : local.base_app_settings
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

  app_settings = local.app_settings_with_ai
}
