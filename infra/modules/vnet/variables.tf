variable "location" {
  description = "Azure region for all resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "address_space" {
  description = "Address space for the VNet"
  type        = list(string)
}

variable "subnets" {
  description = "Map of subnets"
  type = map(object({
    address_prefixes = list(string)
  }))
}

# Budget toggles
variable "enable_nat" {
  type    = bool
  default = false
}

variable "enable_bastion" {
  type    = bool
  default = false
}

variable "enable_diagnostics" {
  type    = bool
  default = true
}

variable "log_retention_days" {
  type    = number
  default = 7
}

variable "private_endpoints" {
  type    = list(string)
  default = ["none"] # e.g. ["storage","keyvault"]
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = { env = "dev", owner = "kingsila", cost = "lean" }
}
