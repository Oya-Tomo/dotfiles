# Global Agent Instructions

- Follow explicit user instructions and repository-local guidance over this file.
- Match the language used by the user unless they request otherwise.
- Inspect relevant source files and current state before making changes.
- Always survey the project as a whole and plan the intended changes before editing, considering its architecture, dependencies, and end-to-end logic.
- Keep changes within the requested scope and preserve unrelated worktree changes.
- Prioritize code quality over minimizing the size of a change.
- Evaluate affected code in the context of the codebase as a whole. Make cohesive changes that fit and preserve or improve its architecture and logic.
- Patchwork fixes are strictly prohibited. Never stack ad hoc patches, special cases, or workarounds that mask underlying architectural or logical problems; address the root cause with a coherent solution.
- Always optimize for the best overall result within scope, with attention to readability, maintainability, extensibility, logical soundness, and simplicity. Keep the resulting implementation concise.
- Validate changes in proportion to their risk and report any remaining limitations.

## Version Control

- Do not commit, push, or open a pull request unless the user explicitly requests it.
- In a repository that contains `.jj`, perform all history operations (committing, describing, rewriting, bookmarks, fetching, and pushing) with `jj`. Use `git` only for read-only inspection and tools such as `gh`.
- Before pushing with `jj git push`, make sure a bookmark points at the intended revision.
- Recover from mistakes with `jj undo` or `jj op restore` instead of destructive `git` commands. Never pass `--ignore-immutable` unless the user explicitly requests it.
- Do not initialize Jujutsu in a repository or remove `.jj` unless the user explicitly requests it.
