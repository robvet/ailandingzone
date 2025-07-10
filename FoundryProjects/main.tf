# Azure AI Foundry with Agent Service - Clean Implementation
# Based on official foundry-samples and ailandingzone reference architectures

terraform {
  required_version = ">= 1.8.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.12.0"
    }
  }
}

# Configure the Azure Provider
provider "azurerm" {
  subscription_id = var.subscription_id
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  storage_use_azuread = true
}

# Configure the AzAPI Provider
provider "azapi" {
}

# Data sources
data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

# Generate random suffix for unique naming
resource "random_id" "suffix" {
  byte_length = 2
}

# Local variables for consistent naming
locals {
  suffix = lower(random_id.suffix.hex)
  common_tags = merge(var.tags, {
    Environment = "dev"
    Project     = var.project_name
    ManagedBy   = "terraform"
  })
}

# Create dependencies (Storage, Search, Cosmos DB, Key Vault, etc.)
module "dependencies" {
  source = "./modules/dependencies"

  prefix                     = var.project_name
  random_suffix              = local.suffix
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  search_sku                 = var.search_service_sku
  vnet_id                    = var.vnet_id
  private_endpoint_subnet_id = var.private_endpoint_subnet_id
  agent_subnet_id            = var.agent_subnet_id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  tags                       = local.common_tags
}

# Create AI Foundry Hub
module "hub" {
  source = "./modules/hub"

  hub_name            = "${var.project_name}hub${local.suffix}"
  project_name        = "${var.project_name}proj${local.suffix}"
  resource_group_name = module.dependencies.resource_group_name
  location            = var.location
  agent_subnet_id     = var.agent_subnet_id

  # Model configuration
  model_deployment_name = var.model_deployment_name
  model_format          = var.model_format
  model_version         = var.model_version
  model_sku_name        = var.model_sku_name
  model_capacity        = var.model_capacity

  # Dependency resources for hub-level connections
  cosmos_db_endpoint            = module.dependencies.cosmos_db_endpoint
  cosmos_db_id                  = module.dependencies.cosmos_db_id
  search_service_name           = module.dependencies.search_service_name
  search_service_id             = module.dependencies.search_service_id
  storage_account_id            = module.dependencies.storage_account_id
  storage_primary_blob_endpoint = module.dependencies.storage_primary_blob_endpoint

  tags = local.common_tags

  depends_on = [module.dependencies]
}

# Create AI Foundry Project  
module "project" {
  source = "./modules/project"

  project_name          = "${var.project_name}proj${local.suffix}"
  project_friendly_name = var.project_friendly_name
  project_description   = var.project_description
  hub_id                = module.hub.hub_id
  location              = var.location

  # Storage configuration
  storage_account_id            = module.dependencies.storage_account_id
  storage_account_name          = module.dependencies.storage_account_name
  storage_primary_blob_endpoint = module.dependencies.storage_primary_blob_endpoint

  # Search configuration
  search_service_id   = module.dependencies.search_service_id
  search_service_name = module.dependencies.search_service_name

  # Cosmos DB configuration
  cosmos_db_id       = module.dependencies.cosmos_db_id
  cosmos_db_name     = module.dependencies.cosmos_db_name
  cosmos_db_endpoint = module.dependencies.cosmos_db_endpoint

  # Hub capability host dependency commented out due to Azure API propagation issues
  # hub_capability_host_id = module.hub.hub_capability_host_id

  tags = local.common_tags

  depends_on = [module.hub]
}

# Create private endpoints
module "private_endpoints" {
  source = "./modules/private-endpoints"

  prefix              = var.project_name
  random_suffix       = local.suffix
  resource_group_name = module.dependencies.resource_group_name
  location            = var.location
  subnet_id           = module.dependencies.private_endpoint_subnet_id

  # Resource IDs
  storage_account_id    = module.dependencies.storage_account_id
  key_vault_id          = module.dependencies.key_vault_id
  search_service_id     = module.dependencies.search_service_id
  cosmos_db_id          = module.dependencies.cosmos_db_id
  container_registry_id = module.dependencies.container_registry_id
  ai_foundry_hub_id     = module.hub.hub_id

  # Private DNS Zone IDs
  storage_blob_dns_zone_id       = var.storage_blob_dns_zone_id
  storage_file_dns_zone_id       = var.storage_file_dns_zone_id
  key_vault_dns_zone_id          = var.key_vault_dns_zone_id
  search_dns_zone_id             = var.search_dns_zone_id
  cosmos_db_dns_zone_id          = var.cosmos_db_dns_zone_id
  container_registry_dns_zone_id = var.container_registry_dns_zone_id
  ai_foundry_dns_zone_id         = var.ai_foundry_dns_zone_id
  openai_dns_zone_id             = var.openai_dns_zone_id
  ai_services_dns_zone_id        = var.ai_services_dns_zone_id

  tags = local.common_tags

  depends_on = [module.project]
}

# Create RBAC assignments
module "rbac" {
  source = "./modules/rbac"

  # Project and Hub IDs
  project_id           = module.project.project_id
  project_workspace_id = module.project.project_workspace_id
  hub_principal_id     = module.hub.hub_principal_id

  # Service IDs for RBAC
  storage_account_id = module.dependencies.storage_account_id
  search_service_id  = module.dependencies.search_service_id
  cosmos_db_id       = module.dependencies.cosmos_db_id
  key_vault_id       = module.dependencies.key_vault_id

  # Managed identity principal IDs
  search_principal_id = module.dependencies.search_principal_id
  cosmos_principal_id = module.dependencies.cosmos_principal_id

  # Current user for development access
  current_user_object_id = data.azurerm_client_config.current.object_id

  # Enable project-level RBAC in dedicated RBAC module
  enable_project_rbac = true

  depends_on = [module.private_endpoints]
}
