output "storage_blob_private_endpoint_id" {
  description = "ID of the storage blob private endpoint"
  value       = azurerm_private_endpoint.storage_blob.id
}

output "storage_file_private_endpoint_id" {
  description = "ID of the storage file private endpoint"
  value       = azurerm_private_endpoint.storage_file.id
}

output "storage_table_private_endpoint_id" {
  description = "ID of the storage table private endpoint"
  value       = azurerm_private_endpoint.storage_table.id
}

output "storage_queue_private_endpoint_id" {
  description = "ID of the storage queue private endpoint"
  value       = azurerm_private_endpoint.storage_queue.id
}

output "key_vault_private_endpoint_id" {
  description = "ID of the Key Vault private endpoint"
  value       = azurerm_private_endpoint.key_vault.id
}

output "search_private_endpoint_id" {
  description = "ID of the Azure AI Search private endpoint"
  value       = azurerm_private_endpoint.search.id
}

output "cosmos_db_private_endpoint_id" {
  description = "ID of the Cosmos DB private endpoint"
  value       = azurerm_private_endpoint.cosmos_db.id
}

output "container_registry_private_endpoint_id" {
  description = "ID of the Container Registry private endpoint"
  value       = azurerm_private_endpoint.container_registry.id
}

output "ai_foundry_hub_private_endpoint_id" {
  description = "ID of the AI Foundry Hub private endpoint"
  value       = azurerm_private_endpoint.ai_foundry_hub.id
}