output "project_id" {
  description = "ID of the AI Foundry project"
  value       = azapi_resource.ai_project.id
}

output "project_name" {
  description = "Name of the AI Foundry project"
  value       = azapi_resource.ai_project.name
}

output "project_endpoint" {
  description = "Endpoint URL of the AI Foundry project"
  value       = "https://ai.azure.com/projectOverview${azapi_resource.ai_project.id}"
}

output "project_workspace_id" {
  description = "Workspace ID of the AI Foundry project"
  value       = azapi_resource.ai_project.output.properties.internalId
}

output "project_principal_id" {
  description = "Principal ID of the AI Foundry project managed identity"
  value       = azapi_resource.ai_project.output.identity.principalId
}

# Project connection outputs
output "project_cosmosdb_connection_name" {
  description = "Name of the project-level CosmosDB connection"
  value       = azapi_resource.conn_cosmosdb.name
}

output "project_storage_connection_name" {
  description = "Name of the project-level Storage connection"
  value       = azapi_resource.conn_storage.name
}

output "project_search_connection_name" {
  description = "Name of the project-level AI Search connection"
  value       = azapi_resource.conn_aisearch.name
}

# Capability Host output (commented out for simplified deployment)
# output "capability_host_id" {
#   description = "ID of the project capability host for agents"
#   value       = azapi_resource.ai_foundry_project_capability_host.id
# }
