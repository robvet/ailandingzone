# Output values for the Azure AI Foundry Agent deployment

# Resource Group
output "resource_group_name" {
  description = "Name of the resource group"
  value       = module.dependencies.resource_group_name
}

# AI Foundry Hub outputs
output "hub_id" {
  description = "ID of the AI Foundry hub"
  value       = module.hub.hub_id
}

output "hub_name" {
  description = "Name of the AI Foundry hub"
  value       = module.hub.hub_name
}

output "hub_endpoint" {
  description = "Endpoint URL of the AI Foundry hub"
  value       = module.hub.hub_endpoint
}

output "model_deployment_name" {
  description = "Name of the deployed model"
  value       = module.hub.model_deployment_name
}

# AI Foundry Project outputs
output "project_id" {
  description = "ID of the AI Foundry project"
  value       = module.project.project_id
}

output "project_name" {
  description = "Name of the AI Foundry project"
  value       = module.project.project_name
}

output "project_endpoint" {
  description = "Endpoint URL of the AI Foundry project"
  value       = module.project.project_endpoint
}

# Capability Host (for agents) - commented out for simplified deployment
# output "capability_host_id" {
#   description = "ID of the capability host for agents"
#   value       = module.project.capability_host_id
# }

# Storage Account outputs
output "storage_account_name" {
  description = "Name of the storage account"
  value       = module.dependencies.storage_account_name
}

output "storage_account_id" {
  description = "ID of the storage account"
  value       = module.dependencies.storage_account_id
}

# Azure AI Search outputs
output "search_service_name" {
  description = "Name of the Azure AI Search service"
  value       = module.dependencies.search_service_name
}

output "search_service_endpoint" {
  description = "Endpoint URL of the Azure AI Search service"
  value       = module.dependencies.search_service_endpoint
}

# Cosmos DB outputs
output "cosmos_db_account_name" {
  description = "Name of the Cosmos DB account"
  value       = module.dependencies.cosmos_db_account_name
}

output "cosmos_db_endpoint" {
  description = "Endpoint URL of the Cosmos DB account"
  value       = module.dependencies.cosmos_db_endpoint
}

# Key Vault outputs
output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = module.dependencies.key_vault_name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = module.dependencies.key_vault_uri
}

# Networking outputs
output "vnet_id" {
  description = "ID of the virtual network"
  value       = module.dependencies.vnet_id
}

output "private_endpoint_subnet_id" {
  description = "ID of the private endpoint subnet"
  value       = module.dependencies.private_endpoint_subnet_id
}

output "agent_subnet_id" {
  description = "ID of the agent subnet"
  value       = module.dependencies.agent_subnet_id
  sensitive   = false
}

# Azure Portal Links
output "azure_portal_links" {
  description = "Links to view resources in the Azure Portal"
  value = {
    resource_group     = "https://portal.azure.com/#@/resource/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${module.dependencies.resource_group_name}"
    ai_foundry_hub     = "https://portal.azure.com/#@/resource${module.hub.hub_id}"
    ai_foundry_project = "https://portal.azure.com/#@/resource${module.project.project_id}"
    ai_studio          = "https://ai.azure.com/projectOverview/${module.project.project_id}"
    storage_account    = "https://portal.azure.com/#@/resource${module.dependencies.storage_account_id}"
    search_service     = "https://portal.azure.com/#@/resource${module.dependencies.search_service_id}"
    cosmos_db          = "https://portal.azure.com/#@/resource${module.dependencies.cosmos_db_id}"
    key_vault          = "https://portal.azure.com/#@/resource${module.dependencies.key_vault_id}"
  }
}

# Deployment Summary
output "deployment_summary" {
  description = "Summary of the deployed resources and next steps"
  value = {
    status = "Deployment completed successfully"
    resources_deployed = [
      "AI Foundry Hub with GPT-4o model deployment",
      "AI Foundry Project",
      "Azure AI Search service with private networking",
      "Cosmos DB account with SQL API",
      "Storage account with private endpoints",
      "Key Vault with private endpoint",
      "Virtual network with private connectivity",
      "RBAC permissions configured"
    ]
    next_steps = [
      "1. Access AI Studio: ${module.project.project_endpoint}",
      "2. Create and deploy AI applications and solutions",
      "3. Test private connectivity from the jumpbox VM",
      "4. Upload data to storage account and index in AI Search",
      "5. Create databases and containers in Cosmos DB"
    ]
    testing_access = "Use the jumpbox VM to test private network access to all services"
  }
}
