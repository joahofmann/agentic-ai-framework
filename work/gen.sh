cat > ~/create-agentic-framework.sh <<'EOF'
#!/bin/bash
set -e

mkdir -p ~/agentic/agentic
cd ~/agentic/agentic

cat > __init__.py <<'PY'
"""
Agentic AI Framework

Reusable components for a local RAG agent running on:
- Kubeflow Notebook
- PyTorch GPU embeddings
- Chroma vector store
- LangChain
- Ollama via Kubernetes Service
"""
PY

cat > config.py <<'PY'
# ============================================================
# FRAMEWORK CONFIGURATION
# ============================================================

OLLAMA_BASE_URL = "http://ollama.kubeflow.svc.cluster.local:11434"
LLM_MODEL = "gemma2:latest"
EMBEDDING_MODEL = "sentence-transformers/all-MiniLM-L6-v2"
TEMPERATURE = 0
TOP_K = 4
PY

cat > device.py <<'PY'
import torch

# ============================================================
# 1. DETECT THE COMPUTING DEVICE
# ============================================================

def get_device():
    return "cuda" if torch.cuda.is_available() else "cpu"


def print_device_info():
    device = get_device()
    print(f"PyTorch is currently using: {device.upper()}")

    if torch.cuda.is_available():
        print(f"GPU name: {torch.cuda.get_device_name(0)}")

    return device
PY

cat > embeddings.py <<'PY'
from langchain_huggingface import HuggingFaceEmbeddings
from device import get_device
from config import EMBEDDING_MODEL

# ============================================================
# 2. CREATE EMBEDDINGS
# ============================================================

def create_embeddings(device=None):
    device = device or get_device()

    return HuggingFaceEmbeddings(
        model_name=EMBEDDING_MODEL,
        model_kwargs={"device": device},
        encode_kwargs={"normalize_embeddings": True},
    )
PY

cat > vectorstore.py <<'PY'
from langchain_chroma import Chroma

# ============================================================
# 3. CREATE VECTOR DATABASE
# ============================================================

def create_vectorstore(texts, embeddings):
    return Chroma.from_texts(texts, embeddings)
PY

cat > llm.py <<'PY'
from langchain_ollama import ChatOllama
from config import OLLAMA_BASE_URL, LLM_MODEL, TEMPERATURE

# ============================================================
# 4. CONNECT TO OLLAMA
# ============================================================

def create_llm():
    return ChatOllama(
        model=LLM_MODEL,
        temperature=TEMPERATURE,
        base_url=OLLAMA_BASE_URL,
    )
PY

cat > rag.py <<'PY'
from langchain_core.prompts import ChatPromptTemplate
from config import TOP_K

# ============================================================
# 5. RUN RAG QUESTION ANSWERING
# ============================================================

def ask_rag(question, vectorstore, llm, k=TOP_K):
    retriever = vectorstore.as_retriever(search_kwargs={"k": k})
    docs = retriever.invoke(question)

    context = "\n".join(doc.page_content for doc in docs)

    prompt_template = ChatPromptTemplate.from_template("""
Answer the question only using the supplied context.
If the answer is not contained in the context, reply only with:

I don't know.

Context:
{context}

Question:
{question}

Answer:
""")

    prompt = prompt_template.format(
        context=context,
        question=question,
    )

    answer = llm.invoke(prompt)

    return {
        "question": question,
        "context": context,
        "answer": answer.content,
    }
PY

cat > tools.py <<'PY'
# ============================================================
# AGENT TOOLS
# ============================================================
# Placeholder for future tools:
# - Kubernetes status tool
# - MLflow tool
# - File reader tool
# - Python execution tool
# ============================================================
PY

cat > agents.py <<'PY'
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
PY

cat > requirements.txt <<'REQ'
torch
langchain
langchain-core
langchain-ollama
langchain-huggingface
langchain-chroma
sentence-transformers
chromadb
REQ

echo
echo "Agentic framework created in ~/agentic"
echo
ls -1
EOF

chmod +x ~/create-agentic-framework.sh
~/create-agentic-framework.sh
