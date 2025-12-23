variable "name" {
  type        = string
  description = "Name for the Application Insights resource."
}

variable "location" {
  type        = string
  description = "Azure region for Application Insights."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group where App Insights will be created."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the App Insights resource."
  default     = {}
}

variable "application_type" {
  type        = string
  description = "Type of the application (web, other)."
  default     = "web"
}

variable "daily_data_cap_gb" {
  type        = number
  description = "Daily data cap in GB to control ingestion costs."
  # 0.1 GB = 100 MB/day – very safe for dev/test environments
  default = 0.1
}

variable "retention_in_days" {
  type        = number
  description = "Retention in days for telemetry data."
  # Low retention keeps costs down; prod can override to 30+ if needed
  default = 7
}
