output "key" {
  value     = azurerm_ai_services.this.primary_access_key
  sensitive = true
}

output "name" {
  value = azurerm_ai_services.this.name
}

output "id" {
  value = azurerm_ai_services.this.id
}

output "AIServicesResource" {
  value = azurerm_ai_services.this.endpoint
}
