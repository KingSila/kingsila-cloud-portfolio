variable "name" {
  description = "Base name for the AKS cluster"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for the AKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the cluster"
  type        = string
  default     = null
}

variable "dns_prefix" {
  description = "DNS prefix for the cluster"
  type        = string
}

variable "aks_subnet_id" {
  description = "Subnet ID for AKS nodes (for VNet integration)"
  type        = string
}

variable "node_pool_max_pods" {
  description = "Max pods per node"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags to apply to AKS resources"
  type        = map(string)
  default     = {}
}

variable "enable_azure_rbac" {
  description = "Enable Azure RBAC for Kubernetes authorization"
  type        = bool
  default     = true
}

variable "private_cluster_enabled" {
  description = "Enable private AKS cluster"
  type        = bool
  default     = true
}


variable "workload_identity_enabled" {
  description = "Enable workload identity (federated identity for pods)"
  type        = bool
  default     = true
}

variable "node_pool_vm_size" {
  description = "VM size for the default node pool"
  type        = string
  # Burstable, cheap, 2 vCPU / 4 GB
  default = "Standard_B2s"
}

variable "node_pool_node_count" {
  description = "Node count for the default node pool"
  type        = number
  default     = 1
}

variable "sku_tier" {
  description = "AKS SKU tier (Free | Standard | Premium)"
  type        = string
  default     = "Free" # dev/test: no control-plane cost
}

variable "enable_auto_scaling" {
  description = "Enable cluster autoscaler for default node pool"
  type        = bool
  default     = true
}

variable "min_count" {
  description = "Min nodes when autoscaling is enabled"
  type        = number
  default     = 1
}

variable "max_count" {
  description = "Max nodes when autoscaling is enabled"
  type        = number
  default     = 2
}
