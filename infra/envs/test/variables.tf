variable "location" {
  type        = string
  description = "Azure region for the test environment."
}

variable "tags" {
  type        = map(string)
  description = "Base tags for test resources (owner, environment)."
}

variable "app_name" {
  type        = string
  description = "Base name for the test application."
  default     = "kingsila-app-test"
}

variable "vnet_cidr" {
  type        = string
  description = "CIDR range for the test VNet."
}

variable "connection_string_secret_name" {
  type        = string
  description = "Name of the secret in the platform Key Vault."
  default     = "test-connection-string"
}

variable "app_sku" {
  type        = string
  description = "App Service Plan SKU for test."
  default     = "B1"
}
