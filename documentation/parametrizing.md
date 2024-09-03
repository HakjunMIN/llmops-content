# Parametrizing Deployment with GitHub Environments

이 문서에서는 해당 GitHub 환경(dev, qa 또는 prod)에서 변수를 설정하여 배포를 매개변수화하는 방법을 설명합니다. 배포 템플릿에서 사용되는 변수는 아래에 설명과 함께 나열되어 있습니다.

모든 매개 변수는 `AZURE_ENV_NAME`, `AZURE_LOCATION` 및 `AZURE_SUBSCRIPTION_ID`를 제외한 모든 매개 변수는 선택 사항입니다. 서비스의 특정 이름을 정의하지 않으려는 경우 임의로 생성됩니다.

## Variables Table

| Variable Name                      | Description                                         | Default Value                                      |
|------------------------------------|-----------------------------------------------------|----------------------------------------------------|
| `AZURE_ENV_NAME`                   | The name of the Azure environment.                  | -                                                  |
| `AZURE_LOCATION`                   | The location of the Azure resources.                | -                                                  |
| `AZURE_SUBSCRIPTION_ID`            | The subscription ID for the Azure resources.        | -                                                  |
| `AZURE_RESOURCE_GROUP`             | The name of the resource group.                     | random                                             |
| `AZURE_PRINCIPAL_ID`               | The ID of the principal (Service Principal).        | identity of SP set in AZURE_CREDENTIALS secret     |
| `AZUREAI_HUB_NAME`                 | The name of the AI Hub.                             | random                                             |
| `AZUREAI_PROJECT_NAME`             | The name of the AI project.                         | random                                             |
| `AZURE_APP_INSIGHTS_NAME`          | The name of the Application Insights resource.      | random                                             |
| `AZURE_APP_SERVICE_NAME`           | The name of the App Service.                        | random                                             |
| `AZURE_APP_SERVICE_PLAN_NAME`      | The name of the App Service Plan.                   | random                                             |
| `AZURE_CONTAINER_REGISTRY_NAME`    | The name of the Container Registry.                 | random                                             |
| `AZURE_CONTAINER_REPOSITORY_NAME`  | The name of the Container Repository.               | random                                             |
| `AZURE_KEY_VAULT_NAME`             | The name of the Key Vault.                          | random                                             |
| `AZURE_LOG_ANALYTICS_NAME`         | The name of the Log Analytics workspace.            | random                                             |
| `AZURE_OPENAI_NAME`                | The name of the OpenAI resource.                    | random                                             |
| `AZURE_SEARCH_NAME`                | The name of the Search Service.                     | random                                             |
| `AZURE_STORAGE_ACCOUNT_NAME`       | The name of the Storage Account.                    | random                                             |
| `LOAD_AZURE_SEARCH_SAMPLE_DATA`   | The sample data for the Azure Search index.         | true                                               |
| `PROMPTFLOW_WORKER_NUM`            | The number of PromptFlow workers.                   | 1                                                  |
| `PROMPTFLOW_SERVING_ENGINE`        | The PromptFlow serving engine.                      | fastapi                                            |

## GitHub 환경에서 변수 설정하기

1. GitHub의 리포지토리로 이동합니다.
2. 2. **Setting** > **Environment**으로 이동합니다.
3. 3. 환경을 선택하거나 생성합니다(예: `dev`, `qa` 또는 `prod`).
4. 4. 위 표에 나열된 변수를 해당 값과 함께 추가합니다.

>[!NOTE]
>`bootstrap.sh` 스크립트를 실행하여 위 작업을 셋업할 수 있습니다. [setup.md](./setup.md)름 참고하세요.

GitHub 환경에서 이러한 변수를 설정하면 각 환경에 맞게 배포 매개변수를 올바르게 구성하여 원활하고 일관된 배포 프로세스를 진행할 수 있습니다.
