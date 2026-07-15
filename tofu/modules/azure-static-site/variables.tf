variable "name" {
  description = "Name of the Static Web App"
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 60
    error_message = "Static Web App name must be between 1 and 60 characters."
  }
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "sku_tier" {
  description = "SKU tier for the Static Web App"
  type        = string
  default     = "Free"

  validation {
    condition     = contains(["Free", "Standard"], var.sku_tier)
    error_message = "SKU tier must be either 'Free' or 'Standard'."
  }
}

variable "sku_size" {
  description = "SKU size for the Static Web App"
  type        = string
  default     = "Free"

  validation {
    condition     = contains(["Free", "Standard"], var.sku_size)
    error_message = "SKU size must be either 'Free' or 'Standard'."
  }
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}

variable "app_settings" {
  description = "App settings (environment variables) for the Static Web App API"
  type        = map(string)
  default     = {}
}




