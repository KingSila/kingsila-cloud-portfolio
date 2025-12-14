variable "name" {
  description = "Base name for the workload identity"
  type        = string
}

variable "location" {
  description = "Location of the managed identity"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for the identity"
  type        = string
}

variable "oidc_issuer_url" {
  description = "AKS OIDC issuer URL"
  type        = string
}

variable "subject" {
  description = "OIDC subject (service account) that can assume this identity"
  type        = string
  # Example: "system:serviceaccount:app-dev:app-sa"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
