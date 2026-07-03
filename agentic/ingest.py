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
