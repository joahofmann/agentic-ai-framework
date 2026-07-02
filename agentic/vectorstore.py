from langchain_chroma import Chroma

# ============================================================
# 3. CREATE VECTOR DATABASE
# ============================================================

def create_vectorstore(texts, embeddings):
    return Chroma.from_texts(texts, embeddings)
