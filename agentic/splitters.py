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
