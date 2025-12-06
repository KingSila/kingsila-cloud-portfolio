variable "name" {
  type        = string
  description = "Name of the policy assignment"
}

variable "display_name" {
  type        = string
  description = "Display name for the policy assignment"
}

variable "description" {
  type        = string
  default     = ""
  description = "Description for the policy assignment"
}

variable "subscription_id" {
  type        = string
  description = "Subscription ID (without /subscriptions/ prefix)"
}

variable "policy_definition_id" {
  type        = string
  description = "ID of the policy definition to assign"
}

variable "enforce" {
  type        = bool
  default     = true
  description = "Whether to enforce the policy (true) or audit-only (false)"
}

variable "parameters" {
  type        = any
  default     = null
  description = "Policy parameters as a map/object, will be JSON encoded"
}
