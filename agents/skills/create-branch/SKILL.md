---
name: create-branch
description: Create or resume issue-linked GitHub development branches across repositories. Use when starting work from an issue, choosing a branch base and name, checking existing issue branches, or ensuring GitHub Development linkage.
---

# Create Branch

Create one clear working branch for the issue and preserve GitHub's structured Development linkage.

## Discover conventions

1. Read repository instructions and contributing documentation.
2. Determine the integration base from explicit user direction, documented workflow, recent comparable PRs, and remote branch configuration. Do not assume `main`, `master`, or `develop` universally.
3. Derive the branch naming convention from repository instructions and recent branches. Prefer `<type>/<issue-number>-<short-slug>` only when it matches the repository.
4. Read the issue title, body, and labels before inferring the branch purpose or type.

If the sources conflict or no safe base can be determined, ask the user before creating the branch.

## Protect existing work

Inspect `git status --short --branch` before switching branches. Preserve unrelated or pre-existing changes. Do not stash, discard, overwrite, or fold them into the new work without explicit approval.

Check all likely prior work before creating anything:

- GitHub Development branches linked to the issue.
- Local and remote branches containing the issue number or matching purpose.
- Existing pull requests for those branch names.

Resume an existing branch when it represents the same work. If several candidates exist or an existing PR changes the intended workflow, present the evidence and ask which path to use. Never create a duplicate branch merely because the matching branch is remote.

## Create and verify

Generate a concise branch name using the repository's type vocabulary and slug style. Explain the proposed base and name when they required inference; avoid redundant confirmation when the user already approved that exact branch creation.

Bring the selected base up to date using a fast-forward-only update. Stop if updating or switching would disturb the worktree.

Prefer GitHub's linked-branch workflow:

```bash
gh issue develop <issue-number> --name <branch-name> --base <base-branch> --checkout
```

If the intended linked branch already exists, fetch and check it out instead. Use a plain Git branch only when GitHub linkage is unavailable and the user explicitly accepts that loss of linkage.

Verify all of the following before editing:

- The checked-out branch is the intended working branch.
- Its base is the intended integration branch.
- The issue's Development branches include it.
- The worktree state is understood and unrelated changes remain intact.

Report the branch name, base, linkage result, and any preserved dirty-worktree state.
