# Authors Thomas Schwartz and Sree Ram
# For General Use only
# Environment Setup for Dev
# This is the rapid prototype we executed on Monday
# Fetch the application id, Tenant ID, Object ID and Secret for the service principal created.
# Dojo team provides the service principal that have owner access on your subscription.
# The service principal is used to create Various Access Control (IAM) roles on the resources.
# The service principal is used to create the private endpoints on the resources.
# The service principal is used to create the A-records in the Azure DNS zone created in Platform team subscription.


$AppID = "<YOUR_APP_ID>"
$TenantID = "<YOUR_TENANT_ID>"
$AdminObjectID = "<YOUR_OBJECT_ID>"

# This is the resource group and subscription where your project resources for development are created.
# Replace the resources that are created as part of Azure AI Foundry - Former AI Studio (AI Hub/AI Project) in the below variables.
$rg = "<RESOURCE_GROUP>"
$vnet = "<VNET_NAME>"
$subnet = "<SUBNET_NAME>"
$stg_rid = "/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP>/providers/Microsoft.Storage/storageAccounts/<STORAGE_ACCOUNT_NAME>"
$acr_rid = "/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP>/providers/Microsoft.ContainerRegistry/registries/<CONTAINER_REGISTRY_NAME>"
$akv_rid = "/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP>/providers/Microsoft.KeyVault/vaults/<KEY_VAULT_NAME>"
$amlws_rid = "/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP>/providers/Microsoft.MachineLearningServices/workspaces/<WORKSPACE_NAME>"
$aoai_rid = "/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP>/providers/Microsoft.CognitiveServices/accounts/<COGNITIVE_SERVICES_ACCOUNT_NAME>"




#Open Azure Portal, Open the cloud shell
#Login using Azure Service Principal credentials
#Point to the subscription as appropriate
az login --service-principal --username $AppID --password "<Secret>" --tenant $TenantID
az account set -s "<SUBSCRIPTION_ID>" # Set the subscription to the subscription where the resources are created

# Create Private Endpoint for Azure Blob Storage
az network private-endpoint create --resource-group $rg --connection-name "psc-abc-ai-blob" --name "pe-abc-ai-blob" --vnet-name $vnet --subnet $subnet--private-connection-resource-id $stg_rid --group-id blob

# Create DFS Private Endpoint for Storage Account
az network private-endpoint create --resource-group $rg --connection-name "psc-abc-ai-dfs" --name "pe-abc-ai-dfs" --vnet-name $vnet --subnet $subnet --private-connection-resource-id $stg_rid --group-id dfs

# Create Private Endpoint for Azure Container Registry
az network private-endpoint create --resource-group $rg --connection-name "psc-abc-ai-acr" --name "pe-abc-ai-acr" --vnet-name $vnet --subnet $subnet --private-connection-resource-id $acr_rid --group-id registry

# Create Private Endpoint for Azure Key Vault
az network private-endpoint create --resource-group $rg --connection-name "psc-abc-ai-akv" --name "pe-abc-ai-akv" --vnet-name $vnet --subnet $subnet --private-connection-resource-id $akv_rid --group-id vault

# Create Private Endpoint for Azure OpenAI
az network private-endpoint create --resource-group $rg --connection-name "psc-abc-ai-aoai" --name "pe-abc-ai-aoai" --vnet-name $vnet --subnet $subnet --private-connection-resource-id $aoai_rid --group-id account

# Create Private Endpoint for Azure AI Hub
az network private-endpoint create --resource-group $rg --connection-name "psc-abc-ai-aihub" --name "pe-abc-ai-aihub" --vnet-name $vnet --subnet $subnet --private-connection-resource-id $amlws_rid --group-id amlworkspace

# Fetch the Private IP Address of the Private Endpoint. Name of private end point is the same as the name you provided in the above commands
# Fetch the record set name from the DNS Configuration that would be under settings of the Private Endpoint
# Ensure you provide the prefix of the record set name as the record set name in the below command
# These are the resource group and subscription id of platform zone

# Create Following A Records in respective Azure Private DNS Zones

# A Record entries for AI Hub

# For privatelink.notebooks.azure.net
$resourceGroup="<Your RG>"
$dnsZoneName="privatelink.notebooks.azure.net"
$recordSetName="ml-abc-eastus2-{GUID}.eastus2"
$privateIpAddress="172.19.80.11"

az network dns record-set a add-record --resource-group $resourceGroup --zone-name $dnsZoneName --record-set-name $recordSetName --ipv4-address $privateIpAddress

# Four A Record entries for privatelink.api.azureml.ms
#
# first A Record entry
$resourceGroup="<Your RG>"
$dnsZoneName="privatelink.api.azureml.ms"
$recordSetName="{GUID}.workspace.eastus2"
$privateIpAddress="172.19.80.10"
az network dns record-set a add-record --resource-group $resourceGroup --zone-name $dnsZoneName --record-set-name $recordSetName --ipv4-address $privateIpAddress


# second A Record entry
$resourceGroup="<Your RG>"
$dnsZoneName="privatelink.api.azureml.ms"
$recordSetName="{GUID}.workspace.eastus2.cert"
$privateIpAddress="172.19.80.10"
az network dns record-set a add-record --resource-group $resourceGroup --zone-name $dnsZoneName --record-set-name $recordSetName --ipv4-address $privateIpAddress

# third A Record entry
$resourceGroup="<Your RG>"
$dnsZoneName="privatelink.api.azureml.ms"
$recordSetName="*.{GUID}.inference.eastus2"
$privateIpAddress="172.19.80.12"
az network dns record-set a add-record --resource-group $resourceGroup --zone-name $dnsZoneName --record-set-name $recordSetName --ipv4-address $privateIpAddress


# fourth A Record entry
$resourceGroup="<Your RG>"
$dnsZoneName="privatelink.api.azureml.ms"
$recordSetName="*.{GUID}.models.eastus2"
$privateIpAddress="172.19.80.13"
az network dns record-set a add-record --resource-group $resourceGroup --zone-name $dnsZoneName --record-set-name $recordSetName --ipv4-address $privateIpAddress

# A Record entries for Azure Blob Storage endpoint
$resourceGroup="<Your RG>"
$dnsZoneName="privatelink.blob.core.windows.net"
$recordSetName="abcstorageaidev"
$privateIpAddress="172.19.80.4"
az network dns record-set a add-record --resource-group $resourceGroup --zone-name $dnsZoneName --record-set-name $recordSetName --ipv4-address $privateIpAddress

# A Record entries for Azure Data Lake Storage endpoint
$resourceGroup="<Your RG>"
$dnsZoneName="privatelink.dfs.core.windows.net"
$recordSetName="abcstorageaidev"
$privateIpAddress="172.19.80.5"
az network dns record-set a add-record --resource-group $resourceGroup --zone-name $dnsZoneName --record-set-name $recordSetName --ipv4-address $privateIpAddress

# A Record entries for Azure OpenAI Account
$resourceGroup="<Your RG>"
$dnsZoneName="privatelink.openai.azure.com"
$recordSetName="abcopenaidev"
$privateIpAddress="172.19.80.9"
az network dns record-set a add-record --resource-group $resourceGroup --zone-name $dnsZoneName --record-set-name $recordSetName --ipv4-address $privateIpAddress

# A Record entry for Key Vault
$resourceGroup="<Your RG>"
$dnsZoneName="privatelink.vaultcore.azure.net"
$recordSetName="abckvaidev"
$privateIpAddress="172.19.80.8"
az network dns record-set a add-record --resource-group $resourceGroup --zone-name $dnsZoneName --record-set-name $recordSetName --ipv4-address $privateIpAddress


# A Record entry for the Azure Container Registry
$resourceGroup="<Your RG>"
$dnsZoneName="privatelink.azurecr.io"
$recordSetName="abccraidev"
$privateIpAddress="172.19.80.7"
az network dns record-set a add-record --resource-group $resourceGroup --zone-name $dnsZoneName --record-set-name $recordSetName --ipv4-address $privateIpAddress

# The final seto is to assign appopriate roles for the Azure Service
# The scope is the resource id of the resource where the role is assigned
# Fetch the Admin Object ID from the Azure Portal corresponding to the Group where the user belongs to
# Admin Object ID is the Object ID of group in Azure Entra

# Asssign roles to Storage Account
az role assignment create --assignee $AdminObjectID --role "Storage File Data Privileged Contributor" --scope "<STORAGE_ACCOUNT_RESOURCE_ID>"
az role assignment create --assignee $AdminObjectID --role "Storage Blob Data Contributor" --scope "<STORAGE_ACCOUNT_RESOURCE_ID>"
az role assignment create --assignee $AdminObjectID --role "Storage Table Data Contributor" --scope "<STORAGE_ACCOUNT_RESOURCE_ID>"

# Assign roles to the cebs admin for AI Hub

az role assignment create --assignee $AdminObjectID --role "Azure AI Developer" --scope "<AI_HUB_RESOURCE_ID>"
az role assignment create --assignee $AdminObjectID --role "Azure AI Developer" --scope "<AI_PROJECT_RESOURCE_ID>"

# Assign role to Azure OpenAI as needed
az role assignment create --assignee $AdminObjectID  --role "Cognitive Services OpenAI Contributor" --scope "<Azure OpenAI Resource ID>
