terraform {
  required_version = ">= 1.3.0"

  required_providers {

    modtm = {
      source  = "Azure/modtm"
      version = ">= 0.3.2, < 1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0"
    }
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

provider "azurerm" {
  subscription_id = "{}"
  tenant_id       = "{}"
  client_id       = "{}"
  client_secret   = "{}"
  features {
    cognitive_account {
      purge_soft_delete_on_destroy = true
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }

}


provider "azurerm" {
  alias           = "analytics"
  subscription_id = "{}"
  tenant_id       = "{}"
  client_id       = "{}"
  client_secret   = "{}"
  features {
    cognitive_account {
      purge_soft_delete_on_destroy = true
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }

}

provider "azurerm" {
  alias           = "platform"
  subscription_id = "{}"
  tenant_id       = "{}"
  client_id       = "{}"
  client_secret   = "{}"
  features {
    cognitive_account {
      purge_soft_delete_on_destroy = true
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }

}
