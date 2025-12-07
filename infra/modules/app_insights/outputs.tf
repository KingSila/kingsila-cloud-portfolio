output "id" {
  description = "ID of the Application Insights resource."
  value       = azurerm_application_insights.this.id
}

output "instrumentation_key" {
  description = "Instrumentation key for the Application Insights resource."
  value       = azurerm_application_insights.this.instrumentation_key
}

output "connection_string" {
  description = "Connection string for the Application Insights resource."
  value       = azurerm_application_insights.this.connection_string
}
