variable "prefix" {
  description = "Prefix for all resources"
  type        = string
}

variable "random_suffix" {
  description = "Random suffix for unique resource names"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for private endpoints"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

# Resource IDs
variable "storage_account_id" {
  description = "ID of the storage account"
  type        = string
}

variable "key_vault_id" {
  description = "ID of the Key Vault"
  type        = string
}

variable "search_service_id" {
  description = "ID of the search service"
  type        = string
}

variable "cosmos_db_id" {
  description = "ID of the Cosmos DB account"
  type        = string
}

variable "container_registry_id" {
  description = "ID of the Container Registry"
  type        = string
}

variable "ai_foundry_hub_id" {
  description = "ID of the AI Foundry hub"
  type        = string
}

# Private DNS Zone IDs
variable "storage_blob_dns_zone_id" {
  description = "ID of the private DNS zone for storage blob"
  type        = string
}

variable "storage_file_dns_zone_id" {
  description = "ID of the private DNS zone for storage file"
  type        = string
}

variable "key_vault_dns_zone_id" {
  description = "ID of the private DNS zone for key vault"
  type        = string
}

variable "search_dns_zone_id" {
  description = "ID of the private DNS zone for search service"
  type        = string
}

variable "cosmos_db_dns_zone_id" {
  description = "ID of the private DNS zone for cosmos db"
  type        = string
}

variable "container_registry_dns_zone_id" {
  description = "ID of the private DNS zone for container registry"
  type        = string
}

variable "ai_foundry_dns_zone_id" {
  description = "ID of the private DNS zone for AI Foundry"
  type        = string
}

variable "openai_dns_zone_id" {
  description = "ID of the private DNS zone for OpenAI"
  type        = string
}

variable "ai_services_dns_zone_id" {
  description = "ID of the private DNS zone for AI Services"
  type        = string
}
