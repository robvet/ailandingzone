output "storage_account_id" {
  description = "ID of the Storage Account"
  value       = azurerm_storage_account.ai_foundry.id
}

output "storage_account_name" {
  description = "Name of the Storage Account"
  value       = azurerm_storage_account.ai_foundry.name
}

output "storage_primary_blob_endpoint" {
  description = "Primary blob endpoint of the Storage Account"
  value       = azurerm_storage_account.ai_foundry.primary_blob_endpoint
}

output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.ai_foundry.id
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.ai_foundry.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.ai_foundry.vault_uri
}

output "search_service_id" {
  description = "ID of the Azure AI Search service"
  value       = azurerm_search_service.ai_foundry.id
}

output "search_service_name" {
  description = "Name of the Azure AI Search service"
  value       = azurerm_search_service.ai_foundry.name
}

output "search_service_endpoint" {
  description = "Endpoint of the Azure AI Search service"
  value       = "https://${azurerm_search_service.ai_foundry.name}.search.windows.net/"
}

output "cosmos_db_id" {
  description = "ID of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.ai_foundry.id
}

output "cosmos_db_name" {
  description = "Name of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.ai_foundry.name
}

output "cosmos_db_account_name" {
  description = "Account name of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.ai_foundry.name
}

output "cosmos_db_endpoint" {
  description = "Endpoint of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.ai_foundry.endpoint
}

output "application_insights_id" {
  description = "ID of Application Insights"
  value       = azurerm_application_insights.ai_foundry.id
}

output "application_insights_name" {
  description = "Name of Application Insights"
  value       = azurerm_application_insights.ai_foundry.name
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation key for Application Insights"
  value       = azurerm_application_insights.ai_foundry.instrumentation_key
  sensitive   = true
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = var.log_analytics_workspace_id != null ? var.log_analytics_workspace_id : azurerm_log_analytics_workspace.ai_foundry[0].id
}

output "container_registry_id" {
  description = "ID of the Container Registry"
  value       = azurerm_container_registry.ai_foundry.id
}

output "container_registry_name" {
  description = "Name of the Container Registry"
  value       = azurerm_container_registry.ai_foundry.name
}

output "container_registry_login_server" {
  description = "Login server of the Container Registry"
  value       = azurerm_container_registry.ai_foundry.login_server
}

output "search_principal_id" {
  description = "Principal ID of the Azure AI Search managed identity"
  value       = azurerm_search_service.ai_foundry.identity[0].principal_id
}

output "cosmos_principal_id" {
  description = "Principal ID of the Cosmos DB managed identity"
  value       = azurerm_cosmosdb_account.ai_foundry.identity[0].principal_id
}

# Networking outputs
output "resource_group_name" {
  description = "Name of the resource group"
  value       = data.azurerm_resource_group.ai_foundry.name
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = data.azurerm_virtual_network.existing.id
}

output "private_endpoint_subnet_id" {
  description = "ID of the private endpoint subnet"
  value       = data.azurerm_subnet.private_endpoint.id
}

output "agent_subnet_id" {
  description = "ID of the agent subnet"
  value       = var.agent_subnet_id != null ? data.azurerm_subnet.agent[0].id : null
}