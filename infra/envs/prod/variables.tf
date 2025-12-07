variable "location" {
  type        = string
  description = "Azure region for the prod environment."
}

variable "tags" {
  type        = map(string)
  description = "Base tags for prod resources (owner, environment)."
}

variable "app_name" {
  type        = string
  description = "Base name for the prod application."
  default     = "kingsila-app-prod"
}

variable "vnet_cidr" {
  type        = string
  description = "CIDR range for the prod VNet."
}

variable "connection_string_secret_name" {
  type        = string
  description = "Name of the secret in the platform Key Vault."
  default     = "prod-connection-string"
}

variable "app_sku" {
  type        = string
  description = "App Service Plan SKU for prod."
  # you can bump this later if you want a bigger SKU in prod
  default = "B1"
}
