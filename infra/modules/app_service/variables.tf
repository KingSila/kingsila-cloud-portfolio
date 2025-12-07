variable "name" {
  type        = string
  description = "Base name for the web app (used for plan + app)."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group where the App Service resources will be created."
}

variable "location" {
  type        = string
  description = "Azure region for the App Service."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to App Service resources."
  default     = {}
}

variable "app_sku" {
  type        = string
  description = "App Service Plan SKU (e.g. B1, P1v3)."
  default     = "B1"
}

variable "identity_id" {
  type        = string
  description = "Resource ID of the user-assigned managed identity used by the app."
}

variable "key_vault_uri" {
  type        = string
  description = "Vault URI of the central Key Vault (e.g. https://kv-kingsila-platform.vault.azure.net/)."
}

variable "connection_string_secret" {
  type        = string
  description = "Name of the connection string secret in Key Vault."
  default     = "dev-connection-string"
}

variable "app_insights_connection_string" {
  type        = string
  description = "Optional Application Insights connection string to enable telemetry."
  default     = null
}
