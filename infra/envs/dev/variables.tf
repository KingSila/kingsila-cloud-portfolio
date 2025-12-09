variable "location" {
  type        = string
  description = "Azure region for the dev environment."
}

variable "tags" {
  type        = map(string)
  description = "Base tags for dev resources (owner, environment)."
}

variable "app_name" {
  type        = string
  description = "Base name for the dev application."
  default     = "kingsila-app-dev"
}

variable "vnet_cidr" {
  type        = string
  description = "CIDR range for the dev VNet."
}

variable "connection_string_secret_name" {
  type        = string
  description = "Name of the secret in the platform Key Vault."
  default     = "dev-connection-string"
}

variable "app_sku" {
  type        = string
  description = "App Service Plan SKU for dev"
  default     = "B1"
}

variable "environment" {
  type        = string
  description = "Environment name (dev/test/prod)"
}

variable "allowed_locations" {
  type        = list(string)
  description = "List of allowed regions for this environment."
}
