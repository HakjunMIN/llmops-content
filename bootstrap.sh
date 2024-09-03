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

remote_url=$(git remote get-url origin)
organization=$(echo "$remote_url" | awk -F'[:/]' '{print $(NF-1)}')
repo_name=$(basename -s .git "$remote_url")

github_new_repo=${organization}/${repo_name}

if [ "$github_use_ssh" = "true" ]; then
    github_new_repo_uri="git@github.com:${github_new_repo}.git"
else
    github_new_repo_uri="https://github.com/${github_new_repo}.git"
fi
github_new_repo_name=${github_new_repo##*/}

echo -e "\e[33mBootstraping Parameters\e[0m"
echo -e "\e[36mGitHub Username:\e[0m $github_username"
echo -e "\e[36mGitHub Use SSH:\e[0m $github_use_ssh"
echo -e "\e[36mGitHub New Repo:\e[0m $github_new_repo"
echo -e "\e[36mGitHub New Repo name:\e[0m $github_new_repo_name"
echo -e "\e[36mGitHub New Repo URI:\e[0m $github_new_repo_uri"
echo -e "\e[36mGitHub New Repo Visibility:\e[0m $github_new_repo_visibility"
echo -e "\e[36mAZD Dev Environment Provision:\e[0m $azd_dev_env_provision"
echo -e "\e[36mAZD Dev Environment Name:\e[0m $azd_dev_env_name"
echo -e "\e[36mAZD Dev Environment Subscription:\e[0m $azd_dev_env_subscription"
echo -e "\e[36mAZD Dev Environment Location:\e[0m $azd_dev_env_location"

# 02. Repository Creation and Initialization
echo -e "${YELLOW}02. New GitHub Repository Creation and Initialization.${NC}"

# Remove the existing local folder if it exists
if [ -d "$new_project_repo" ]; then
    rm -rf "$new_project_repo"
fi

# Check if the repository already exists
repo_exists=$(gh repo view "$github_new_repo" > /dev/null 2>&1; echo $?)

if [ $repo_exists -ne 0 ]; then
    # Create a new GitHub repository
    echo -e "${YELLOW}Creating a new GitHub repository.${NC}"
    gh repo create "$github_new_repo" --$github_new_repo_visibility
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to create new GitHub repository.${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}New GitHub repository already exists.${NC}"
fi

# Mirror-push to the new repository
git push --mirror "$github_new_repo_uri"
if [[ $? -ne 0 ]]; then
  if [[ "$github_use_ssh" == "true" ]]; then
    echo "ERROR: Permission denied to GitHub repo. github_use_ssh is true. Please look at this reference:"
    echo "https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories#cloning-with-https-urls"
  else
    echo "ERROR: Permission denied to GitHub repo. github_use_ssh is false, you are using HTTPS. Please look at this reference:"
    echo "https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories#cloning-with-ssh-urls"    
  fi
  exit 1
fi

# Setting default branch
# echo -e "${YELLOW}Setting default branch in the new repository.${NC}"
# gh repo edit $github_new_repo --default-branch develop

# develop branch protection rule
gh api \
  --method PUT \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  repos/$github_new_repo/branches/develop/protection \
  -F "required_status_checks[strict]=true" \
  -F "required_status_checks[contexts][]=evaluate-flow" \
  -F "enforce_admins=true" \
  -F "required_pull_request_reviews[dismiss_stale_reviews]=false" \
  -F "required_pull_request_reviews[require_code_owner_reviews]=false" \
  -F "required_pull_request_reviews[required_approving_review_count]=0" \
  -F "required_pull_request_reviews[require_last_push_approval]=false" \
  -F "required_linear_history=true" \
  -F "allow_force_pushes=true" \
  -F "allow_deletions=true" \
  -F "block_creations=true" \
  -F "required_conversation_resolution=true" \
  -F "lock_branch=false" \
  -F "allow_fork_syncing=true" \
  -F "restrictions=null"

# Create GitHub environment named dev with specified variables
gh api --method PUT -H "Accept: application/vnd.github+json" repos/$github_new_repo/environments/dev
gh api --method POST -H "Accept: application/vnd.github+json" repos/$github_new_repo/environments/dev/variables -f name=AZURE_ENV_NAME -f value="$azd_dev_env_name"
gh api --method POST -H "Accept: application/vnd.github+json" repos/$github_new_repo/environments/dev/variables -f name=AZURE_SUBSCRIPTION_ID -f value="$azd_dev_env_subscription"
gh api --method POST -H "Accept: application/vnd.github+json" repos/$github_new_repo/environments/dev/variables -f name=AZURE_LOCATION -f value="$azd_dev_env_location"
gh secret set AZURE_CREDENTIALS --repo $github_new_repo --env dev --body "replace_with_dev_sp_credencials"

# Create placeholders for GitHub environment qa variables
gh api --method PUT -H "Accept: application/vnd.github+json" repos/$github_new_repo/environments/qa
gh api --method POST -H "Accept: application/vnd.github+json" repos/$github_new_repo/environments/qa/variables -f name=AZURE_ENV_NAME -f value="$azd_qa_env_name"
gh api --method POST -H "Accept: application/vnd.github+json" repos/$github_new_repo/environments/qa/variables -f name=AZURE_SUBSCRIPTION_ID -f value="$azd_qa_env_subscription"
gh api --method POST -H "Accept: application/vnd.github+json" repos/$github_new_repo/environments/qa/variables -f name=AZURE_LOCATION -f value="$azd_qa_env_location"
gh secret set AZURE_CREDENTIALS --repo $github_new_repo --env qa --body "replace_with_qa_sp_credencials"

# Create placeholders for GitHub environment prod variables
gh api --method PUT -H "Accept: application/vnd.github+json" repos/$github_new_repo/environments/prod
gh api --method POST -H "Accept: application/vnd.github+json" repos/$github_new_repo/environments/prod/variables -f name=AZURE_ENV_NAME -f value="$azd_prod_env_name"
gh api --method POST -H "Accept: application/vnd.github+json" repos/$github_new_repo/environments/prod/variables -f name=AZURE_SUBSCRIPTION_ID -f value="$azd_prod_env_subscription"
gh api --method POST -H "Accept: application/vnd.github+json" repos/$github_new_repo/environments/prod/variables -f name=AZURE_LOCATION -f value="$azd_prod_env_location"
gh secret set AZURE_CREDENTIALS --repo $github_new_repo --env prod --body "replace_with_prod_sp_credencials"

echo -e "${GREEN}New repository created successfully.${NC}"

echo -e "${GREEN}Access your new repo in: \nhttps://github.com/$github_new_repo ${NC}"
