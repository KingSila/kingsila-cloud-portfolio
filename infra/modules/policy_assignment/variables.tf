variable "name" {
  description = "Name of the policy assignment."
  type        = string
}

variable "scope" {
  description = "Scope at which to assign the policy (subscription, resource group, or management group)."
  type        = string
}

variable "policy_definition_id" {
  description = "The ID of the policy definition to assign."
  type        = string
}

variable "subscription_id" {
  description = "The ID of the subscription to assign the policy to."
  type        = string
}

variable "display_name" {
  description = "Display name of the policy assignment."
  type        = string
}

variable "description" {
  description = "Description of the policy assignment."
  type        = string
  default     = null
}

variable "parameters" {
  description = "JSON map of parameters to pass to the policy definition."
  type        = map(any)
  default     = {}
}


variable "location" {
  description = "Location for the policy assignment (required for policies with managed identity/remediation)."
  type        = string
  default     = "southafricanorth"
}

variable "identity_type" {
  description = "Managed identity type for the assignment (e.g., SystemAssigned). Leave empty to disable."
  type        = string
  default     = ""
}
