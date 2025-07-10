variable "project_name" {
  description = "Name of the AI Foundry project"
  type        = string
}

variable "project_friendly_name" {
  description = "Friendly name for the AI Foundry project"
  type        = string
}

variable "project_description" {
  description = "Description of the AI Foundry project"
  type        = string
}

variable "hub_id" {
  description = "ID of the AI Foundry hub"
  type        = string
}

variable "location" {
  description = "Azure region for the resources"
  type        = string
}

variable "storage_account_id" {
  description = "ID of the storage account"
  type        = string
}

variable "search_service_id" {
  description = "ID of the search service"
  type        = string
}

variable "search_service_name" {
  description = "Name of the search service"
  type        = string
}

variable "cosmos_db_id" {
  description = "ID of the Cosmos DB account"
  type        = string
}

variable "cosmos_db_endpoint" {
  description = "Endpoint of the Cosmos DB account"
  type        = string
}

variable "cosmos_db_name" {
  description = "Name of the Cosmos DB account"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
}

variable "storage_primary_blob_endpoint" {
  description = "Primary blob endpoint of the storage account"
  type        = string
}

# Hub capability host variable commented out due to Azure API propagation issues
# variable "hub_capability_host_id" {
#   description = "ID of the hub-level capability host"
#   type        = string
# }

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
