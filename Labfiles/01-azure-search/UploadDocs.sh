#!/bin/bash

# Set values for your storage account
subscription_id="9f15d358-fb6e-4797-90dd-8e4550768d01"
azure_storage_account="flastorage102"
azure_storage_key="rs9ni3XfiKEQ+EAtDOpcXlvjlKsST87ZOXUTj6eskFlozEFhEFMP+xHzvptozHjZ1Gnp4G9PCgLd+AStukyDJQ=="

echo "Creating container..."
az storage container create --account-name "$azure_storage_account" --subscription "$subscription_id" --name margies --auth-mode key --account-key "$azure_storage_key" --output none

echo "Uploading files..."
az storage blob upload-batch -d margies -s data --account-name "$azure_storage_account" --auth-mode key --account-key "$azure_storage_key" --output none
