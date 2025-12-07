output "resource_group_name" {
  description = "Name of the dev resource group."
  value       = azurerm_resource_group.rg.name
}

output "webapp_url" {
  description = "URL of the dev web app."
  value       = module.app_service_dev.webapp_url
}

output "identity_id" {
  description = "User-assigned identity ID used by the dev app."
  value       = module.mi_app_dev.identity_id
}
