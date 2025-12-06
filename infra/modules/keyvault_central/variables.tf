variable "name" {
  type        = string
  description = "Key Vault name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for Key Vault"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "tenant_id" {
  type        = string
  description = "Azure AD tenant ID"
}

variable "tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}
