# Connect to subscription
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID --output none
az account set --subscription $ARM_SUBSCRIPTION_ID

# Create core resource group if needed
if ( `az group exists --resource-group $CORE_RESOURCE_GROUP_NAME` == "true");
then
    echo "Core resource group $CORE_RESOURCE_GROUP_NAME already exists."
else
    echo "Creating core resource group $CORE_RESOURCE_GROUP_NAME."
    az group create -n $CORE_RESOURCE_GROUP_NAME -l $LOCATION
    echo "Resource group $CORE_RESOURCE_GROUP_NAME created."
fi

# Create core storage
if ( `az storage account check-name --name $CORE_STORAGE_ACCOUNT_NAME --query 'nameAvailable'` == "true" );
then
    echo "Creating $CORE_STORAGE_ACCOUNT_NAME storage account."
    az storage account create -g $CORE_RESOURCE_GROUP_NAME -l $LOCATION \
        --name $CORE_STORAGE_ACCOUNT_NAME \
        --sku Standard_LRS \
        --encryption-services blob \
        --allow-blob-public-acccess false \
        --default-action Allow
else
    echo "Core storage account $CORE_STORAGE_ACCOUNT_NAME already exists."
fi

# Create core keyvault if needed
if ( `az keyvault list --query "[?name == '$CORE_KEYVAULT_NAME'].name | [0] == '$CORE_KEYVAULT_NAME'"` == true );
then
    echo "Key vault $CORE_KEYVAULT_NAME already exists."
else
    echo "Creating $CORE_KEYVAULT_NAME key vault."
    az keyvault create -g $CORE_RESOURCE_GROUP_NAME -l $LOCATION --name $CORE_KEYVAULT_NAME
    echo "Key vault $CORE_KEYVAULT_NAME created."
fi

# Get storage account key
echo "Retrieving core storage account key."
ACCOUNT_KEY=$(az storage account keys list --resource-group $CORE_RESOURCE_GROUP_NAME --account-name $CORE_STORAGE_ACCOUNT_NAME --query [0].value -o tsv)
echo "Storage account key retrieved."

# Create container if needed
if ( `az storage container exists --name $TFM_STATE_CONTAINER_NAME --account-name $CORE_STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY --query exists` == "true" );
then
    echo "Storage container $TFM_STATE_CONTAINER_NAME already exists."
else
    echo "Creating storage container $TFM_STATE_CONTAINER_NAME."
    az storage container create --name $TFM_STATE_CONTAINER_NAME --account-name $CORE_STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY
    echo "Storage container created."
fi