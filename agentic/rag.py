from langchain_core.prompts import ChatPromptTemplate
from .config import TOP_K

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
