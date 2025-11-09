# Common variables used across multiple modules
variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-kingsila-dev"
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    environment = "dev"
    owner       = "KingSila"
    project     = "CloudPortfolio"
  }
}

# Security variables
variable "allowed_ssh_source" {
  description = "IP address allowed to SSH (format: x.x.x.x/32)"
  type        = string
}

variable "allowed_rdp_source" {
  description = "IP address allowed to RDP (format: x.x.x.x/32)"
  type        = string
}
