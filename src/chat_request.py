from dotenv import load_dotenv
load_dotenv()

from sys import argv
import os
import pathlib
from ai_search import retrieve_documentation
from promptflow.tools.common import init_azure_openai_client
from promptflow.connections import AzureOpenAIConnection
from promptflow.core import (AzureOpenAIModelConfiguration, Prompty, tool)

def get_context(question, embedding):
    return retrieve_documentation(question=question, index_name="rag-index", embedding=embedding)

def get_embedding(question: str):
    connection = AzureOpenAIConnection(        
                    azure_deployment=os.getenv("AZURE_OPENAI_EMBEDDING_DEPLOYMENT", ""),
                    api_version="2023-05-15",
                    api_key=os.getenv("AZURE_OPENAI_API_KEY", ""),
                    api_base=os.getenv("AZURE_OPENAI_ENDPOINT", "")
                    )
                
    client = init_azure_openai_client(connection)

    embedding_response = client.embeddings.create(
        input=question,
        model=os.getenv("AZURE_OPENAI_EMBEDDING_MODEL", ""),
    )
    embedding = embedding_response.data[0].embedding
   
    return embedding

@tool
def get_response(question, chat_history):
    print("inputs:", question)
    embedding = get_embedding(question)
    context = get_context(question, embedding)

    print("context:", context)
    print("getting result...")

    configuration = AzureOpenAIModelConfiguration(
        azure_deployment=os.getenv("AZURE_OPENAI_CHAT_DEPLOYMENT", ""),
        api_version=os.getenv("AZURE_OPENAI_API_VERSION", ""),
        api_key=os.getenv("AZURE_OPENAI_API_KEY", ""),
        azure_endpoint=os.getenv("AZURE_OPENAI_ENDPOINT", "")
    )
    override_model = {
        "configuration": configuration,
        "parameters": {"max_tokens": 512}
    }
    
    data_path = os.path.join(pathlib.Path(__file__).parent.resolve(), "./chat.prompty")
    prompty_obj = Prompty.load(data_path, model=override_model)

    result = prompty_obj(question = question, documents = context)

    print("result: ", result)

    return {"answer": result, "context": context}

if __name__ == "__main__":
    get_response("What is the size of the moon?", [])