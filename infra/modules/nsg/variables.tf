variable "nsg_name" {
  description = "Name of the NSG"
  type        = string
}

variable "location" {
  description = "Azure region for the NSG"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "subnet_id" {
  description = "Optional subnet to associate NSG with"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "Optional list of subnets to associate the NSG with"
  type        = list(string)
  default     = []
}


variable "allowed_ssh_source" {
  description = "Source IP range allowed for SSH access (CIDR notation, e.g., '203.0.113.0/32')"
  type        = string
}

variable "allowed_rdp_source" {
  description = "Source IP range allowed for RDP access (CIDR notation, e.g., '203.0.113.0/32')"
  type        = string
}


variable "tags" {
  description = "Tags to apply to NSG resources"
  type        = map(string)
  default     = {
    environment = "dev"
    managed_by  = "terraform"
  }
}
