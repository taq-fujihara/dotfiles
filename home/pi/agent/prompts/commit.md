---
description: Inspect current git changes and commit them
argument-hint: "[instructions]"
---
Inspect the current git changes and commit them.

Instructions:
- If the repository uses Jujutsu, use `jj` commands instead of `git` for status, diff, and commit. Jujutsu skill might be available.
- Run `git status --short`.
- Inspect staged and unstaged changes with `git diff --cached` and `git diff`.
- If untracked files exist, inspect them before deciding whether to add them.
- Do not include unrelated or generated files unless clearly part of the change.
- Run relevant tests or checks when practical. If skipped, mention why.
- Stage the intended files.
- Write a concise commit message that matches the change.
- Commit with `git commit`.
- Do not push.

Extra instructions from the user:
${ARGUMENTS:-None}
