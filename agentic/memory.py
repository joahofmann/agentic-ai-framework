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
