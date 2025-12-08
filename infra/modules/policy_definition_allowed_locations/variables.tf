variable "name" {
  type        = string
  description = "Name of the policy definition."
}

variable "display_name" {
  type        = string
  description = "Display name for the policy definition."
}

variable "description" {
  type        = string
  description = "Description for the policy definition."
}

variable "allowed_locations" {
  type        = list(string)
  description = "List of allowed Azure regions for this policy."
}

variable "policy_category" {
  type        = string
  description = "Category under which the policy will be grouped."
  default     = "General"
}
