# Variables for Terraform configuration
# Environment: dev

# Common variables
variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "centralus"
}


variable "subscription_id" {
  description = "Azure subscription ID (not a secret)"
  type        = string
}
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {
    environment = "dev"
    managed_by  = "cloud-dhan"
  }
}

# Resource-specific variables
variable "task_manager_api_node_version" {
  description = "Node.js version for task-manager-api"
  type        = string
  default     = "20-lts"
}
