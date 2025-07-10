variable "project_id" {
  description = "ID of the AI Foundry project"
  type        = string
}

variable "project_workspace_id" {
  description = "Workspace ID of the AI Foundry project"
  type        = string
}

variable "hub_principal_id" {
  description = "Principal ID of the hub's managed identity"
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

variable "cosmos_db_id" {
  description = "ID of the Cosmos DB account"
  type        = string
}

variable "key_vault_id" {
  description = "ID of the Key Vault"
  type        = string
}

variable "search_principal_id" {
  description = "Principal ID of the search service managed identity"
  type        = string
}

variable "cosmos_principal_id" {
  description = "Principal ID of the Cosmos DB managed identity"
  type        = string
}

variable "current_user_object_id" {
  description = "Object ID of the current user for development access"
  type        = string
}

variable "enable_project_rbac" {
  description = "Whether to enable project-level RBAC assignments"
  type        = bool
  default     = true
}
