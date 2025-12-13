variable "location" {
  type        = string
  description = "Primary Azure region"
}

variable "platform_vnet_address_space" {
  type        = string
  description = "CIDR for the shared platform VNet"
  default     = "10.20.0.0/16" # or whatever you planned
}

variable "dev_connection_string" {
  type        = string
  sensitive   = true
  description = "Dev DB connection string"
}

variable "test_connection_string" {
  type      = string
  sensitive = true
}

variable "prod_connection_string" {
  type      = string
  sensitive = true
}

############################################################
# Platform Environment Variables
############################################################

variable "environment" {
  description = "Logical environment name for platform"
  type        = string
  default     = "platform"
}

############################################################
# VNet & Subnet Addressing
############################################################

variable "vnet_name" {
  description = "Name of the platform virtual network"
  type        = string
  default     = "vnet-kingsila-platform"
}


variable "aks_dev_subnet_name" {
  description = "Subnet name for dev AKS"
  type        = string
  default     = "snet-aks-dev"
}

variable "aks_dev_subnet_prefix" {
  description = "CIDR prefix for dev AKS subnet"
  type        = string
  default     = "10.20.1.0/24"
}

variable "aks_test_subnet_name" {
  description = "Subnet name for test AKS"
  type        = string
  default     = "snet-aks-test"
}

variable "aks_test_subnet_prefix" {
  description = "CIDR prefix for test AKS subnet"
  type        = string
  default     = "10.20.2.0/24"
}

variable "aks_prod_subnet_name" {
  description = "Subnet name for prod AKS"
  type        = string
  default     = "snet-aks-prod"
}

variable "aks_prod_subnet_prefix" {
  description = "CIDR prefix for prod AKS subnet"
  type        = string
  default     = "10.20.3.0/24"
}

############################################################
# Common Tags
############################################################

variable "tags" {
  description = "Common tags for platform resources"
  type        = map(string)
  default = {
    project = "cloud-native-portfolio"
    owner   = "kingsila"
  }
}
