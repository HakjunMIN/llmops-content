# Git Workflow and Pipelines

이 페이지에서는 브랜치를 포함하여 이 가속기에서 사용하는 Git 워크플로우와 코드 변경으로 자동화 파이프라인을 트리거하는 방법에 대해 알아봅니다. 이 워크플로는 **dev**, **qa**, **prod**와 같은 여러 환경에서 Git을 효과적으로 관리하는 것으로 널리 알려진 [Git flow](https://nvie.com/posts/a-successful-git-branching-model) 방법론을 따릅니다. 하지만 프로젝트의 요구 사항에 가장 적합한 워크플로를 자유롭게 선택하세요.

# Git Workflow

아래 이미지는 프로젝트 리포지토리에서 사용되는 워크플로우를 나타냅니다. 이 워크플로우를 기반으로 새 기능의 배포가 어떻게 이루어지는지 살펴봅시다. 이 예에서는 프로젝트의 릴리스 1.0.0에서 제공될 “feature X”라는 새 기능을 개발하고 있습니다.

![GIt Workflow](../media/git_workflow_branching.png)

워크플로에 대한 자세한 설명은 다음과 같습니다:

1. **Feature Branch**

워크플로우는 개발팀이 'develop' 브랜치에서 'feature/feature_x'라는 이름의 기능 브랜치를 만들면서 시작됩니다. 이 브랜치에서 개발자는 새로운 기능 X를 개발합니다.

```bash
git checkout develop
git pull
git checkout -b feature/feature_x
```

2. **Pull Request (PR)**:

기능이 완료되면 기능 브랜치인 'feature/feature_x'에서 팀이 변경 사항을 통합하는 기본 브랜치인 'develop' 브랜치로 풀 리퀘스트(PR)가 시작됩니다.

PR이 생성되면 *PR 평가 파이프라인*이 트리거되어 코드가 표준을 준수하고 단위 테스트를 통과하는지, 오케스트레이션 흐름이 품질 메트릭을 충족하는지 확인하기 위해 AI에 의해 평가됩니다.

```bash
git add .
git commit -m "Feature complete: [Your Feature Description]"
git push origin feature/feature_x
# Use GitHub CLI or the GitHub website to create PR.
gh pr create --base develop --head feature/feature_x --title "[Your Feature Name]" --body "Description of the changes and the impact."
```

3. **Merge to develop**:

풀 리퀘스트가 승인되면 `개발` 브랜치에 병합됩니다. 이 병합은 *지속 통합(CI) 파이프라인*을 트리거하여 오케스트레이션 플로우를 구축하고 [골든 데이터 세트](https://aka.ms/copilot-golden-dataset-guide)에 기반한 포괄적인 테스트 데이터 세트를 사용하여 AI 지원 평가를 수행합니다. 성공적으로 완료되면 *지속 배포(CD) 파이프라인*이 실행되어 플로우를 **개발** 환경에 배포합니다.

4. **Release Branch (Release/1.0.0)**:

dev**에서 테스트를 통해 `develop` 브랜치의 안정성을 확인한 후, `develop`에서 릴리스 브랜치 `release/1.0.0`을 생성합니다. 이렇게 하면 *지속 배포(CD) 파이프라인*이 트리거되어 애플리케이션을 **qa** 환경에 배포합니다. 배포 전에 인공지능 기반 평가로 [품질](https://learn.microsoft.com/en-us/azure/ai-studio/how-to/develop/flow-evaluate-sdk), 위험 및 [안전성](https://learn.microsoft.com/en-us/azure/ai-studio/how-to/develop/simulator-interaction-data) 평가를 수행합니다. 그런 다음 **qa**의 애플리케이션은 사용자 승인 테스트(UAT) 및 [레드팀](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/red-teaming) 또는 LLM 앱에 사용됩니다.


```bash
git checkout develop
git pull origin develop
git checkout -b release/1.0.0
git push origin release/1.0.0
```

5. **Pull Request to main**:

**qa** 환경에서 UAT 테스트를 통해 애플리케이션이 프로덕션에 사용할 준비가 되었음을 확인한 후, 변경 사항을 `main` 브랜치에 병합하기 위한 풀 리퀘스트(PR)를 생성합니다.

```bash
# Use GitHub CLI or the GitHub website to create PR.
gh pr create --base main --head release/1.0.0 --title "Release 1.0.0" --body "Merging release/1.0.0 into main after successful UAT in QA environment" 
```

6. **Merge to main**:

`main` 브랜치에 대한 풀 리퀘스트(PR)가 수동으로 승인되면 릴리스 브랜치가 `main` 브랜치에 병합됩니다. 이 작업은 코드를 **prod** 환경에 배포하는 지속적 배포(CD) 파이프라인을 트리거합니다.

## CI/CD Pipelines

CI/CD(지속적 통합/지속 배포) 파이프라인은 통합, 평가 및 배포 프로세스를 자동화하여 고품질 애플리케이션의 효율적인 배포를 보장합니다.

![Pipelines](../media/git_workflow_pipelines.png)

**Pull Request 평가 파이프라인**은 단위 테스트와 코드 리뷰로 시작하여 통합 전에 코드 변경 사항을 검증하기 위한 AI 지원 Prompt 평가로 마무리됩니다.

**지속적 통합 파이프라인**에서는 단위 테스트와 코드 리뷰로 시작하여 AI 지원 흐름 평가를 통해 잠재적인 문제를 식별합니다. 그런 다음 애플리케이션이 빌드되고 배포를 위해 플로우 이미지가 등록됩니다.

**지속적 배포 파이프라인**은 dev, qa, prod의 세 가지 환경에서 작동합니다. 리소스 프로비저닝은 필요할 때 수행되며, 애플리케이션 배포는 각 환경에서 실행됩니다.

- **개발 환경**에서는 최신 코드를 가져와서 개발팀의 테스트를 위해 애플리케이션을 배포합니다.

- **QA 환경**에서는 코드를 검색하고 품질과 안전성에 대한 AI 지원 평가를 수행한 후 통합 테스트를 진행합니다. 그런 다음 애플리케이션을 배포하고 사용자 승인 테스트(UAT)에 사용할 수 있도록 합니다.

- **프로덕션 환경**에서는 지속적 통합 파이프라인에서 구축된 동일한 이미지가 배포되어 일관성과 안정성을 보장합니다. 통합 테스트가 수행되고 스모크 테스트를 통해 배포 후 기능을 보장합니다.

이러한 구조화된 접근 방식은 워크플로를 간소화하고 오류를 줄이며 애플리케이션을 프로덕션에 효율적으로 배포할 수 있도록 보장합니다.

