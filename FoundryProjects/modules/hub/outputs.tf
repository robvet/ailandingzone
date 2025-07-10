output "hub_id" {
  description = "ID of the AI Foundry hub"
  value       = azapi_resource.ai_foundry_hub.id
}

output "hub_name" {
  description = "Name of the AI Foundry hub"
  value       = azapi_resource.ai_foundry_hub.name
}

output "hub_principal_id" {
  description = "Principal ID of the hub's managed identity"
  value       = azapi_resource.ai_foundry_hub.output.identity.principalId
}

output "hub_workspace_id" {
  description = "Workspace ID of the AI Foundry hub"
  value       = azapi_resource.ai_foundry_hub.id
}

output "model_deployment_id" {
  description = "ID of the model deployment"
  value       = azurerm_cognitive_deployment.gpt_4o_deployment.id
}

output "model_deployment_name" {
  description = "Name of the model deployment"
  value       = azurerm_cognitive_deployment.gpt_4o_deployment.name
}

output "hub_endpoint" {
  description = "Endpoint URL of the AI Foundry hub"
  value       = "https://${azapi_resource.ai_foundry_hub.name}.cognitiveservices.azure.com/"
}

# Hub capability host output commented out due to Azure API propagation issues
# output "hub_capability_host_id" {
#   description = "ID of the hub-level capability host"
#   value       = azapi_resource.capability_host.id
# }
