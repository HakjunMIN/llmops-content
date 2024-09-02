# Bootstrapping a New Project

이 섹션에서는 프로젝트 템플릿을 사용하여 새 프로젝트를 시작하는 방법을 배웁니다. 부트스트랩 프로세스는 GitHub에 새 프로젝트 리포지토리를 만들고 프로젝트 템플릿의 콘텐츠로 채웁니다. 또한 프로젝트의 개발 환경을 설정하여 프로젝트를 빠르고 효율적으로 시작하는 데 필요한 모든 것을 갖추도록 합니다.
## Prerequisites

* [Azure CLI (az)](https://aka.ms/install-az) - to manage Azure resources.
* [Azure Developer CLI (azd)](https://aka.ms/install-azd) - to manage Azure deployments.
* [GitHub CLI (gh)](https://cli.github.com/) - to create GitHub repo.
* [Git](https://git-scm.com/downloads) - to update repository contents.

You will also need:
* [Azure Subscription](https://azure.microsoft.com/free/) - sign up for a free account.
* [GitHub Account](https://github.com/signup) - sign up for a free account.
* [Access to Azure OpenAI](https://learn.microsoft.com/legal/cognitive-services/openai/limited-access) - submit a form to request access.
* Permissions to create a Service Principal (SP) in your Azure AD Tenant.
* Permissions to assign the Owner role to the SP within the subscription.

## Steps to Bootstrap a Project

1. 이 프로젝트를 Fork합니다.

2. `gh`을 이용하여 환경변수, Github Action설정을 합니다.

   ```bash
   cp bootstrap.properties.template bootstrap.properties
  
   ```

3. **Authenticate with Azure and GitHub**

   Log in to Azure CLI:

   ```sh
   az login
   ```

   Log in to Azure Developer CLI:

   ```sh
   azd auth login
   ```

   Log in to GitHub CLI:

   ```sh
   gh auth login
   ```


4. `bootstrap.properties` 파일 수정

   ```properties
   # GitHub Repo Creation Properties
   github_username="<username>"
   # github_use_ssh: true will use ssh, false will use https
   github_use_ssh="false"
   # project_visibility: public, private, internal
   github_new_repo_visibility="public" 

   # Dev Environment Provision Properties
   azd_dev_env_provision="true"
   azd_dev_env_name="<dev_env_name>"
   azd_dev_env_subscription="<subscription_id>"
   azd_dev_env_location="<location>"
   ```
단, prod, qa 환경을 별도로 구성한다면 각각 설정 필요

   * check quota

   > [!Note]
   > 리전은 AI 기반 Evaluator를 사용하기 위해 ["eastus2", "francecentral", "uksouth", "swedencentral"]
   > https://learn.microsoft.com/en-us/azure/ai-studio/how-to/develop/flow-evaluate-sdk#risk-and-safety-evaluators


   ```bash
   subscriptionId="replace by your subscription id" 
   region="swedencentral"
   results=$(az cognitiveservices usage list --subscription $subscriptionId --location $region) 
   echo $results | jq -r '.[] | select(.name.value | test("Standard.gpt-4"))'
   echo $results | jq -r '.[] | select(.name.value | test("OpenAI.Standard.text-embedding-ada-002"))'
   echo $results | jq -r '.[] | select(.name.value | test("Standard.gpt-35-turbo"))' 
   ```

5. **Service Principal생성**

   ```sh
   az ad sp create-for-rbac --name "<your-service-principal-name>" --role Owner --scopes /subscriptions/<your-subscription-id> --sdk-auth
   ```

   > 여기에서 생성한 출력 정보가 나중에 사용할 수 있도록 제대로 저장되었는지 확인합니다.

6. Github 설정

   ```bash
   ./bootstrap.sh
   ```

7. dev 환경 인프라 Provision

   ```bash
   ./provision.sh
   ```

8. **Set GitHub Environment Variables**

   리파지토리에서 아래 Variable 생성 확인 (`dev`, `qa`, and `prod` 별로 각각)

   - **Environment Variables:**
     - `AZURE_ENV_NAME`
     - `AZURE_LOCATION`
     - `AZURE_SUBSCRIPTION_ID`

   아래 secret 값은 **5**에서 생성한 값으로 직접 설정  
   
   - **Secret:**
     - `AZURE_CREDENTIALS`

   Variable와 secret을 만들고 나면 환경 페이지가 다음 예시와 비슷해집니다:
   
   ![Environments Page](../media/bootstrapping_environments.png)
   
   다음은 개발 환경에 대한 환경 변수 값의 예입니다:
   
   ![Environment Variables](../media/bootstrapping_env_vars.png)
   
   `AZURE_CREDENTIALS` secret 샘플
    
   ```json
   {
       "clientId": "your-client-id",
       "clientSecret": "your-client-secret",
       "subscriptionId": "your-subscription-id",
       "tenantId": "your-tenant-id"
   }
   ```

   > **Note:** 이 Solution Accelerator 를 실험하는 데만 관심이 있는 경우, 동일한 구독을 사용하되 각 환경에 대해 `AZURE_ENV_NAME`만 변경하면 됩니다.

7. **Enable GitHub Actions**

   조직 정책에 따라 이 기능이 기본적으로 활성화되어 있지 않을 수도 있으므로 리포지토리에서 GitHub 작업이 활성화되어 있는지 확인하세요. 이렇게 하려면 아래 그림에 표시된 버튼을 클릭하기만 하면 됩니다:

   ![Enable Actions](../media/enable_github_actions.png)

여기까지입니다! 이제 새 프로젝트가 부트스트랩되어 실행할 준비가 되었습니다.