# AI Foundry Hub Module
# Creates the main AI Foundry hub resource

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
  }
}

# Data source for resource group
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# Get current client configuration
data "azurerm_client_config" "current" {}

# Create AI Foundry Hub using Azure Cognitive Services for agent support
resource "azapi_resource" "ai_foundry_hub" {
  type                      = "Microsoft.CognitiveServices/accounts@2025-04-01-preview"
  name                      = var.hub_name
  location                  = var.location
  parent_id                 = data.azurerm_resource_group.main.id
  schema_validation_enabled = false

  body = {
    kind = "AIServices"
    sku = {
      name = "S0"
    }
    identity = {
      type = "SystemAssigned"
    }
    properties = {
      # Support both Entra ID and API Key authentication
      disableLocalAuth = false

      # Specifies that this is an AI Foundry resource
      allowProjectManagement = true

      # Set custom subdomain name for DNS names
      customSubDomainName = var.hub_name

      # Default project configuration
      defaultProject     = var.project_name
      associatedProjects = [var.project_name]

      # Network configuration
      publicNetworkAccess = "Disabled"
      networkAcls = {
        defaultAction       = "Allow"
        virtualNetworkRules = []
        ipRules             = []
      }

      # Network injection for agent subnet (commented out for simplified deployment)
      # networkInjections = var.agent_subnet_id != null ? [
      #   {
      #     scenario                   = "agent"
      #     subnetArmId                = var.agent_subnet_id
      #     useMicrosoftManagedNetwork = false
      #   }
      # ] : []
    }
  }

  response_export_values = [
    "identity.principalId"
  ]

  tags = var.tags
}

# Wait for hub creation and identity assignment to settle
resource "time_sleep" "wait_hub_identity" {
  depends_on      = [azapi_resource.ai_foundry_hub]
  create_duration = "120s"
}

# Create a deployment for OpenAI's GPT-4o in the AI Foundry resource
resource "azurerm_cognitive_deployment" "gpt_4o_deployment" {
  depends_on = [
    azapi_resource.ai_foundry_hub,
    time_sleep.wait_hub_identity
  ]

  name                 = var.model_deployment_name
  cognitive_account_id = azapi_resource.ai_foundry_hub.id

  sku {
    name     = "GlobalStandard"
    capacity = 1
  }

  model {
    format  = var.model_format
    name    = var.model_deployment_name
    version = var.model_version
  }
}

# Hub-level connections are experiencing Azure API propagation issues
# Temporarily disabled - using project-level connections instead

# Hub-level capability host for agent support
# Commented out due to Azure API propagation issues - using project-level capability host instead
# resource "azapi_resource" "capability_host" {
#   type                      = "Microsoft.CognitiveServices/accounts/capabilityHosts@2025-04-01-preview"
#   name                      = "${var.hub_name}@aml_aiagentservice"
#   parent_id                 = azapi_resource.ai_foundry_hub.id
#   schema_validation_enabled = false

#   depends_on = [
#     azapi_resource.ai_foundry_hub,
#     time_sleep.wait_hub_identity
#   ]

#   body = {
#     properties = {
#       customerSubnet      = var.agent_subnet_id
#       capabilityHostKind = "Agents"
#     }
#   }
# }
