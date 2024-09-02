# Azure LLMOps Solution Accelerator

![Header](media/llmopsheader.png)

> ![Important]
> **특징**
> * Forked from https://github.com/Azure/llmops
> * Github 프로젝트 템플릿 방식에서 Fork 방식으로 단순화
> * 각 파이프라인 에서 인프라 프로비저닝 부문 분리
> * (교육 콘텐츠로 활용 시) 시 인프라 프로비저닝 낭비를 위해 `dev` 1개의 세트만 수행
> * PR/CI/CD (dev, qa, prod)의 LLMOps Flow는 그대로 실행될 수 있도록 유지
> * 여러 오류 수정
> * Korean Localization

LLMOps 솔루션 액셀러레이터에 오신 것을 환영합니다! 이 프로젝트는 바로 실행할 수 있는 LLMOps 솔루션을 제공하며, 주로 CI/CD 파이프라인 구현에 중점을 두고 있습니다. 여기에는 LLMOps 사례를 프로젝트에 원활하게 도입하는 데 도움이 되도록 설계된 필수 개념이 포함되어 있습니다.
 
## LLMOps Pipeline Overview

![llmops-pipeline](./media/git_workflow_pipelines.png)

## Highlights

- 1시간 이내에 프로젝트 부트스트랩
- 인프라스트럭처를 코드로 프로비저닝하여 리소스 프로비저닝
- 손쉬운 구성 및 템플릿 확장
- Azure AI Studio 활용

> ![Note]
> AI Evaluation 리전 선택 ("eastus2", "francecentral", "uksouth", "swedencentral")
> 해당 리전에 쿼터가 남아있는지 반드시 확인 후 리전 선택 [쿼터확인](documentation/check_your_quota.md)

## Quick start

    ```bash

    cp ./bootstrap.properties.template ./bootstrap.properties

    # modify bootstrap.properties

    az login
    azd auth login
    gh auth login

    # GitHub설정
    ./bootstrap.sh 

    # 인프라 프로비전
    ./provision.sh
    ```

### Service Principal 생성


   ```sh
   az ad sp create-for-rbac --name "<your-service-principal-name>" --role Owner --scopes /subscriptions/<your-subscription-id>

   {
    "clientId": "your-client-id",
    "clientSecret": "your-client-secret",
    "subscriptionId": "your-subscription-id",
    "tenantId": "your-tenant-id",
    "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
    "resourceManagerEndpointUrl": "https://management.azure.com/",
    "activeDirectoryGraphResourceId": "https://graph.windows.net/",
    "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
    "galleryEndpointUrl": "https://gallery.azure.com/",
    "managementEndpointUrl": "https://management.core.windows.net/"
    }
   
   ```

### Set GitHub Environment Variables

    새로 만든 프로젝트 리포지토리로 이동하여 세 가지 환경에 대해 다음 GitHub 환경 변수가 설정되어 있는지 확인합니다. `dev`, `qa`, and `prod`.
    
    - **Environment Variables:**
     - `AZURE_ENV_NAME`
     - `AZURE_LOCATION`
     - `AZURE_SUBSCRIPTION_ID`
   
    Service Principal 생성 후 출력된 credential 정보를 각 환경별 `secret`에 설정합니다.

    - **Secret:**
     - `AZURE_CREDENTIALS`


## Documentation

이 문서 세트를 살펴보고 가속기를 원활하게 탐색하고 구현하세요. 이러한 리소스는 리포지토리 구조, Git 워크플로 및 참조 아키텍처를 명확히 설명하여 성공적인 실행을 위한 강력한 기반을 제공합니다.

1. [Repository Structure](documentation/repository_structure.md): 리포지토리 구조가 어떻게 구성되는지 설명합니다.
2. [Git Workflow and Pipelines](documentation/git_workflow.md): 가속기에서 사용되는 Git 워크플로와 CI/CD 파이프라인에 대해 설명합니다.
3. [Reference Architecture](documentation/reference_architecture.md): 이 가속기의 기반이 되는 레퍼런스 아키텍처입니다.
1. [RAG Project Template](https://github.com/azure/llmops-project-template): 바로 사용할 수 있는 RAG 프로젝트 템플릿을 제공합니다.
1. [LLM Project Roles](documentation/project_roles.md): LLM 프로젝트의 다양한 역할과 그 책임에 대해 자세히 설명합니다.

## How-to

1. [Setting up a new Project](documentation/setup.md)
2. [Delivering a new Feature](documentation/delivering_new_feature.md)

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft 
trademarks or logos is subject to and must follow 
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.
