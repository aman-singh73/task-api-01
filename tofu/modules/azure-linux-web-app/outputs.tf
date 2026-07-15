output "id" {
  description = "The ID of the Linux Web App"
  value       = azurerm_linux_web_app.this.id
}

output "default_hostname" {
  description = "The default hostname of the Linux Web App"
  value       = azurerm_linux_web_app.this.default_hostname
}

output "identity_principal_id" {
  description = "The principal ID of the system-assigned identity"
  value       = try(azurerm_linux_web_app.this.identity[0].principal_id, null)
}



