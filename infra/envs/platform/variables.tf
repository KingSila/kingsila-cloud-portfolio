variable "location" {
  type        = string
  description = "Primary Azure region"
}

variable "tags" {
  type        = map(string)
  description = "Base tags for platform resources"
}


variable "dev_connection_string" {
  type        = string
  sensitive   = true
  description = "Dev DB connection string"
}

variable "test_connection_string" {
  type      = string
  sensitive = true
}

variable "prod_connection_string" {
  type      = string
  sensitive = true
}
