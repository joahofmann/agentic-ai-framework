cd ~/agentic-ai-framework

cat > extend-v020.sh <<'EOF'
#!/bin/bash
set -e

mkdir -p agentic

cat > agentic/loaders.py <<'PY'
from pathlib import Path
from langchain_community.document_loaders import (
    PyPDFLoader,
    TextLoader,
    DirectoryLoader,
)


def load_pdf(path: str):
    return PyPDFLoader(path).load()


def load_text(path: str):
    return TextLoader(path, encoding="utf-8").load()


def load_markdown(path: str):
    return TextLoader(path, encoding="utf-8").load()


def load_folder(path: str, glob: str = "**/*"):
    return DirectoryLoader(path, glob=glob, show_progress=True).load()


def load_path(path: str):
    p = Path(path)

    if p.is_dir():
        return load_folder(str(p))

    suffix = p.suffix.lower()

    if suffix == ".pdf":
        return load_pdf(str(p))

    if suffix in [".txt", ".md"]:
        return load_text(str(p))

    raise ValueError(f"Unsupported file type: {suffix}")
PY


cat > agentic/splitters.py <<'PY'
from langchain_text_splitters import RecursiveCharacterTextSplitter


def create_text_splitter(chunk_size: int = 1000, chunk_overlap: int = 150):
    return RecursiveCharacterTextSplitter(
        chunk_size=chunk_size,
        chunk_overlap=chunk_overlap,
    )


def split_documents(documents, chunk_size: int = 1000, chunk_overlap: int = 150):
    splitter = create_text_splitter(
        chunk_size=chunk_size,
        chunk_overlap=chunk_overlap,
    )

    return splitter.split_documents(documents)
PY


cat > agentic/memory.py <<'PY'
from langchain_chroma import Chroma


def create_persistent_chroma(
    embeddings,
    persist_directory: str = "./chroma_db",
    collection_name: str = "agentic_memory",
):
    return Chroma(
        collection_name=collection_name,
        embedding_function=embeddings,
        persist_directory=persist_directory,
    )


def load_persistent_chroma(
    embeddings,
    persist_directory: str = "./chroma_db",
    collection_name: str = "agentic_memory",
):
    return Chroma(
        collection_name=collection_name,
        embedding_function=embeddings,
        persist_directory=persist_directory,
    )
PY


cat > agentic/ingest.py <<'PY'
from .loaders import load_path
from .splitters import split_documents
from .memory import create_persistent_chroma


def ingest_path(
    path: str,
    embeddings,
    persist_directory: str = "./chroma_db",
    collection_name: str = "agentic_memory",
    chunk_size: int = 1000,
    chunk_overlap: int = 150,
):
    documents = load_path(path)

    chunks = split_documents(
        documents,
        chunk_size=chunk_size,
        chunk_overlap=chunk_overlap,
    )

    vectorstore = create_persistent_chroma(
        embeddings=embeddings,
        persist_directory=persist_directory,
        collection_name=collection_name,
    )

    vectorstore.add_documents(chunks)

    return {
        "documents_loaded": len(documents),
        "chunks_created": len(chunks),
        "persist_directory": persist_directory,
        "collection_name": collection_name,
    }
PY


echo
echo "v0.2.0 modules created:"
ls -1 agentic/loaders.py agentic/splitters.py agentic/ingest.py agentic/memory.py
EOF

chmod +x extend-v020.sh
./extend-v020.sh
