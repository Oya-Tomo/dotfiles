---
name: impl-with-monitoring
description: Delegate implementation of an issue or specification to a background subagent while the main thread monitors it on a fixed interval (default 3 minutes), reviews each tick through a bundled script that reports change stats, ast-grep rule hits, and structural diffs of settled files, sends immediate strict feedback on observed problems, and reports progress to the user. Use when the user asks for impl-with-monitoring, asks to implement an issue or spec through a supervised or monitored subagent, or another skill such as work-on-issue routes implementation through it.
---

# Implement with Monitoring

The main thread owns the specification, monitoring, review, and communication with the user. A subagent owns the implementation. While the subagent is running, the main thread does not edit implementation files.

Use this workflow for every implementation it is invoked for, however small the change. It deliberately overrides the defaults of doing small tasks inline and of waiting passively for a subagent to finish. Skip it only when the user explicitly says to.

## Tick script

`scripts/tick.sh`, next to this `SKILL.md`, carries out every monitoring review. Resolve its absolute path from this file's location; do not assume an install location. Run it with `bash`.

- `tick.sh init <state-dir> <repo> <rules.yml> <progress-log>` records the baseline snapshot and rule hits.
- `tick.sh tick <state-dir> [--quiet SECONDS] [--max-lines N]` prints the digest for one tick.
- `tick.sh final <state-dir>` prints the whole change since the baseline.

A tick digest contains:

- Change stats since the baseline and since the previous tick.
- ast-grep rule hits added (`+`) or removed (`-`) since the previous tick.
- New progress log lines, and a count of consecutive ticks with no change.
- Files still settling, which were modified within the last `--quiet` seconds (default 60).
- The structural diff of each settled file, starting from the version the previous digest showed, so changes already reviewed are not shown again. Diffs over `--max-lines` (default 300) are deferred to the next tick.

All state lives in the state directory, so monitoring survives context compaction.

## Prepare

1. Read the issue or specification, repository instructions, and relevant code. Confirm that goal, scope, out-of-scope boundaries, done conditions, and validation commands are settled, and note pre-existing worktree changes.
2. Resolve open decisions with the user before delegating. The subagent cannot ask the user.
3. Use a 3-minute monitoring interval unless the user specifies another.
4. Create a state directory outside the repository, such as in the session scratch directory. Keep the progress log there as well.
5. Write an ast-grep rule file (`rules.yml`, rules separated by `---`) in the state directory. It turns the specification into checks the script runs on every tick:
   - Rules matching the definitions the change touches, such as functions, classes, methods, and public types, in each affected language, so that added, removed, renamed, and re-signatured definitions surface. Use `severity: info`.
   - Rules for patterns the specification forbids or the project disallows. Use `severity: error` with a message naming the requirement.
   - Rules for patterns the specification requires, such as a new call site, so that their appearance is visible.

   Check each rule once with `ast-grep scan -r rules.yml` before continuing. Invoke the tool as `ast-grep`, since `sg` may be a different command. If `ast-grep` is unavailable, stop and tell the user instead of monitoring without it.
6. Run `tick.sh init`.

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

1. Run `tick.sh tick` and review its digest. Do not read the full diff or re-read whole files on every tick. Judge in-progress work by the stats and rule hits. Review settled files in detail from the structural diffs the digest shows. Open other code only to investigate a concrete suspicion raised by the digest.
2. When the specification calls for a check the rule file lacks, add a rule. The next digest reports the new rule's existing hits as added.
3. Run tests, lint, or type checks in proportion to the risk once the change stabilizes, the subagent reports validation, or it reports completion. Do not run them against half-edited code or concurrently with the subagent's own runs when they share build output, ports, or databases.
4. Apply the feedback rules below.
5. Report to the user in a few lines: what changed since the last tick, the current stage, the AST result (rule hits added or removed, or none), feedback sent, and open concerns.
6. Re-arm the timer.

If the digest reports two consecutive ticks with no change, check whether the subagent is still running or stuck, and report the stall to the user.

After context compaction or when resuming monitoring, load this skill again before the next tick, and continue with the existing state directory.

## Feedback rules

Send a message only for a problem observed in the digest, the log, or check output. Never resend, remind, or paraphrase the brief. A brief item that is not implemented yet is not a problem, because the subagent may not have reached it; it becomes one only when the subagent claims completion without it or the change heads in a conflicting direction. Do not send praise or status pings.

Judge in-progress code by its direction, not its completeness. A half-written function is fine; a wrong data model, an interface that contradicts the specification, or a change outside the scope is not.

When a problem is observed, send feedback immediately and strictly:

- Name the location (file and line, or symbol), the violated requirement or defect, and the required correction.
- State it as a required correction, not a suggestion.
- Cover specification deviations, scope creep, bugs, broken project patterns, unsafe operations, failing checks caused by the change, missing tests at completion, and designs that will need rework.

Report every piece of feedback to the user in the same turn. On the next tick, verify that it was applied. If the same problem survives two rounds of feedback, stop sending corrections and ask the user for direction with a recommendation.

## Finish

When the subagent reports completion:

1. Stop the timer.
2. Run `tick.sh final` and review the whole change from the baseline, including every rule hit added since the baseline. Run the required checks yourself. Do not rely on the subagent's report alone.
3. Send any problems back to the same subagent, which keeps its context, and resume monitoring until they are resolved.
4. Report the implemented change, validation results, a summary of the feedback given, and residual risks.

## Harness notes

- Claude Code: launch the subagent with the Agent tool, which runs it in the background. Use `sleep <seconds>` through Bash with `run_in_background` as the timer; it re-invokes the main thread when it exits, and re-arming after each tick keeps ticks from overlapping. Send feedback with SendMessage, which reaches the subagent at its next tool round. Completion arrives as a notification; stop the pending timer with TaskStop.
- Codex: requires the multi-agent feature. Spawn the subagent, use a wait on it with a timeout equal to the interval as the timer, and send feedback as input to the running agent.
