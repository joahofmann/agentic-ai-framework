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
