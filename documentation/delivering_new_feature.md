# Delivering a New Feature

프로젝트 셋업이 완료되면 팀은 새로운 기능 개발을 시작할 수 있습니다. 이 섹션에서는 초기 개발부터 프로덕션 배포에 이르는 모든 단계를 다루는 새 기능 제공에 대한 자세한 가이드를 제공합니다. 절차를 설명하기 위해 프로젝트의 릴리스 1.0.0에 포함될 “기능 X”라는 새 기능을 개발한다고 가정합니다. 프로세스는 다음 다이어그램에 표시된 6단계로 요약할 수 있으므로 쉽게 이해하고 따라할 수 있습니다.

![Git Workflow](../media/git_workflow_branching.png)

개발 시작부터 프로덕션 배포까지 이 기능을 제공하려면 아래 단계를 따르세요. 부트스트랩된 프로젝트 리포지토리, Git이 설치된 터미널(bash 또는 PowerShell), 리포지토리의 GitHub 페이지에 액세스할 수 있어야 합니다.

### Start Cloning Your Project

아래와 같은 명령을 사용하여 부트스트랩된 프로젝트 리포지토리를 복제합니다. 예제 리포지토리 이름을 부트스트랩 프로세스 중에 만든 실제 리포지토리로 바꿔야 합니다:

```bash
git clone git@github.com:your-username/your-repository.git
cd your-repository
```

If you prefer to clone the repository using HTTPS instead of SSH, you can use the following command:

```bash
git clone https://github.com/your-username/your-repository.git
cd your-repository
```

### 1. Creating a Feature Branch

워크플로우는 'develop' 브랜치에서 'feature/feature_x'라는 이름의 기능 브랜치를 만드는 것으로 시작됩니다. 여기서 개발팀은 새 기능 X를 작업하게 됩니다.

**Switch to the `develop` branch and pull the latest changes:**

```bash
git checkout develop
git pull
```

**Create the feature branch:**

```bash
git checkout -b feature/feature_x
```

**리포지토리를 변경합니다. 예를 들어 프로젝트 루트에 `FEATUREX.md` 파일을 만듭니다:**

*Using Bash:*

```bash
touch FEATUREX.md
```

*Using PowerShell:*

```powershell
New-Item -ItemType File -Name "FEATUREX.md"
```

이렇게 하면 프로젝트의 'develop' 브랜치와 Orompt Flow 의 무결성을 유지하면서 새 기능을 독립적으로 개발할 수 있습니다.

### 2. Pull Request (PR) to `develop`

기능이 완료되면 풀 리퀘스트(PR)를 생성하여 기능 브랜치 'feature/feature_x'의 변경 사항을 팀이 변경 사항을 통합하는 기본 브랜치인 `develop` 브랜치에 병합합니다.

**Add changes, commit, and push to the feature branch:**

```bash
git add .
git commit -m "Feature X complete"
git push origin feature/feature_x
```

**Create the PR:**

```bash
gh pr create --base develop --head feature/feature_x --title "Feature X" --body "Description of the changes and the impact."
```

GitHub 웹사이트를 사용하여 풀 리퀘스트를 생성할 수도 있습니다. 기본 브랜치로 `develop`을 선택하고 비교 브랜치로 `feature/feature_x`를 선택해야 한다는 점을 잊지 마세요.

PR을 생성하면 PR 평가 파이프라인이 트리거되어 코드가 표준을 준수하고 단위 테스트를 통과하는지, 오케스트레이션 흐름이 품질 메트릭을 충족하는지 확인하기 위해 AI에 의해 평가됩니다.

### 3. Merge to `develop`

풀 리퀘스트를 승인하여 `develop` 브랜치에 병합합니다. 이 병합은 지속적 통합(CI) 파이프라인을 트리거하여 오케스트레이션 플로우를 구축하고 [골든 데이터 세트](https://aka.ms/copilot-golden-dataset-guide)에 기반한 포괄적인 테스트 데이터 세트를 사용하여 AI 지원 평가를 수행합니다. 성공적으로 완료되면 지속적 배포(CD) 파이프라인이 실행되어 플로우를 **dev** 환경에 배포합니다.

**Merge the PR using GitHub:**

리포지토리의 풀 리퀘스트 탭으로 이동하여 최근에 만든 PR을 선택한 다음 **Merge pull request**을 클릭합니다.

### 4. Release Branch (`release/1.0.0`)

dev**에서 테스트를 통해 `develop` 브랜치의 안정성을 확인한 후 `develop`에서 릴리스 브랜치 `release/1.0.0`을 생성합니다. 이렇게 하면 *지속 배포(CD) 파이프라인*이 트리거되어 애플리케이션을 **qa** 환경에 배포합니다. 배포 전에 인공지능 기반 평가로 [품질](https://learn.microsoft.com/en-us/azure/ai-studio/how-to/develop/flow-evaluate-sdk), 위험 및 [안전성](https://learn.microsoft.com/en-us/azure/ai-studio/how-to/develop/simulator-interaction-data) 평가를 수행합니다. 그런 다음 **qa**의 애플리케이션은 사용자 승인 테스트(UAT) 및 [레드팀](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/red-teaming) 또는 LLM 앱에 사용됩니다.

**Create the release branch:**

```bash
git checkout develop
git pull origin develop
git checkout -b release/1.0.0
git push origin release/1.0.0
```

### 5. Pull Request to `main`

**qa** 환경에서 UAT 테스트를 통해 애플리케이션이 프로덕션에 사용할 준비가 되었음을 확인한 후, 풀 리퀘스트(PR)를 생성하여 변경 사항을 `release/1.0.0` 브랜치에서 `main` 브랜치로 병합합니다.

**Create the PR:**

아래는 GitHub CLI를 활용한 예제입니다:

```bash
gh pr create --base main --head release/1.0.0 --title "Release 1.0.0" --body "Merging release/1.0.0 into main after successful UAT in QA environment"
```

GitHub 웹사이트를 사용하여 풀 리퀘스트를 생성할 수도 있습니다. 기본 브랜치는 `main`으로, 비교 브랜치는 `release/1.0.0`으로 선택해야 합니다.

### 6. Merge to `main`

`main` 브랜치에 대한 풀 리퀘스트(PR)가 GitHub에서 승인되면 GitHub의 프로젝트 리포지토리의 풀 리퀘스트 탭으로 이동하여 프로덕션으로 병합하기 위해 생성한 PR을 선택한 다음 **Merge pull request**를 클릭하여 `release/1.0.0`을 `main` 브랜치로 수동으로 병합을 승인하세요. 이 작업은 코드를 **prod** 환경에 배포하는 지속적 배포(CD) 파이프라인을 트리거합니다.

## 웹 앱 테스트 방법

API이므로 아래와 같이 테스트할 수 있습니다.
```bash
curl https://<your-app>.azurewebsites.net/score --data '{"question":"What is the size of the moon?", "chat_history":[]}' -X POST -H "Content-Type: application/json"  -v
```