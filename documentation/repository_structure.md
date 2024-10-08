# Repository Structure

이 액셀러레이터는 프로젝트 템플릿을 기본으로 활용합니다. 따라서 리포지토리 시스템은 이러한 템플릿을 사용하여 프로젝트를 시작하기 위한 포괄적인 문서와 부트스트랩 스크립트가 포함된 기본 리포지토리를 포함하도록 구성되어 있습니다. 각 리포지토리 내에서 단순성을 유지하고 일관성을 유지하기 위해 각 프로젝트 템플릿에 대해 별도의 리포지토리가 할당됩니다. 또한 기본 리포지토리와 템플릿 리포지토리 간의 종속성이 최소화됩니다. 아래 다이어그램은 제안된 구조를 보여줍니다.

![Header](../media/git_workflow_repository_structure.png)

## Repositories and their Directories

이 섹션에서는 LLMOps 액셀러레이터에서 사용되는 디렉터리 구조를 설명합니다. 이 디렉터리 구조를 따르면 팀은 LLM 프로젝트를 개발하고 관리하는 데 있어 일관되고 체계적인 접근 방식을 보장할 수 있습니다.

### 리파지토리 구조

리파지토리 구조는 필요에 따라 다를 수 있지만, 다음과 같은 하위 디렉터리가 포함됩니다:

- **.github**: 지속적인 통합 및 배포에 사용되는 GitHub 전용 워크플로 및 작업.
- **data**: 이 디렉토리는 교육 및 평가에 필요한 데이터 세트를 저장하는 데 사용됩니다.
- **evaluations**: 학습된 모델의 성능을 평가하기 위한 스크립트와 리소스를 유지합니다.
- **infra**: Bicep 또는 Terraform 스크립트와 같은 인프라 관련 코드 및 구성을 보관합니다.
- **src**: 오케스트레이션 흐름, 모델 정의, 교육 스크립트 및 유틸리티를 포함한 프로젝트의 소스 코드입니다.
- **tests**: 코드베이스의 품질과 정확성을 보장하기 위한 테스트 케이스와 스크립트가 포함되어 있습니다.
