---
name: work-on-issue
description: Implement or continue GitHub issue work across repositories. Use when the user asks to work on, fix, implement, resume, or advance an issue through investigation, branch handling, scoped changes, validation, review, commit, push, or PR handoff.
---

# Work on Issue

Use the issue as the scope and planning surface. Continue to the exact stop point the user requested; implementation alone does not imply permission to push or create a PR.

## Orient and resume

1. Identify and read the complete target issue, including comments that contain evidence or later decisions.
2. Read repository workflow instructions and inspect the relevant code, tests, documentation, and history.
3. Check linked Development branches, matching local and remote branches, existing PRs, and prior progress.
4. Inspect `git status --short --branch` and distinguish pre-existing changes from issue work.
5. Resume the existing branch or PR when it represents the same work. Apply `create-branch` when a new issue-linked branch is needed.

Do not delete, overwrite, stash, revert, or commit unrelated user changes. If previous work conflicts with a fresh start, ask before replacing anything.

## Make the issue implementable

Confirm that the issue identifies the goal, scope, out-of-scope boundaries, done conditions, and validation method. Investigate before asking questions. Ask only about decisions that are not recoverable from the repository and would materially change the result; include a recommendation.

Record stable specification changes in the issue body so it remains the source of truth. Keep comments concise and use them for milestone evidence, reproduction results, or decisions that benefit from a timeline.

Create an implementation plan grounded in specific components and dependencies. Split work when separate slices are independently mergeable, reviewable, and useful; do not use an arbitrary line-count threshold. Represent an agreed multi-part plan with formal sub-issues when the parent is an umbrella or tracking issue.

## Implement within scope

- Follow established project patterns unless the issue explicitly changes them.
- Make the smallest coherent change that satisfies the done conditions.
- Ask before expanding into unrelated cleanup, public API or UX decisions, security or data-retention policy, operational cost, or choices expensive to reverse.
- Update dependency manifests and lockfiles together, preserve runtime/dev separation, and exercise any newly added tool or dependency.
- Keep intended issue changes distinguishable from pre-existing worktree changes and stage only intended files.

When implementation discovers a necessary scope change, explain its impact and update the issue body after agreement. Do not bury scope changes in a commit or PR description.

## Validate and review

Discover the project's required checks from repository docs, CI workflows, build configuration, and nearby changes. Run checks proportionate to the affected behavior, including manual or visual validation when automation cannot cover it.

For each failure, determine whether it comes from the current change, pre-existing repository state, or the environment. Fix failures caused by the change. Preserve evidence for inherited or environmental failures, and do not broaden scope to fix them without approval unless the issue cannot otherwise be validated.

Review the complete diff against the selected base for correctness, regressions, scope creep, tests, documentation, and accidental unrelated changes. Fix actionable findings and rerun affected checks. If the same blocker survives two review/fix cycles, stop and request direction instead of looping indefinitely.

## Finish at the requested boundary

Before declaring completion, verify:

- The issue's done conditions are met.
- Intended changes are scoped and unrelated changes are excluded.
- Relevant checks ran, with exact failures or skips recorded.
- Residual risks and deferred work are explicit.

Commit only intended changes when the requested endpoint requires a commit. Push only when the user asks to publish the branch or requests a PR. Apply `create-pull-request` only when PR creation is explicitly requested or clearly included in the user's terminal instruction.

Report the implemented change, validation results, current branch/publication state, and residual risks.
