[![CD QA Pipeline](https://github.com/HakjunMIN/llmops-content/actions/workflows/continuous_delivery_qa.yml/badge.svg)](https://github.com/HakjunMIN/llmops-content/actions/workflows/continuous_delivery_qa.yml) [![CD Prod Pipeline](https://github.com/HakjunMIN/llmops-content/actions/workflows/continuous_delivery_prod.yml/badge.svg)](https://github.com/HakjunMIN/llmops-content/actions/workflows/continuous_delivery_prod.yml)

# Azure LLMOps Solution Accelerator

![Header](media/llmopsheader.png)

> [!Important]
> **특징**
> * Forked from https://github.com/Azure/llmops
> * Github 프로젝트 템플릿 방식에서 Fork 방식으로 단순화
> * 각 파이프라인 에서 인프라 프로비저닝 부문 분리
> * (교육 콘텐츠로 활용 시) 시 인프라 프로비저닝 낭비를 위해 `dev` 1개의 세트만 수행
> * PR/CI/CD (dev, qa, prod)의 LLMOps Flow는 그대로 실행될 수 있도록 유지
> * 기존 프로젝트에서의 여러 오류 수정
> * Korean Localization

LLMOps 솔루션 액셀러레이터에 오신 것을 환영합니다! 이 프로젝트는 바로 실행할 수 있는 LLMOps 솔루션을 제공하며, 주로 CI/CD 파이프라인 구현에 중점을 두고 있습니다. 여기에는 LLMOps 사례를 프로젝트에 원활하게 도입하는 데 도움이 되도록 설계된 필수 개념이 포함되어 있습니다.
 
## LLMOps Pipeline Overview

![llmops-pipeline](./media/git_workflow_pipelines.png)

## Highlights

- 1시간 이내에 프로젝트 부트스트랩
- 인프라스트럭처를 코드로 프로비저닝하여 리소스 프로비저닝
- 손쉬운 구성 및 템플릿 확장
- Azure AI Studio 활용

> [!Note]
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
## How-to

1. [Setting up a new Project](documentation/setup.md)
2. [Delivering a new Feature](documentation/delivering_new_feature.md)

## Documentation

이 문서 세트를 살펴보고 가속기를 원활하게 탐색하고 구현하세요. 이러한 리소스는 리포지토리 구조, Git 워크플로 및 참조 아키텍처를 명확히 설명하여 성공적인 실행을 위한 강력한 기반을 제공합니다.

1. [Repository Structure](documentation/repository_structure.md): 리포지토리 구조가 어떻게 구성되는지 설명합니다.
2. [Git Workflow and Pipelines](documentation/git_workflow.md): 가속기에서 사용되는 Git 워크플로와 CI/CD 파이프라인에 대해 설명합니다.
3. [Reference Architecture](documentation/reference_architecture.md): 이 가속기의 기반이 되는 레퍼런스 아키텍처입니다.
1. [RAG Project Template](https://github.com/azure/llmops-project-template): 바로 사용할 수 있는 RAG 프로젝트 템플릿을 제공합니다.
1. [LLM Project Roles](documentation/project_roles.md): LLM 프로젝트의 다양한 역할과 그 책임에 대해 자세히 설명합니다.

## Trademarks
이 프로젝트에는 프로젝트, 제품 또는 서비스에 대한 상표 또는 로고가 포함될 수 있습니다. Microsoft 상표 또는 로고의 승인된 사용은 다음 사항을 따라야 합니다. 
[Microsoft의 상표 및 브랜드 가이드라인](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
이 프로젝트의 수정된 버전에서 Microsoft 상표 또는 로고를 사용하여 혼동을 일으키거나 Microsoft의 후원을 암시해서는 안 됩니다.
타사 상표 또는 로고를 사용하는 경우 해당 타사의 정책의 적용을 받습니다.