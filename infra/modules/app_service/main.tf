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
# Application Insights
#############################################

resource "azurerm_application_insights" "this" {
  name                = "${var.name}-appi"
  location            = var.location
  resource_group_name = var.resource_group_name

  application_type = "web"

  tags = var.tags
}

#############################################
# App Settings (KV + App Insights)
#############################################

locals {
  # Base settings – your existing KV reference
  base_app_settings = {
    "CONNECTION_STRING" = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${var.connection_string_secret}/)"
  }

  # Always include App Insights connection string from the resource we just created
  app_settings_with_ai = merge(
    local.base_app_settings,
    {
      "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.this.connection_string
    }
  )
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
