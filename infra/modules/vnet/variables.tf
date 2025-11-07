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

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}
