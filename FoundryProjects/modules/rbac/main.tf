# RBAC Module  
# Creates role assignments for proper Azure AI Foundry integration

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.12.0"
    }
  }
}

# Get project managed identity principal ID
data "azapi_resource" "project" {
  type        = "Microsoft.CognitiveServices/accounts/projects@2025-04-01-preview"
  resource_id = var.project_id
}

# Get project managed identity principal ID from the project workspace ID
locals {
  # Use hub principal ID as a fallback for now since project principal ID is complex to extract
  project_principal_id = var.hub_principal_id
}

# Time delay to ensure managed identity is properly created
resource "time_sleep" "wait_for_identity" {
  depends_on      = [data.azapi_resource.project]
  create_duration = "60s"
}

# Role assignments for project managed identity on Azure AI Search
resource "azurerm_role_assignment" "project_search_index_contributor" {
  count = var.enable_project_rbac ? 1 : 0

  depends_on           = [time_sleep.wait_for_identity]
  scope                = var.search_service_id
  role_definition_name = "Search Index Data Contributor"
  principal_id         = local.project_principal_id
}

resource "azurerm_role_assignment" "project_search_service_contributor" {
  count = var.enable_project_rbac ? 1 : 0

  depends_on           = [time_sleep.wait_for_identity]
  scope                = var.search_service_id
  role_definition_name = "Search Service Contributor"
  principal_id         = local.project_principal_id
}

# Role assignments for project managed identity on Storage Account
# Note: Storage Blob Data Owner is handled in project module with conditional access for agents

resource "azurerm_role_assignment" "project_storage_blob_contributor" {
  count = var.enable_project_rbac ? 1 : 0

  depends_on           = [time_sleep.wait_for_identity]
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = local.project_principal_id
}

# Role assignments for project managed identity on Cosmos DB
resource "azurerm_role_assignment" "project_cosmos_operator" {
  count = var.enable_project_rbac ? 1 : 0

  depends_on           = [time_sleep.wait_for_identity]
  scope                = var.cosmos_db_id
  role_definition_name = "Cosmos DB Operator"
  principal_id         = local.project_principal_id
}

# Cosmos DB built-in data contributor for the entire account
# This allows the project to access all databases and containers
resource "azurerm_cosmosdb_sql_role_assignment" "project_cosmos_data_contributor" {
  count = var.enable_project_rbac ? 1 : 0

  depends_on          = [time_sleep.wait_for_identity]
  resource_group_name = split("/", var.cosmos_db_id)[4]
  account_name        = split("/", var.cosmos_db_id)[8]
  role_definition_id  = "/subscriptions/${split("/", var.cosmos_db_id)[2]}/resourceGroups/${split("/", var.cosmos_db_id)[4]}/providers/Microsoft.DocumentDB/databaseAccounts/${split("/", var.cosmos_db_id)[8]}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
  principal_id        = local.project_principal_id
  scope               = var.cosmos_db_id
}

# Additional time delay for Cosmos DB role propagation
resource "time_sleep" "wait_for_cosmos_rbac" {
  count = var.enable_project_rbac ? 1 : 0

  depends_on      = [azurerm_cosmosdb_sql_role_assignment.project_cosmos_data_contributor]
  create_duration = "30s"
}

# Role assignments for capability host - Key Vault access
resource "azurerm_role_assignment" "project_key_vault_secrets_user" {
  count = var.enable_project_rbac ? 1 : 0

  depends_on           = [time_sleep.wait_for_identity]
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = local.project_principal_id
}

# Role assignments for capability host - Container Apps permissions (if needed for agents)
resource "azurerm_role_assignment" "project_contributor" {
  count = var.enable_project_rbac ? 1 : 0

  depends_on           = [time_sleep.wait_for_identity]
  scope                = "/subscriptions/${split("/", var.project_id)[2]}/resourceGroups/${split("/", var.project_id)[4]}"
  role_definition_name = "Contributor"
  principal_id         = local.project_principal_id
}

# Role assignments for service managed identities on Storage
resource "azurerm_role_assignment" "search_storage_blob_contributor" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.search_principal_id
}

resource "azurerm_role_assignment" "cosmos_storage_contributor" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.cosmos_principal_id
}

# Role assignments for current user (development access)
resource "azurerm_role_assignment" "user_ai_developer" {
  scope                = var.project_id
  role_definition_name = "Azure AI User"
  principal_id         = var.current_user_object_id
}
