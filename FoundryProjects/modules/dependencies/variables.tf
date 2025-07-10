variable "prefix" {
  description = "Prefix for all resources"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9]+$", var.prefix))
    error_message = "Prefix must contain only lowercase letters and numbers."
  }
}

variable "random_suffix" {
  description = "Random suffix for unique resource names"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the existing resource group"
  type        = string
}

variable "tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "search_sku" {
  description = "SKU for Azure AI Search service"
  type        = string
  default     = "standard"
  validation {
    condition     = contains(["free", "basic", "standard", "standard2", "standard3"], var.search_sku)
    error_message = "Search SKU must be one of: free, basic, standard, standard2, standard3."
  }
}

variable "log_analytics_workspace_id" {
  description = "Existing Log Analytics workspace ID (optional)"
  type        = string
  default     = null
}

variable "vnet_id" {
  description = "Existing Virtual Network ID"
  type        = string
}

variable "private_endpoint_subnet_id" {
  description = "Existing Private Endpoint Subnet ID"
  type        = string
}

variable "agent_subnet_id" {
  description = "Existing Agent Subnet ID (optional for Light Agent setup)"
  type        = string
  default     = null
}