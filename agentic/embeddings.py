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
