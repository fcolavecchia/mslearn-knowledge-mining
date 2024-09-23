#!/bin/bash

# Set values for your subscription and resource group
subscription_id="9f15d358-fb6e-4797-90dd-8e4550768d01"
resource_group="Ingeniería_AI"
location="eastus"

# Get random numbers to create unique resource names
unique_id=$RANDOM

echo "Creating storage..."
az storage account create --name "ai102str$unique_id" --subscription "$subscription_id" --resource-group "$resource_group" --location "$location" --sku Standard_LRS --encryption-services blob --default-action Allow --allow-blob-public-access true --output none

echo "Uploading files..."
# Get storage key (hack)
key_json=$(az storage account keys list --subscription "$subscription_id" --resource-group "$resource_group" --account-name "ai102str$unique_id" --query "[?keyName=='key1'].{keyName:keyName, permissions:permissions, value:value}" -o tsv)
AZURE_STORAGE_KEY=$(echo "$key_json" | awk '{print $3}')

# Create container and upload files
az storage container create --account-name "ai102str$unique_id" --name margies --public-access blob --auth-mode key --account-key "$AZURE_STORAGE_KEY" --output none
az storage blob upload-batch -d margies -s data --account-name "ai102str$unique_id" --auth-mode key --account-key "$AZURE_STORAGE_KEY" --output none

echo "Creating Azure AI services account..."
az cognitiveservices account create --kind CognitiveServices --location "$location" --name "ai102cog$unique_id" --sku S0 --subscription "$subscription_id" --resource-group "$resource_group" --yes --output none

echo "Creating search service..."
echo "(If this gets stuck at '- Running ..' for more than a minute, press CTRL+C then select N)"
az search service create --name "ai102srch$unique_id" --subscription "$subscription_id" --resource-group "$resource_group" --location "$location" --sku basic --output none

echo "-------------------------------------"
echo "Storage account: ai102str$unique_id"
az storage account show-connection-string --subscription "$subscription_id" --resource-group "$resource_group" --name "ai102str$unique_id"

echo "----"
echo "Azure AI Services account: ai102cog$unique_id"
az cognitiveservices account keys list --subscription "$subscription_id" --resource-group "$resource_group" --name "ai102cog$unique_id"

echo "----"
echo "Search Service: ai102srch"
echo "Url: https://ai102srch$unique_id.search.windows.net"
echo "Admin Keys:"
az search admin-key show --subscription "$subscription_id" --resource-group "$resource_group" --service-name "ai102srch$unique_id"

echo "Query Keys:"
az search query-key list --subscription "$subscription_id" --resource-group "$resource_group" --service-name "ai102srch$unique_id"
