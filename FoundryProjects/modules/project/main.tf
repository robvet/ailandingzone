# AI Foundry Project Module
# Creates the AI project and associated connections

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
      version = "~> 0.9"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# Generate unique project workspace ID
resource "random_uuid" "project_workspace_id" {}

# Create AI Foundry Project (Cognitive Services account project)
resource "azapi_resource" "ai_project" {
  type                      = "Microsoft.CognitiveServices/accounts/projects@2025-04-01-preview"
  name                      = var.project_name
  parent_id                 = var.hub_id
  location                  = var.location
  schema_validation_enabled = false

  body = {
    sku = {
      name = "S0"
    }
    identity = {
      type = "SystemAssigned"
    }
    properties = {
      displayName = var.project_friendly_name
      description = var.project_description
    }
  }

  response_export_values = [
    "identity.principalId",
    "properties.internalId"
  ]

  tags = var.tags
}

# Wait for project creation and identity assignment to settle
resource "time_sleep" "wait_project_identities" {
  depends_on      = [azapi_resource.ai_project]
  create_duration = "10s"
}

# Project-level CosmosDB Connection
resource "azapi_resource" "conn_cosmosdb" {
  type                      = "Microsoft.CognitiveServices/accounts/projects/connections@2025-04-01-preview"
  name                      = var.cosmos_db_name
  parent_id                 = azapi_resource.ai_project.id
  schema_validation_enabled = false

  depends_on = [
    azapi_resource.ai_project,
    time_sleep.wait_project_identities
  ]

  body = {
    name = var.cosmos_db_name
    properties = {
      category = "CosmosDB"
      target   = var.cosmos_db_endpoint
      authType = "AAD"
      metadata = {
        ApiType    = "Azure"
        ResourceId = var.cosmos_db_id
        location   = var.location
      }
    }
  }
}

# Project-level Storage Connection
resource "azapi_resource" "conn_storage" {
  type                      = "Microsoft.CognitiveServices/accounts/projects/connections@2025-04-01-preview"
  name                      = var.storage_account_name
  parent_id                 = azapi_resource.ai_project.id
  schema_validation_enabled = false

  depends_on = [
    azapi_resource.ai_project,
    time_sleep.wait_project_identities
  ]

  body = {
    name = var.storage_account_name
    properties = {
      category = "AzureStorageAccount"
      target   = var.storage_primary_blob_endpoint
      authType = "AAD"
      metadata = {
        ApiType    = "Azure"
        ResourceId = var.storage_account_id
        location   = var.location
      }
    }
  }
}

# Project-level AI Search Connection
resource "azapi_resource" "conn_aisearch" {
  type                      = "Microsoft.CognitiveServices/accounts/projects/connections@2025-04-01-preview"
  name                      = var.search_service_name
  parent_id                 = azapi_resource.ai_project.id
  schema_validation_enabled = false

  depends_on = [
    azapi_resource.ai_project,
    time_sleep.wait_project_identities
  ]

  body = {
    name = var.search_service_name
    properties = {
      category = "CognitiveSearch"
      target   = "https://${var.search_service_name}.search.windows.net"
      authType = "AAD"
      metadata = {
        ApiType    = "Azure"
        ApiVersion = "2024-05-01-preview"
        ResourceId = var.search_service_id
        location   = var.location
      }
    }
  }
}

# Project Capability Host for Agents - Commented out for simplified deployment
# resource "azapi_resource" "ai_foundry_project_capability_host" {
#   type                      = "Microsoft.CognitiveServices/accounts/projects/capabilityHosts@2025-04-01-preview"
#   name                      = "caphostproj"
#   parent_id                 = azapi_resource.ai_project.id
#   schema_validation_enabled = false

#   depends_on = [
#     azapi_resource.ai_project,
#     azapi_resource.conn_aisearch,
#     azapi_resource.conn_cosmosdb,
#     azapi_resource.conn_storage,
#     time_sleep.wait_project_identities
#     # Hub capability host dependency removed due to Azure API propagation issues
#     # var.hub_capability_host_id
#   ]

#   body = {
#     properties = {
#       capabilityHostKind = "Agents"
#       vectorStoreConnections = [
#         var.search_service_name
#       ]
#       storageConnections = [
#         var.storage_account_name
#       ]
#       threadStorageConnections = [
#         var.cosmos_db_name
#       ]
#     }
#   }
# }

# Create the necessary data plane role assignments to the CosmosDB databases created by the AI Foundry Project
# Note: These use the project's internal ID as the container prefix
# Commented out for initial deployment as the containers don't exist yet - they are created automatically by the AI Foundry project

# Cosmos DB role assignment for user thread message store
# resource "azurerm_cosmosdb_sql_role_assignment" "cosmosdb_db_sql_role_aifp_user_thread_message_store" {
#   name                = uuidv5("dns", "${azapi_resource.ai_project.name}${azapi_resource.ai_project.output.identity.principalId}userthreadmessage_dbsqlrole")
#   resource_group_name = split("/", var.cosmos_db_id)[4]
#   account_name        = var.cosmos_db_name
#   scope               = "${var.cosmos_db_id}/dbs/enterprise_memory/colls/${azapi_resource.ai_project.output.properties.internalId}-thread-message-store"
#   role_definition_id  = "${var.cosmos_db_id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
#   principal_id        = azapi_resource.ai_project.output.identity.principalId

#   depends_on = [
#     # azapi_resource.ai_foundry_project_capability_host  # Commented out for simplified deployment
#   ]
# }

# Cosmos DB role assignment for system thread message store
# resource "azurerm_cosmosdb_sql_role_assignment" "cosmosdb_db_sql_role_aifp_system_thread_name" {
#   name                = uuidv5("dns", "${azapi_resource.ai_project.name}${azapi_resource.ai_project.output.identity.principalId}systemthread_dbsqlrole")
#   resource_group_name = split("/", var.cosmos_db_id)[4]
#   account_name        = var.cosmos_db_name
#   scope               = "${var.cosmos_db_id}/dbs/enterprise_memory/colls/${azapi_resource.ai_project.output.properties.internalId}-system-thread-message-store"
#   role_definition_id  = "${var.cosmos_db_id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
#   principal_id        = azapi_resource.ai_project.output.identity.principalId

#   depends_on = [
#     azurerm_cosmosdb_sql_role_assignment.cosmosdb_db_sql_role_aifp_user_thread_message_store
#   ]
# }

# Cosmos DB role assignment for agent entity store
# resource "azurerm_cosmosdb_sql_role_assignment" "cosmosdb_db_sql_role_aifp_entity_store_name" {
#   name                = uuidv5("dns", "${azapi_resource.ai_project.name}${azapi_resource.ai_project.output.identity.principalId}entitystore_dbsqlrole")
#   resource_group_name = split("/", var.cosmos_db_id)[4]
#   account_name        = var.cosmos_db_name
#   scope               = "${var.cosmos_db_id}/dbs/enterprise_memory/colls/${azapi_resource.ai_project.output.properties.internalId}-agent-entity-store"
#   role_definition_id  = "${var.cosmos_db_id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
#   principal_id        = azapi_resource.ai_project.output.identity.principalId

#   depends_on = [
#     azurerm_cosmosdb_sql_role_assignment.cosmosdb_db_sql_role_aifp_system_thread_name
#   ]
# }
