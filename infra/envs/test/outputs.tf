output "resource_group_name" {
  description = "Name of the test resource group."
  value       = azurerm_resource_group.rg.name
}

output "webapp_url" {
  description = "URL of the test web app."
  value       = module.app_service_test.webapp_url
}

output "identity_id" {
  description = "User-assigned identity ID used by the test app."
  value       = module.mi_app_test.identity_id
}
