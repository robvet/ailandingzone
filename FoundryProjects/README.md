# Azure AI Foundry Infrastructure with Terraform

This repository contains Terraform infrastructure-as-code (IaC) for deploying a secure, enterprise-ready Azure AI Foundry environment with agent service capabilities. The deployment follows Azure best practices with private networking, managed identities, and comprehensive security controls.

## 🏗️ Architecture Overview

This solution deploys a complete Azure AI Foundry infrastructure with the following components:

### Core AI Services
- **Azure AI Foundry Hub** - Central management for AI resources and model deployments
- **Azure AI Foundry Project** - Workspace for AI application development
- **GPT-4o Model Deployment** - Pre-configured OpenAI model endpoint

### Supporting Services
- **Azure AI Search** - Vector and full-text search capabilities
- **Cosmos DB** - NoSQL database for application data
- **Storage Account** - Blob storage for data and artifacts
- **Key Vault** - Secrets and configuration management
- **Application Insights** - Monitoring and observability

### Security & Networking
- **Private Endpoints** - All services accessible only through private network
- **Managed Identities** - Authentication without stored credentials
- **RBAC** - Role-based access control with least privilege
- **Private DNS Zones** - DNS resolution for private endpoints

## 📋 Prerequisites

### Required Resources
Before deploying this infrastructure, you must have the following existing resources:

1. **Azure Subscription** with appropriate permissions
2. **Resource Group** where resources will be deployed
3. **Virtual Network (VNet)** with the following subnets:
   - Private Endpoint Subnet (for service private endpoints)
   - Agent Subnet (optional, for advanced agent configurations)
4. **Private DNS Zones** for each service type:
   - `privatelink.blob.core.windows.net`
   - `privatelink.file.core.windows.net`
   - `privatelink.vaultcore.azure.net`
   - `privatelink.search.windows.net`
   - `privatelink.documents.azure.com`
   - `privatelink.azurecr.io`
   - `privatelink.cognitiveservices.azure.com`
   - `privatelink.openai.azure.com`
   - `privatelink.services.ai.azure.com`

### Tools Required
- [Terraform](https://www.terraform.io/downloads) >= 1.8.3
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) (for authentication)
- Access to an Azure subscription with Contributor permissions

## 🚀 Quick Start

### 1. Clone and Configure

```bash
git clone <repository-url>
cd FoundryProjects
```

### 2. Set Up Variables

Copy the example variables file and customize it:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your specific values:

```hcl
# Authentication Configuration
subscription_id = "your-subscription-id"

# Core Configuration
project_name          = "aifoundry"
project_friendly_name = "AI Foundry Project"
location              = "eastus2"
resource_group_name   = "rg-agents"

# Existing Networking Configuration
vnet_id                    = "/subscriptions/your-sub-id/resourceGroups/your-network-rg/providers/Microsoft.Network/virtualNetworks/your-vnet"
private_endpoint_subnet_id = "/subscriptions/your-sub-id/resourceGroups/your-network-rg/providers/Microsoft.Network/virtualNetworks/your-vnet/subnets/pe-subnet"

# Private DNS Zone IDs (get from your existing DNS zones)
storage_blob_dns_zone_id = "/subscriptions/your-sub-id/resourceGroups/your-dns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
# ... (add all other DNS zone IDs)
```

### 3. Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Review planned changes
terraform plan

# Deploy infrastructure
terraform apply
```

### 4. Access Your Environment

After deployment, use the output values to access your resources:

```bash
# View all outputs
terraform output

# Get AI Studio URL
terraform output project_endpoint
```

## 📁 Project Structure

```
├── main.tf                    # Main Terraform configuration
├── variables.tf               # Input variables
├── outputs.tf                 # Output values
├── terraform.tfvars.example   # Example variable values
├── .gitignore                 # Git ignore rules for security
└── modules/
    ├── dependencies/          # Core Azure services
    ├── hub/                   # AI Foundry Hub
    ├── project/               # AI Foundry Project
    ├── private-endpoints/     # Private networking
    └── rbac/                  # Role assignments
```

## 🔧 Configuration Options

### Model Configuration

Configure the AI model deployment:

```hcl
model_deployment_name = "gpt-4o"           # Model name
model_format          = "OpenAI"          # Model format
model_version         = "2024-05-13"      # Model version
model_sku_name        = "GlobalStandard"  # SKU for deployment
model_capacity        = 10                # Token capacity
```

### Service SKUs

Adjust service tiers based on your needs:

```hcl
search_service_sku = "standard"  # Options: free, basic, standard, standard2, standard3
```

### Tags

Customize resource tags:

```hcl
tags = {
  Environment = "development"
  Project     = "ai-foundry"
  Owner       = "your-team"
  Purpose     = "ai-agents"
  ManagedBy   = "terraform"
}
```

## 🔒 Security Features

### Network Security
- **Private Endpoints**: All services isolated from public internet
- **Private DNS**: Custom DNS resolution for private connectivity
- **Network Isolation**: Resources deployed in existing VNet

### Identity & Access
- **Managed Identities**: No stored credentials required
- **RBAC**: Least privilege access control
- **Azure AD Integration**: Enterprise identity integration

### Data Protection
- **Encryption**: Data encrypted at rest and in transit
- **Key Vault**: Centralized secrets management
- **Access Logging**: Comprehensive audit trails

## 📊 Monitoring & Observability

The deployment includes Application Insights for monitoring:

- **Performance Metrics**: Track application performance
- **Error Logging**: Centralized error tracking
- **Custom Telemetry**: Application-specific metrics
- **Alerting**: Proactive issue detection

## 🛠️ Post-Deployment Tasks

### 1. Verify Connectivity

Test private endpoint connectivity from within your VNet:

```bash
# Test from a VM in your VNet
nslookup your-storage-account.blob.core.windows.net
nslookup your-search-service.search.windows.net
```

### 2. Configure Data Sources

- Upload training data to the storage account
- Create search indexes in Azure AI Search
- Set up databases in Cosmos DB

### 3. Deploy AI Applications

- Access AI Studio using the provided URL
- Create and deploy AI applications
- Configure agent services

## 🔧 Troubleshooting

### Common Issues

1. **Private DNS Resolution**
   - Ensure private DNS zones are linked to your VNet
   - Verify DNS zone resource IDs in terraform.tfvars

2. **RBAC Permissions**
   - Check that your account has Contributor access
   - Verify managed identity role assignments

3. **Model Deployment**
   - Ensure sufficient quota in your region
   - Check model availability in your subscription

### Validation Commands

```bash
# Check Terraform state
terraform state list

# Validate resources
terraform plan -detailed-exitcode

# View specific resource
terraform state show module.hub.azurerm_cognitive_account.ai_foundry_hub
```

## 🧹 Cleanup

To remove all deployed resources:

```bash
# Destroy infrastructure (careful - this deletes everything!)
terraform destroy
```

**Warning**: This will permanently delete all resources. Ensure you have backups of any important data.

## 📚 Additional Resources

### Azure Documentation
- [Azure AI Foundry](https://docs.microsoft.com/en-us/azure/ai-foundry/)
- [Azure AI Search](https://docs.microsoft.com/en-us/azure/search/)
- [Azure Cosmos DB](https://docs.microsoft.com/en-us/azure/cosmos-db/)
- [Private Endpoints](https://docs.microsoft.com/en-us/azure/private-link/)

### Terraform Resources
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## ⚠️ Important Security Notes

- **Never commit `terraform.tfvars`** - Contains sensitive values
- **Use managed identities** - Avoid storing credentials
- **Review RBAC assignments** - Ensure least privilege access
- **Monitor access logs** - Regular security audits
- **Keep dependencies updated** - Regular Terraform provider updates

## 📞 Support

For issues and questions:
1. Check the troubleshooting section above
2. Review Azure documentation
3. Open an issue in this repository
4. Contact your Azure support team for Azure-specific issues

---

**Built with ❤️ using Terraform and Azure AI Services**
