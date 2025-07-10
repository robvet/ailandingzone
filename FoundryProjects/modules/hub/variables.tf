variable "hub_name" {
  description = "Name of the AI Foundry hub"
  type        = string
}

variable "location" {
  description = "Azure region for the resources"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "agent_subnet_id" {
  description = "The subnet ID for agent network injection"
  type        = string
  default     = null
}

# Model Configuration Variables
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

# Dependency resource variables
variable "cosmos_db_endpoint" {
  description = "CosmosDB endpoint URL"
  type        = string
}

variable "cosmos_db_id" {
  description = "CosmosDB resource ID"
  type        = string
}

variable "search_service_name" {
  description = "AI Search service name"
  type        = string
}

variable "search_service_id" {
  description = "AI Search service resource ID"
  type        = string
}

variable "storage_account_id" {
  description = "Storage account resource ID"
  type        = string
}

variable "storage_primary_blob_endpoint" {
  description = "Storage account primary blob endpoint"
  type        = string
}

variable "project_name" {
  description = "Name of the AI Foundry project associated with this hub"
  type        = string
}
