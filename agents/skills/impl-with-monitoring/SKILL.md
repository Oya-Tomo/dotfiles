---
name: impl-with-monitoring
description: Delegate implementation of an issue or specification to a background subagent while the main thread monitors it on a fixed interval (default 3 minutes), inspects the diff and AST structure, sends immediate strict feedback on observed problems, and reports progress to the user. Use when the user asks for impl-with-monitoring or asks to implement an issue or spec through a supervised or monitored subagent.
---

# Implement with Monitoring

The main thread owns the specification, monitoring, review, and communication with the user. A subagent owns the implementation. While the subagent is running, the main thread does not edit implementation files.

## Prepare

1. Read the issue or specification, repository instructions, and relevant code. Confirm that goal, scope, out-of-scope boundaries, done conditions, and validation commands are settled, and note pre-existing worktree changes.
2. Resolve open decisions with the user before delegating. The subagent cannot ask the user.
3. Use a 3-minute monitoring interval unless the user specifies another.
4. Choose a progress log path outside the repository, such as the session scratch directory.
5. Record a baseline snapshot. This captures the worktree, including untracked files, as a tree without touching the real index:

   ```sh
   idx=$(mktemp) && cp "$(git rev-parse --git-path index)" "$idx" && GIT_INDEX_FILE=$idx git add -A && GIT_INDEX_FILE=$idx git write-tree; rm -f "$idx"
   ```

## Brief the subagent once

The initial brief is the single, complete instruction. Include:

- The specification, scope, out-of-scope boundaries, and done conditions.
- Relevant files, project patterns, and findings from preparation.
- Validation commands to run before reporting completion.
- Constraints: no commit, push, or PR; no unrelated changes; leave pre-existing changes untouched.
- The progress log path. Append one line per milestone: step started or finished, check run and its result, blocker found.
- Messages from the main thread are binding corrections. Apply them before continuing; if one appears wrong, explain why in the log instead of ignoring it.
- A final report: summary, changed files, validation results, open issues.

Launch the subagent in the background in the same worktree unless the user asks for isolation.

## Monitor on each tick

1. Take a new snapshot and inspect both the change since the previous tick and the whole change since the baseline:
   - `git diff --stat <base> <current>` for the scale and spread of the change.
   - `GIT_EXTERNAL_DIFF=difft DFT_DISPLAY=inline git diff <previous> <current>` for a structural diff of what changed since the last tick.
   - `ast-grep` structural queries on the changed files: definitions added, removed, or renamed; call sites of changed signatures; patterns the specification requires or forbids. Invoke it as `ast-grep`, since `sg` may be a different command.
2. Read the new lines in the progress log.
3. Run tests, lint, or type checks in proportion to the risk once the change stabilizes, the subagent reports validation, or it reports completion. Do not run them against half-edited code or concurrently with the subagent's own runs when they share build output, ports, or databases.
4. Apply the feedback rules below.
5. Report to the user in a few lines: what changed since the last tick, the current stage, feedback sent, and open concerns.
6. Re-arm the timer.

If neither the snapshot nor the log changes for two consecutive ticks, check whether the subagent is still running or stuck, and report the stall to the user.

If `difft` or `ast-grep` is unavailable, say so in the report and fall back to `git diff --function-context` and a language-native parser.

## Feedback rules

Send a message only for a problem observed in the diff, the log, or check output. Never resend, remind, or paraphrase the brief. A brief item that is not implemented yet is not a problem, because the subagent may not have reached it; it becomes one only when the subagent claims completion without it or the change heads in a conflicting direction. Do not send praise or status pings.

Judge in-progress code by its direction, not its completeness. A half-written function is fine; a wrong data model, an interface that contradicts the specification, or a change outside the scope is not.

When a problem is observed, send feedback immediately and strictly:

- Name the location (file and line, or symbol), the violated requirement or defect, and the required correction.
- State it as a required correction, not a suggestion.
- Cover specification deviations, scope creep, bugs, broken project patterns, unsafe operations, failing checks caused by the change, missing tests at completion, and designs that will need rework.

Report every piece of feedback to the user in the same turn. On the next tick, verify that it was applied. If the same problem survives two rounds of feedback, stop sending corrections and ask the user for direction with a recommendation.

## Finish

When the subagent reports completion:

1. Stop the timer.
2. Review the whole change from the baseline with the structural diff and `ast-grep`, and run the required checks yourself. Do not rely on the subagent's report alone.
3. Send any problems back to the same subagent, which keeps its context, and resume monitoring until they are resolved.
4. Report the implemented change, validation results, a summary of the feedback given, and residual risks.

## Harness notes

- Claude Code: launch the subagent with the Agent tool, which runs it in the background. Use `sleep <seconds>` through Bash with `run_in_background` as the timer; it re-invokes the main thread when it exits, and re-arming after each tick keeps ticks from overlapping. Send feedback with SendMessage, which reaches the subagent at its next tool round. Completion arrives as a notification; stop the pending timer with TaskStop.
- Codex: requires the multi-agent feature. Spawn the subagent, use a wait on it with a timeout equal to the interval as the timer, and send feedback as input to the running agent.
