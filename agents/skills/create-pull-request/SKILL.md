---
name: create-pull-request
description: Validate, publish, and verify GitHub pull requests across repositories. Use when the user explicitly asks to create, open, publish, or prepare a draft or ready-for-review PR from local work.
---

# Create Pull Request

Create a PR only when the user requests one. Prepare a reviewable, evidence-backed change without merging it.

## Gather authoritative context

1. Read repository instructions, contribution docs, PR templates, and recent comparable PRs.
2. Determine the base branch from explicit direction and repository workflow. Do not hardcode `main` or `develop`.
3. Inspect the current branch, upstream, worktree, commits, and complete diff against the selected base.
4. Identify the linked issue from structured Development linkage, branch naming, commits, or user input. Read its current body and labels.
5. Verify that the current branch is a work branch and that the diff contains only intended changes.

Do not hide unrelated dirty-worktree state. Ensure every intended PR change is committed, but do not include unrelated files. Reuse an existing PR for the same head branch instead of opening a duplicate.

## Verify readiness

Confirm the branch is linked to its issue through GitHub Development when the repository uses issue-linked work. A Markdown reference alone is not a substitute for requested structured linkage.

Discover and run the repository's required formatting, lint, type, test, build, generated-file, documentation, and manual checks. Record the exact commands and results. If a relevant check cannot run, record the reason and resulting risk.

Review the full base-to-head diff for correctness, regression risk, scope, tests, documentation, secrets, generated artifacts, and accidental files. Fix straightforward in-scope failures and rerun affected checks. Stop for user direction when readiness requires a material scope expansion or a known current-change failure remains.

## Draft title and body

Match repository title and language conventions. Keep the title concise and useful in squash or merge history.

Follow the repository PR template when present. Otherwise include:

```markdown
## Motivation

<why the change is needed>

## Summary

- <important behavior or responsibility changed>

## Scope

- <included work>

## Out of Scope

- <explicit boundary or deferred work>

## Verification

- `<command>` — <result>

## Risks / Follow-up

- <residual risk, manual validation, or `None`>

## Issue Linkage

<closing or non-closing reference and why>
```

Use a closing keyword only when this PR fully completes the issue and should close it on merge. Use a non-closing reference for umbrella, design, tracking, or multi-PR issues. Carry accepted review risks into the body.

Choose draft versus ready status from the user's request and repository convention. Do not invent a universal default. Apply labels, reviewers, or milestones only when requested or established by repository convention.

## Publish and verify

Push the exact head branch with upstream tracking. Write the PR body to a temporary file and create the PR with explicit base and head arguments so multiline Markdown and branch selection are preserved.

After creation, read the PR back and verify:

- URL, title, body, base, head, and draft status.
- Requested labels, reviewers, and issue linkage.
- The remote head matches the intended local commit.
- GitHub checks are visible; distinguish passing, failing, pending, and unavailable checks.

Report the PR URL, base/head, checks run locally, remote check state, and residual risks. Do not merge unless the user separately asks.
