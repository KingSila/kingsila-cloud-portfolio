variable "name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "location" {
  description = "Azure region for the Key Vault"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group where the Key Vault will be created"
  type        = string
}

variable "tenant_id" {
  description = "Tenant ID for the Key Vault (usually from azurerm_client_config)"
  type        = string
}

variable "sku_name" {
  description = "Key Vault SKU name (standard or premium)"
  type        = string
  default     = "standard"
}

variable "soft_delete_retention_days" {
  description = "Number of days soft delete data is retained"
  type        = number
  default     = 7
}

variable "purge_protection_enabled" {
  description = "Whether purge protection is enabled on the Key Vault"
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled for the Key Vault"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to the Key Vault"
  type        = map(string)
  default     = {}
}

variable "access_identities" {
  description = <<EOT
Map of identities to assign RBAC roles on the Key Vault.

Example:
access_identities = {
  app = {
    principal_id         = "00000000-0000-0000-0000-000000000000"
    role_definition_name = "Key Vault Secrets User"
  }
  pipeline = {
    principal_id         = "11111111-1111-1111-1111-111111111111"
    role_definition_name = "Key Vault Secrets Officer"
  }
}
EOT
  type = map(object({
    principal_id         = string
    role_definition_name = string
  }))
  default = {}
}
