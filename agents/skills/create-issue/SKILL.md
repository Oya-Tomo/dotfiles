---
name: create-issue
description: Create or refine implementation-ready GitHub issues across repositories. Use when the user asks to open, rewrite, scope, split, or relate an issue, or to turn a request into a durable issue specification.
---

# Create Issue

Treat the issue body as the durable planning and specification surface. Adapt to the repository instead of imposing a fixed language, label set, title convention, or template.

## Establish context

1. Read repository instructions such as `AGENTS.md`, `CLAUDE.md`, `.rules`, contributing docs, and issue templates.
2. Inspect the relevant code and documentation before asking questions that the repository can answer.
3. Search open and recently closed issues for duplicates, superseded work, and related decisions.
4. Inspect available labels and recent issue style. Use only existing labels unless the user explicitly asks to create one.
5. Match the user's language unless repository instructions require another language.

If a close match exists, show the evidence and ask whether to update, reopen, relate, or create a distinct issue. Do not create a duplicate silently.

## Resolve only material ambiguity

Ask questions only when the answer would materially change scope, behavior, compatibility, acceptance criteria, or the issue hierarchy. Ask one question at a time and include a recommended answer. Skip clarification when the request and repository evidence are already sufficient or when the user explicitly wants a tracking issue created first.

Finish clarification when another developer can implement the issue without reconstructing the conversation.

## Draft the issue

Follow a repository template when one exists. Otherwise adapt this structure to the size of the work:

```markdown
## Background

<why this work is needed>

## Goal

<observable outcome>

## Scope

- <included work>

## Out of Scope

- <explicit boundary>

## Approach

<important constraints or agreed direction without over-specifying incidental details>

## Acceptance Criteria

- [ ] <measurable result>

## Validation

- <how completion will be verified>

## Related Work

- <issue, PR, ADR, or documentation links>
```

Keep small tracking issues small. Keep acceptance criteria about observable results rather than vague tasks such as "implement" or "test".

Infer a title and metadata from repository conventions. Present a draft before creation only when the user requests review or material ambiguity remains; otherwise execute the requested issue creation without redundant confirmation.

## Create and relate

Use a real multiline body file with `gh issue create --body-file`; avoid fragile shell-quoted multiline bodies. Use GitHub's formal parent/sub-issue relationship when work is independently completable under a tracking issue. Do not substitute a Markdown reference for a requested sub-issue relationship.

Use closing keywords only when completion of the linked work should close the issue. Use a non-closing reference for tracking, design, umbrella, or multi-PR issues.

After creation or editing, read the issue back from GitHub and verify its title, body, labels, URL, and requested relationships. Report the issue URL and any metadata or relationship that could not be applied.
