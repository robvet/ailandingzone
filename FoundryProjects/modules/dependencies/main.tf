# Dependencies Module - Creates all required Azure resources for AI Foundry
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26.0"
    }
  }
}

# Data source for existing resource group
data "azurerm_resource_group" "ai_foundry" {
  name = var.resource_group_name
}

# Data sources for existing networking resources
data "azurerm_virtual_network" "existing" {
  name                = split("/", var.vnet_id)[8]
  resource_group_name = split("/", var.vnet_id)[4]
}

data "azurerm_subnet" "private_endpoint" {
  name                 = split("/", var.private_endpoint_subnet_id)[10]
  virtual_network_name = split("/", var.private_endpoint_subnet_id)[8]
  resource_group_name  = split("/", var.private_endpoint_subnet_id)[4]
}

data "azurerm_subnet" "agent" {
  count                = var.agent_subnet_id != null ? 1 : 0
  name                 = split("/", var.agent_subnet_id)[10]
  virtual_network_name = split("/", var.agent_subnet_id)[8]
  resource_group_name  = split("/", var.agent_subnet_id)[4]
}

# Storage Account for AI Foundry
resource "azurerm_storage_account" "ai_foundry" {
  name                = "${var.prefix}${var.random_suffix}st"
  resource_group_name = data.azurerm_resource_group.ai_foundry.name
  location            = var.location

  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  # Security settings
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = true

  # Network rules - deny all public access
  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
  }

  # Blob properties for security
  blob_properties {
    versioning_enabled  = true
    change_feed_enabled = true
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
  }

  tags = var.tags
}

# Key Vault for secrets management
resource "azurerm_key_vault" "ai_foundry" {
  name                = "${var.prefix}-${var.random_suffix}-kv"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.ai_foundry.name
  tenant_id           = var.tenant_id

  sku_name = "standard"

  # Security settings
  public_network_access_enabled = false
  enable_rbac_authorization     = true

  # Network ACLs - deny all public access
  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = var.tags
}

# Azure AI Search service
resource "azurerm_search_service" "ai_foundry" {
  name                = "${var.prefix}-${var.random_suffix}-search"
  resource_group_name = data.azurerm_resource_group.ai_foundry.name
  location            = var.location
  sku                 = var.search_sku

  # Security settings
  public_network_access_enabled = false

  # Enable system-assigned managed identity
  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Cosmos DB Account
resource "azurerm_cosmosdb_account" "ai_foundry" {
  name                = "${var.prefix}-${var.random_suffix}-cosmos"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.ai_foundry.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  # Security settings
  public_network_access_enabled = false

  # Enable system-assigned managed identity
  identity {
    type = "SystemAssigned"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  tags = var.tags
}

# Application Insights for monitoring
resource "azurerm_application_insights" "ai_foundry" {
  name                = "${var.prefix}-${var.random_suffix}-ai"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.ai_foundry.name
  application_type    = "web"

  # Connect to Log Analytics workspace (required for workspace-based Application Insights)
  workspace_id = var.log_analytics_workspace_id != null ? var.log_analytics_workspace_id : azurerm_log_analytics_workspace.ai_foundry[0].id

  tags = var.tags
}

# Log Analytics Workspace (if not provided)
resource "azurerm_log_analytics_workspace" "ai_foundry" {
  count = var.log_analytics_workspace_id == null ? 1 : 0

  name                = "${var.prefix}-${var.random_suffix}-law"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.ai_foundry.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = var.tags
}

# Container Registry for custom models/containers
resource "azurerm_container_registry" "ai_foundry" {
  name                = "${var.prefix}${var.random_suffix}acr"
  resource_group_name = data.azurerm_resource_group.ai_foundry.name
  location            = var.location
  sku                 = "Premium"

  # Security settings
  public_network_access_enabled = false
  admin_enabled                 = false

  tags = var.tags
}