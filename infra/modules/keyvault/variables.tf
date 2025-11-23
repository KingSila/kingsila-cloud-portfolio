variable "name" {
  type        = string
  description = "Key Vault name"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "westeurope"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "tenant_id" {
  type        = string
  description = "AAD tenant ID"
}

variable "sku_name" {
  type    = string
  default = "standard"
}

variable "soft_delete_retention_days" {
  type    = number
  default = 7
}

variable "purge_protection_enabled" {
  type    = bool
  default = true
}

variable "public_network_access_enabled" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}

# Map of identities we grant access to
# Example:
# access_identities = {
#   app_service = {
#     principal_id = "xxx"
#     role         = "Key Vault Secrets User"
#   }
# }
variable "access_identities" {
  type = map(object({
    principal_id = string
    role         = string
  }))
  default = {}
}
