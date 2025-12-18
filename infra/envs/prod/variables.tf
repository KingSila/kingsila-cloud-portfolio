############################################################
# Core Environment
############################################################

variable "location" {
  type        = string
  description = "Azure region for the prod environment."
}

variable "tags" {
  type        = map(string)
  description = "Base tags for prod resources (owner, environment)."
}

variable "app_name" {
  type        = string
  description = "Base name for the prod application."
  default     = "kingsila-app-prod"
}


variable "connection_string_secret_name" {
  type        = string
  description = "Name of the secret in the platform Key Vault."
  default     = "prod-connection-string"
}

variable "app_sku" {
  type        = string
  description = "App Service Plan SKU for prod."
  # you can bump this later if you want a bigger SKU in prod
  default = "B1"
}

variable "environment" {
  type        = string
  description = "Environment name (dev/test/prod)"
}

variable "allowed_locations" {
  type        = list(string)
  description = "List of allowed regions for this environment."
}

############################################################
# AKS Cluster
############################################################

variable "kubernetes_version" {
  type        = string
  description = "AKS Kubernetes version."
}

variable "node_pool_vm_size" {
  type        = string
  description = "VM size for the AKS node pool."
  default     = "Standard_B2s"
}

variable "node_pool_node_count" {
  type        = number
  description = "Initial node count for the AKS node pool."
  default     = 2
}

variable "node_pool_max_pods" {
  type        = number
  description = "Maximum pods per node in the AKS node pool."
  default     = 11
}
