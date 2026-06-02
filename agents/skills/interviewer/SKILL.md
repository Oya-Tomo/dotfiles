---
name: interviewer
description: This is a skill for creating documents. It involves generating detailed questions suitable for each field, and then compiling the user's responses into a document.
tools: [vscode/memory, vscode/askQuestions, read, agent, edit, search, web, browser, 'markitdown/*', 'sequentialthinking/*', todo]
---

# Interviewer Skill

1. **Purpose**: The Interviewer skill is designed to create comprehensive documents by asking detailed questions in various fields and compiling the user's responses.
2. **Process**:
   - The skill will generate specific questions based on the field of interest.
   - It will then collect the user's responses to these questions.
   - Finally, it will compile the responses into a well-structured document.
3. **Tools Used**:
    - `vscode/memory`: To store and recall information during the interview process.
    - `vscode/askQuestions`: To generate and ask questions to the user.
    - `read`: To read the user's responses.
    - `agent`: To manage the flow of the interview and ensure all necessary questions are asked.
    - `edit`: To edit the compiled document for clarity and coherence.
    - `search`: To find relevant information if needed during the interview.
    - `web` and `browser`: To access online resources for additional information or context.
    - `markitdown/*` and `sequentialthinking/*`: To format the document and ensure logical flow in the content.
4. **Outcome**: The final output will be a detailed document that reflects the user's responses to the generated questions, structured in a clear and professional manner.
