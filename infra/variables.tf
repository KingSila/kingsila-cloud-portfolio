#############################
# Core environment variables
#############################

# Generic tags used across all resources
# Must include at least:
# - owner
# - environment  (dev | test | prod)
variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
}
# Azure region
variable "location" {
  description = "Azure region where resources will be deployed."
  type        = string
  default     = "southafricanorth"
}

#############################
# Networking
#############################

variable "vnet_cidr" {
  description = "Address space for the virtual network."
  type        = string
}

#############################
# App Service
#############################

variable "app_sku" {
  description = "SKU for the App Service Plan (e.g. P1v3, B1, S1)."
  type        = string

}
