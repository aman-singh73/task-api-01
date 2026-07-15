variable "name" {
  description = "Name of the Log Analytics Workspace"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "sku" {
  description = "SKU (PerGB2018, Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation)"
  type        = string
  default     = "PerGB2018"

  validation {
    condition     = contains(["PerGB2018", "Free", "PerNode", "Premium", "Standard", "Standalone", "Unlimited", "CapacityReservation"], var.sku)
    error_message = "Invalid SKU. Must be one of: PerGB2018, Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation."
  }
}

variable "retention_in_days" {
  description = "Retention period in days"
  type        = number
  default     = 30

  validation {
    condition     = var.retention_in_days >= 30 && var.retention_in_days <= 730
    error_message = "Retention in days must be between 30 and 730."
  }
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}



