output "webapp_name" {
  description = "Name of the created web app."
  value       = azurerm_linux_web_app.this.name
}

output "webapp_url" {
  description = "Default hostname of the web app."
  value       = azurerm_linux_web_app.this.default_hostname
}

output "service_plan_id" {
  description = "ID of the App Service Plan."
  value       = azurerm_service_plan.this.id
}
