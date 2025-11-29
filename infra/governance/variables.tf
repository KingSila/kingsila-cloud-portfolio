###################
# Identity Inputs #
###################

# Your user or AAD group object ID
variable "kingsila_object_id" {
  type        = string
  description = "Azure AD object ID for KingSila (user or admin group)."
}

# GitHub Actions federated identity SP object ID
variable "github_actions_sp_object_id" {
  type        = string
  description = "Azure AD object ID of the GitHub Actions service principal."
}

##########################
# Governance Parameters  #
##########################

variable "allowed_locations" {
  type        = list(string)
  description = "List of allowed Azure locations for policy."
  default     = ["South Africa North", "South Africa West"]
}
