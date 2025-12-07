resource "azurerm_application_insights" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  application_type = var.application_type
  tags             = var.tags

  # Cost controls
  retention_in_days                     = var.retention_in_days
  daily_data_cap_in_gb                  = var.daily_data_cap_gb
  daily_data_cap_notifications_disabled = false

  # This doesn't affect cost much but is generally good practice
  sampling_percentage = 20
}
