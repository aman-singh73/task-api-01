variable "name" {
  description = "Name of the web app"
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 60
    error_message = "Web app name must be between 1 and 60 characters."
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

variable "service_plan_id" {
  description = "App Service Plan ID"
  type        = string
}

variable "runtime_stack" {
  description = "Runtime stack configuration"
  type = object({
    language = string
    version  = string
  })

  validation {
    condition     = contains(["node", "python", "dotnet", "java", "php"], var.runtime_stack.language)
    error_message = "Unsupported runtime language. Must be: node, python, dotnet, java, or php."
  }
}

variable "app_settings" {
  description = "Application settings"
  type        = map(string)
  default     = {}
}

variable "enable_system_identity" {
  description = "Enable system-assigned managed identity"
  type        = bool
  default     = true
}

variable "https_only" {
  description = "Force HTTPS only"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}

variable "virtual_network_subnet_id" {
  description = "Subnet ID for VNet integration (optional)"
  type        = string
  default     = null
}

variable "always_on" {
  description = "Should the web app run constantly"
  type        = bool
  default     = false
}

variable "use_32_bit_worker" {
  description = "Should the web app use a 32-bit worker process"
  type        = bool
  default     = false
}

variable "cors_allowed_origins" {
  description = "List of allowed CORS origins"
  type        = list(string)
  default     = []
}
