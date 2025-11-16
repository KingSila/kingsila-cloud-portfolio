# App Service Outputs
output "webapp_name" {
  description = "Name of the web app"
  value       = azurerm_linux_web_app.web.name
}

output "webapp_url" {
  description = "Default hostname of the web app"
  value       = azurerm_linux_web_app.web.default_hostname
}

output "law_id" {
  description = "ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.law.id
}

# Application Insights
output "appinsights_instrumentation_key" {
  description = "Application Insights instrumentation key"
  value       = azurerm_application_insights.appi.instrumentation_key
  sensitive   = true
}

output "appinsights_connection_string" {
  description = "Application Insights connection string"
  value       = azurerm_application_insights.appi.connection_string
  sensitive   = true
}

output "ci_smoke_test" {
  value       = "hello-from-pr"
  description = "Harmless output to test CI. 00:51PM"
}

