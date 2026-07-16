variable "name" {
  description = "Name of the storage account"
  type        = string

  validation {
    condition     = length(var.name) >= 3 && length(var.name) <= 24 && can(regex("^[a-z0-9]+$", var.name))
    error_message = "Storage account name must be 3-24 characters, lowercase letters and numbers only."
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

variable "account_tier" {
  description = "Storage account tier (Standard or Premium)"
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "Account tier must be Standard or Premium."
  }
}

variable "account_replication_type" {
  description = "Replication type (LRS, GRS, RAGRS, ZRS)"
  type        = string
  default     = "LRS"

  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS"], var.account_replication_type)
    error_message = "Replication type must be LRS, GRS, RAGRS, or ZRS."
  }
}

variable "account_kind" {
  description = "Account kind (StorageV2, Storage, BlobStorage, FileStorage, BlockBlobStorage)"
  type        = string
  default     = "StorageV2"
}

variable "enable_https_traffic_only" {
  description = "Force HTTPS only"
  type        = bool
  default     = true
}

variable "min_tls_version" {
  description = "Minimum TLS version"
  type        = string
  default     = "TLS1_2"
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}



