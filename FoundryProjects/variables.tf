# Authentication Configuration (Optional)
variable "use_service_principal" {
  description = "Whether to use service principal authentication instead of Azure CLI/managed identity"
  type        = bool
  default     = false
}

variable "client_id" {
  description = "Azure service principal client ID (application ID)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "client_secret" {
  description = "Azure service principal client secret"
  type        = string
  default     = ""
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
  default     = ""
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  default     = ""
}

# Core Configuration
variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters and numbers."
  }
}

variable "project_friendly_name" {
  description = "Friendly name for the AI Foundry project"
  type        = string
  default     = "AI Foundry Project"
}

variable "project_description" {
  description = "Description of the AI Foundry project"
  type        = string
  default     = "AI Foundry project with agent service support"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the existing resource group to deploy resources into"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]+$", var.resource_group_name))
    error_message = "Resource group name must contain only letters, numbers, underscores, periods, and hyphens."
  }
}

# Existing Networking Configuration
variable "vnet_id" {
  description = "ID of the existing Virtual Network"
  type        = string
}

variable "private_endpoint_subnet_id" {
  description = "ID of the existing Private Endpoint Subnet"
  type        = string
}

variable "agent_subnet_id" {
  description = "ID of the existing Agent Subnet (optional - for agent network injection)"
  type        = string
  default     = null
}

# Private DNS Zone IDs
variable "storage_blob_dns_zone_id" {
  description = "ID of the private DNS zone for storage blob (privatelink.blob.core.windows.net)"
  type        = string
}

variable "storage_file_dns_zone_id" {
  description = "ID of the private DNS zone for storage file (privatelink.file.core.windows.net)"
  type        = string
}

variable "key_vault_dns_zone_id" {
  description = "ID of the private DNS zone for key vault (privatelink.vaultcore.azure.net)"
  type        = string
}

variable "search_dns_zone_id" {
  description = "ID of the private DNS zone for Azure AI Search (privatelink.search.windows.net)"
  type        = string
}

variable "cosmos_db_dns_zone_id" {
  description = "ID of the private DNS zone for Cosmos DB (privatelink.documents.azure.com)"
  type        = string
}

variable "container_registry_dns_zone_id" {
  description = "ID of the private DNS zone for Container Registry (privatelink.azurecr.io)"
  type        = string
}

variable "ai_foundry_dns_zone_id" {
  description = "ID of the private DNS zone for AI Foundry (privatelink.cognitiveservices.azure.com)"
  type        = string
}

variable "openai_dns_zone_id" {
  description = "ID of the private DNS zone for OpenAI (privatelink.openai.azure.com)"
  type        = string
}

variable "ai_services_dns_zone_id" {
  description = "ID of the private DNS zone for AI Services (privatelink.services.ai.azure.com)"
  type        = string
}

# Service Configuration
variable "search_service_sku" {
  description = "SKU for Azure AI Search service"
  type        = string
  default     = "standard"
  validation {
    condition     = contains(["free", "basic", "standard", "standard2", "standard3"], var.search_service_sku)
    error_message = "Search service SKU must be one of: free, basic, standard, standard2, standard3."
  }
}

# Model Configuration
variable "model_deployment_name" {
  description = "Name of the model deployment"
  type        = string
  default     = "gpt-4o"
}

variable "model_format" {
  description = "Format of the model"
  type        = string
  default     = "OpenAI"
}

variable "model_version" {
  description = "Version of the model"
  type        = string
  default     = "2024-05-13"
}

variable "model_sku_name" {
  description = "SKU name for the model deployment"
  type        = string
  default     = "GlobalStandard"
}

variable "model_capacity" {
  description = "Capacity for the model deployment"
  type        = number
  default     = 1
}

# Tags
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "ai-foundry"
    ManagedBy   = "terraform"
  }
}

# Existing Log Analytics Workspace (for Application Insights)
variable "log_analytics_workspace_id" {
  description = "Existing Log Analytics workspace ID for Application Insights (optional)"
  type        = string
  default     = null
}