variable "name" {
  type        = string
  description = "Managed identity name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for the managed identity"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "key_vault_id" {
  type        = string
  description = "ID of the central Key Vault"
}

variable "environment" {
  type        = string
  description = "Environment name (dev/test/prod)"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply"
  default     = {}
}
