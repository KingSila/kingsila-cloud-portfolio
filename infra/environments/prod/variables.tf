# Common variables used across multiple modules
variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-kingsila-prod"
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    environment = "prod"
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

# Prefix for resource naming
variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

# Networking variables
variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "appsvc_subnet_name" {
  description = "Name of the App Service subnet"
  type        = string
  default     = "snet-appsvc"
}

# Feature toggles
variable "enable_diagnostics" {
  description = "Enable diagnostics logging"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 7
}

variable "enable_nat" {
  description = "Enable NAT Gateway"
  type        = bool
  default     = false
}

variable "enable_bastion" {
  description = "Enable Azure Bastion"
  type        = bool
  default     = false
}

# App Service configuration
variable "appservice_sku" {
  description = "SKU for App Service Plan"
  type        = string
  default     = "B1"
}

variable "app_runtime_stack" {
  description = "Runtime stack for App Service"
  type        = string
  default     = "DOTNET|8.0"
}

# Network security
variable "allowed_ips" {
  description = "List of allowed IP addresses for App Service access"
  type        = list(string)
  default     = []
}