from device import print_device_info
from embeddings import create_embeddings
from vectorstore import create_vectorstore
from llm import create_llm
from rag import ask_rag

# ============================================================
# COMPLETE DEMO AGENT
# ============================================================

def run_demo_agent():
    device = print_device_info()

    facts = [
        """
        The current system is a stable MLOps stack.
        It runs on WSL2 with MicroK8s and Charmed Kubeflow 1.10.
        MLflow is integrated.
        GPU acceleration works in notebooks.
        GPU acceleration works in pipeline pods via Kyverno.
        Ollama runs inside Ubuntu and is reachable through a Kubernetes Service.
        """
    ]

    embeddings = create_embeddings(device)
    vectorstore = create_vectorstore(facts, embeddings)
    llm = create_llm()

    result = ask_rag(
        question="What does the stable MLOps stack run on?",
        vectorstore=vectorstore,
        llm=llm,
    )

    print("\nQuestion:")
    print(result["question"])

    print("\nRetrieved Context:")
    print(result["context"])

    print("\nAnswer:")
    print(result["answer"])

    return result
