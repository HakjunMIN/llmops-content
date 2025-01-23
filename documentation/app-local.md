# Application 구조
 
## 개요

* `src`에 있는 앱은 달의 정보를 가지고 LLM기반으로 대답하는 RAG앱이며 Promptflow로 만들어짐.

## 로컬 테스트

리소스 프로비저닝이 완료된 후 pf를 통해 구동

1. 환경변수 설정

```sh
eval $(azd env get-values -e llmops-dev | awk '{print "export " $0}')
```

2. 패키지 설치 및 인덱스 생성

```sh
pip install -r requirements.txt
python data/sample-documents-indexing.py
```

>[!Note]
>인덱스는 rag-index로 하드코딩

3. 프롬프르 플로우 Serv구동

```sh
pf flow serve --source src
```

## 로컬 evaluation

1. PR 시 수행하는 간단한 Groundness점검

```sh
export AZURE_OPENAI_API_KEY=$(az cognitiveservices account keys list --resource-group ${AZURE_RESOURCE_GROUP} --name ${AZURE_OPENAI_NAME} --query "key1" --output tsv)

python evaluations/prompty_eval.py
```

* 직접 Groundness 평가를 수행하기 위해 직접 evaluation용 [prompty](../evaluations/prompty-answer-score-eval.prompty)를 만듬   

```yaml
    system:
    You are an AI assistant. 
    Your task is to evaluate a score for the answer based on the ground_truth and original question.
    This score value should always be an integer between 1 and 5. So the score produced should be 1 or 2 or 3 or 4 or 5.
    The output should be valid JSON.

    **Example**
    question: "What is the capital of France?"
    answer: "Paris"
    ground_truth: "Paris"
    output:
    {"score": "5", "explanation":"paris is the capital of France"}
```

2. QA 시 수행하는 평가는 [Azure Evaluation SDK](https://learn.microsoft.com/en-us/azure/ai-studio/how-to/develop/evaluate-sdk)의 빌트인 Evaluator를 사용하여 전문적인 평가를 수행함.

```sh
python evaluations/qa_quality_eval.py
```

* 각 Evaluator가 사용할 LLM모델을 정의한 후 `evaluate`를 수행함. 수행 결과는 Azure AI Project > Evaluation에서 수집/관리됨.
```python

    fluency_evaluator = FluencyEvaluator(model_config=model_config)
    groundedness_evaluator = GroundednessEvaluator(model_config=model_config)
    relevance_evaluator = RelevanceEvaluator(model_config=model_config)
    coherence_evaluator = CoherenceEvaluator(model_config=model_config)

    try:
        evaluate(
            evaluation_name=f"{prefix} Quality Evaluation",
            data=data,
            evaluators={
                "Fluency": fluency_evaluator,
                "Groundedness": groundedness_evaluator,
                "Relevance": relevance_evaluator,
                "Coherence": coherence_evaluator
            },
            azure_ai_project=azure_ai_project,
            output_path="./qa_flow_quality_eval.json"
        )
```
