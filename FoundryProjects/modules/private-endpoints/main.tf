# Private Endpoints Module
# Creates private endpoints for all required Azure services

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.12.0"
    }
  }
}

# Time delay to ensure Search service is fully provisioned
resource "time_sleep" "wait_for_search_provisioning" {
  create_duration = "120s"
}

# Private endpoint for Storage Account - blob
resource "azurerm_private_endpoint" "storage_blob" {
  name                = "${var.prefix}-${var.random_suffix}-pe-st-blob"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.prefix}-${var.random_suffix}-psc-st-blob"
    private_connection_resource_id = var.storage_account_id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.storage_blob_dns_zone_id]
  }

  tags = var.tags
}

# Private endpoint for Storage Account - file
resource "azurerm_private_endpoint" "storage_file" {
  name                = "${var.prefix}-${var.random_suffix}-pe-st-file"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.prefix}-${var.random_suffix}-psc-st-file"
    private_connection_resource_id = var.storage_account_id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.storage_file_dns_zone_id]
  }

  tags = var.tags
}

# Private endpoint for Storage Account - table
resource "azurerm_private_endpoint" "storage_table" {
  name                = "${var.prefix}-${var.random_suffix}-pe-st-table"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.prefix}-${var.random_suffix}-psc-st-table"
    private_connection_resource_id = var.storage_account_id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.storage_blob_dns_zone_id]
  }

  tags = var.tags
}

# Private endpoint for Storage Account - queue
resource "azurerm_private_endpoint" "storage_queue" {
  name                = "${var.prefix}-${var.random_suffix}-pe-st-queue"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.prefix}-${var.random_suffix}-psc-st-queue"
    private_connection_resource_id = var.storage_account_id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.storage_blob_dns_zone_id]
  }

  tags = var.tags
}

# Private endpoint for Key Vault
resource "azurerm_private_endpoint" "key_vault" {
  name                = "${var.prefix}-${var.random_suffix}-pe-kv"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.prefix}-${var.random_suffix}-psc-kv"
    private_connection_resource_id = var.key_vault_id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.key_vault_dns_zone_id]
  }

  tags = var.tags
}

# Private endpoint for Azure AI Search
resource "azurerm_private_endpoint" "search" {
  depends_on = [time_sleep.wait_for_search_provisioning]

  name                = "${var.prefix}-${var.random_suffix}-pe-search"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.prefix}-${var.random_suffix}-psc-search"
    private_connection_resource_id = var.search_service_id
    subresource_names              = ["searchService"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.search_dns_zone_id]
  }

  tags = var.tags
}

# Private endpoint for Cosmos DB
resource "azurerm_private_endpoint" "cosmos_db" {
  name                = "${var.prefix}-${var.random_suffix}-pe-cosmos"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.prefix}-${var.random_suffix}-psc-cosmos"
    private_connection_resource_id = var.cosmos_db_id
    subresource_names              = ["sql"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.cosmos_db_dns_zone_id]
  }

  tags = var.tags
}

# Private endpoint for Container Registry
resource "azurerm_private_endpoint" "container_registry" {
  name                = "${var.prefix}-${var.random_suffix}-pe-acr"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.prefix}-${var.random_suffix}-psc-acr"
    private_connection_resource_id = var.container_registry_id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.container_registry_dns_zone_id]
  }

  tags = var.tags
}

# Private endpoint for AI Foundry Hub (CognitiveServices account)
# Single private endpoint with all required DNS zones for professional deployment
resource "azurerm_private_endpoint" "ai_foundry_hub" {
  name                = "${var.prefix}-${var.random_suffix}-pe-aih"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.prefix}-${var.random_suffix}-psc-aih"
    private_connection_resource_id = var.ai_foundry_hub_id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      var.ai_foundry_dns_zone_id,    # privatelink.cognitiveservices.azure.com
      var.openai_dns_zone_id,        # privatelink.openai.azure.com
      var.ai_services_dns_zone_id    # privatelink.services.ai.azure.com
    ]
  }

  tags = var.tags
}

