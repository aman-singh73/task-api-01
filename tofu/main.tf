# Terraform configuration generated from Resource Plan
# Environment: dev
# Generated from deterministic resource plan (Phase 2)

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.116.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0"
    }
  }

  # Remote state for prodTest stack only (analytic Square / 8e01f6cc).
  # Dedicated SA — not shared with amanNew / amantfstate8e01sa.
  backend "azurerm" {
    resource_group_name  = "prodtest-tfstate-rg"
    storage_account_name = "prodtesttfstate8e01"
    container_name       = "tfstate"
    key                  = "prodTest/dev/terraform.tfstate"
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

# Merge var.environment into tags so every resource carries the environment label.
# This ensures var.environment is consumed and not dead code.
locals {
  common_tags = merge(var.tags, { environment = var.environment })
}

# ========================================
# Phase: 1 Foundation
# ========================================

# Module: main_rg (azurerm_resource_group)
module "main_rg" {
  source = "./modules/azure-resource-group"

  location = var.location
  name     = "prodTest-dev-rg"
  tags     = local.common_tags
}

# Module: log_analytics (azurerm_log_analytics_workspace)
module "log_analytics" {
  source = "./modules/azure-log-analytics-workspace"

  location            = var.location
  name                = "prodtest-dev-log"
  resource_group_name = module.main_rg.name
  retention_in_days   = 30
  sku                 = "PerGB2018"
  tags                = local.common_tags
}

# ========================================
# Phase: 2 Shared Infrastructure
# ========================================

# Module: shared_plan (azurerm_service_plan)
module "shared_plan" {
  source = "./modules/azure-app-service-plan"

  kind                = "Linux"
  location            = var.location
  name                = "prodTest-dev-plan"
  resource_group_name = module.main_rg.name
  sku = {
    tier     = "Basic"
    size     = "B1"
    capacity = 1
  }
  tags = local.common_tags
}

# ========================================
# Phase: 3 Data
# ========================================

# Resource: pg_password (random_password)
resource "random_password" "pg_password" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}|:?"
  min_lower        = 2
  min_upper        = 2
  min_numeric      = 2
  min_special      = 2
}

# Resource: pg_server (azurerm_postgresql_flexible_server)
resource "azurerm_postgresql_flexible_server" "pg_postgresql_database" {
  name                   = "prodtest-dev-pg"
  resource_group_name    = module.main_rg.name
  location               = var.location
  version                = "16"
  administrator_login    = "pgadmin"
  administrator_password = random_password.pg_password.result
  sku_name               = "B_Standard_B1ms"
  storage_mb             = 32768
  zone                   = "1"
  tags                   = local.common_tags
  lifecycle {
    ignore_changes = [administrator_password]

  }
}

# Resource: pg_database (azurerm_postgresql_flexible_server_database)
resource "azurerm_postgresql_flexible_server_database" "pg_database" {
  name      = "prodTest-dev-db"
  server_id = azurerm_postgresql_flexible_server.pg_postgresql_database.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

# Resource: postgresql_database_fw (azurerm_postgresql_flexible_server_firewall_rule)
resource "azurerm_postgresql_flexible_server_firewall_rule" "postgresql_database_fw" {
  name             = "allow-azure-internal"
  server_id        = azurerm_postgresql_flexible_server.pg_postgresql_database.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# ========================================
# Phase: 4 Compute
# ========================================

# Module: frontend_app (azurerm_static_site)
module "frontend_app" {
  source = "./modules/azure-static-site"

  app_settings = {
    BACKEND_API_URL = "https://${module.task_manager_api_app.default_hostname}"
  }
  location            = var.location
  name                = "prodtest-dev-frontend"
  resource_group_name = module.main_rg.name
  sku_size            = "Free"
  sku_tier            = "Free"
  tags                = local.common_tags
}

# Module: task_manager_api_app (azurerm_linux_web_app)
module "task_manager_api_app" {
  source = "./modules/azure-linux-web-app"

  app_settings = {
    DATABASE_URL = "postgresql://pgadmin:${urlencode(random_password.pg_password.result)}@${azurerm_postgresql_flexible_server.pg_postgresql_database.fqdn}:5432/${azurerm_postgresql_flexible_server_database.pg_database.name}?sslmode=require"
  }
  enable_system_identity = true
  https_only             = true
  location               = var.location
  name                   = "prodtest-dev-backend"
  resource_group_name    = module.main_rg.name
  runtime_stack = {
    language = "node"
    version  = var.task_manager_api_node_version
  }
  service_plan_id = module.shared_plan.id
  tags            = local.common_tags
}
