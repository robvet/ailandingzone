
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.19.0"
      configuration_aliases = [azurerm.platform, azurerm.analytics]
    }
    azapi = {
      source  = "Azure/azapi"
    }
  }
}

# --- This module creates an ai studio resource --- #

resource "azurerm_ai_foundry" "this" {
  name                       = var.machine_learning_workspace_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  storage_account_id         = var.storage_account_id
  key_vault_id               = var.key_vault_id
  container_registry_id      = var.acr_id
  application_insights_id    = var.appi_id
  public_network_access      = "Disabled"
  friendly_name              = "aistudio-east-new"
  high_business_impact_enabled = true
  managed_network {
    isolation_mode             = "AllowInternetOutbound"
  }
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_ai_foundry_project" "this" {
  name               = "aiproject123"
  location           = var.location
  ai_services_hub_id = azurerm_ai_foundry.this.id
  friendly_name      = "aiprojdefaultnew"
  identity {
    type = "SystemAssigned"
  }
}

# --------- This module creates a private endpoints needed for ai studio and project ----------- #
data "azurerm_private_dns_zone" "ml" {
  provider            = azurerm.platform
  name                = var.private_endpoints.privateDnsZoneName[0]
  resource_group_name = var.private_dns_zone_resource_group_name
}

data "azurerm_private_dns_zone" "nb" {
  provider            = azurerm.platform
  name                = var.private_endpoints.privateDnsZoneName[1]
  resource_group_name = var.private_dns_zone_resource_group_name
}

resource "azurerm_private_endpoint" "this" {
  provider            = azurerm.platform
  name                = var.private_endpoints.privateEndpointName
  location            = var.location
  resource_group_name = var.private_endpoints.resourceGroupName
  subnet_id           = var.compute_subnet_id

  private_service_connection {
    name                           = var.private_endpoints.privateEndpointName
    private_connection_resource_id = azurerm_ai_foundry.this.id
    is_manual_connection           = false
    subresource_names              = [var.private_endpoints.privateEndpointGroupId]
  }

  private_dns_zone_group {
    name = var.private_endpoints.privateEndpointGroupId
    private_dns_zone_ids = [
      data.azurerm_private_dns_zone.ml.id,
      data.azurerm_private_dns_zone.nb.id
    ]
  }
}

resource "azurerm_role_assignment" "rbac" {
  count                = length(var.user_principal_ids)
  scope                = azurerm_ai_foundry.this.id
  role_definition_name = "Azure AI Developer"
  principal_id         = var.user_principal_ids[count.index]
}

