variable "name" {
  description = "Name of the App Service Plan"
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

variable "kind" {
  description = "Kind of App Service Plan (Linux, Windows, FunctionApp)"
  type        = string
  default     = "Linux"

  validation {
    condition     = contains(["Linux", "Windows", "FunctionApp"], var.kind)
    error_message = "Kind must be Linux, Windows, or FunctionApp."
  }
}

variable "sku" {
  description = "SKU configuration"
  type = object({
    tier     = string
    size     = string
    capacity = number
  })

  validation {
    condition     = contains(["Basic", "Standard", "PremiumV2", "PremiumV3", "Free", "Shared"], var.sku.tier)
    error_message = "SKU tier must be Basic, Standard, PremiumV2, PremiumV3, Free, or Shared."
  }
}

variable "reserved" {
  description = "Is this App Service Plan Reserved (required for Linux)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}



