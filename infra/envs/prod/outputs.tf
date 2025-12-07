output "resource_group_name" {
  description = "Name of the prod resource group."
  value       = azurerm_resource_group.rg.name
}

output "webapp_url" {
  description = "URL of the prod web app."
  value       = module.app_service_prod.webapp_url
}

output "identity_id" {
  description = "User-assigned identity ID used by the prod app."
  value       = module.mi_app_prod.identity_id
}
