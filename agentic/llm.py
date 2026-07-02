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
