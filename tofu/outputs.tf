# Outputs for Terraform configuration

# Generated deterministically using Module Registry

output "main_rg_id" {
  description = "The ID of the Resource Group"
  value       = module.main_rg.id
}

output "main_rg_name" {
  description = "The name of the Resource Group"
  value       = module.main_rg.name
}

output "main_rg_location" {
  description = "The location of the Resource Group"
  value       = module.main_rg.location
}

output "log_analytics_id" {
  description = "The ID of the Log Analytics Workspace"
  value       = module.log_analytics.id
}

output "log_analytics_name" {
  description = "The name of the Log Analytics Workspace"
  value       = module.log_analytics.name
}

output "log_analytics_workspace_id" {
  description = "The workspace ID of the Log Analytics Workspace"
  value       = module.log_analytics.workspace_id
}

output "log_analytics_primary_shared_key" {
  description = "The primary shared key for the Log Analytics Workspace"
  sensitive   = true
  value       = module.log_analytics.primary_shared_key
}

output "shared_plan_id" {
  description = "The ID of the App Service Plan"
  value       = module.shared_plan.id
}

output "shared_plan_name" {
  description = "The name of the App Service Plan"
  value       = module.shared_plan.name
}

output "frontend_app_id" {
  description = "The ID of the Static Web App"
  value       = module.frontend_app.id
}

output "frontend_app_default_host_name" {
  description = "The default hostname of the Static Web App"
  value       = module.frontend_app.default_host_name
}

output "frontend_app_api_key" {
  description = "The API key for the Static Web App (sensitive)"
  sensitive   = true
  value       = module.frontend_app.api_key
}

output "task_manager_api_app_id" {
  description = "The ID of the Linux Web App"
  value       = module.task_manager_api_app.id
}

output "task_manager_api_app_default_hostname" {
  description = "The default hostname of the Linux Web App"
  value       = module.task_manager_api_app.default_hostname
}

output "task_manager_api_app_identity_principal_id" {
  description = "The principal ID of the system-assigned identity"
  value       = module.task_manager_api_app.identity_principal_id
}
