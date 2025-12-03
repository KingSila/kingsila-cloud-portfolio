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
  description = "Description for the policy assignment"
  default     = null
}

variable "subscription_id" {
  type        = string
  description = "Subscription ID to assign the policy to"
}

variable "policy_definition_id" {
  type        = string
  description = "ID of the policy or initiative definition"
}

variable "parameters" {
  type        = any
  description = "JSON encoded parameters block for the policy assignment"
  default     = null
}

variable "enforce" {
  type        = bool
  description = "Whether to enforce the policy assignment (true) or audit only (false)"
  default     = true
}
