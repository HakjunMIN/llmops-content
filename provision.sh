#!/bin/bash

# ANSI color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 01. Setup and Preparation
echo -e "${YELLOW}01. Setup and Preparation.${NC}"


# Read the variables from the bootstrap.properties file
if [ -f ./bootstrap.properties ]; then
    source ./bootstrap.properties
else
    echo -e "${RED}bootstrap.properties does not exist.${NC}"
    exit 1
fi

if [ "$azd_dev_env_provision" = "true" ]; then

    # 03. Initializing AZD dev environment
    echo -e "${YELLOW}03. Initializing AZD dev environment.${NC}"

    rm -rf .azure    
    # Initialize the azd environment
    echo -e "${YELLOW}Running azd init.${NC}"
    azd init -e "$azd_dev_env_name" -s "$azd_dev_env_subscription" -l "$azd_dev_env_location"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to initialize the Azure Developer environment.${NC}"
        exit 1
    fi

    # 04. Check if user logged in to Azure is Service Principal or not
    azd_user_type=$(az account show --query user.type -o tsv)
    if [ "$azd_user_type" = "servicePrincipal" ]; then
        echo -e "${GREEN}User is a Service Principal. Setting AZURE_PRINCIPAL_TYPE to ServicePrincipal.${NC}"
        azd env set AZURE_PRINCIPAL_TYPE ServicePrincipal
    else
        echo -e "${GREEN}User is not a Service Principal. Setting AZURE_PRINCIPAL_TYPE to User.${NC}"
        azd env set AZURE_PRINCIPAL_TYPE User
    fi
    
    # 05. Disable App Service provisioning
    azd env set AZURE_DEPLOY_APP_SERVICE false

    # 06. Show azd environment variables
    echo -e "${YELLOW}05. Show azd environment variables.${NC}"
    azd env get-values
    
    # 07. Provision dev environment resources
    echo -e "${YELLOW}06. Provision dev environment resources.${NC}"
    echo -e "${YELLOW}Running azd provision.${NC}"
    azd provision

    # Check if azd provision succeeded
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to provision the Azure environment.${NC}"
        exit 1
    fi

    echo -e "${GREEN}Dev environment provisioned successfully.${NC}"
else
    echo -e "${YELLOW}AZD dev environment provisioning was not selected.${NC}"
fi