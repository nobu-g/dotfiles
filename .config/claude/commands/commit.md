Create a git commit for the work just done.

1. Run `git status` and `git diff` (and `git diff --staged`) to see what changed.
2. Identify only the files that belong to the change you just made. Stage **just those files** with `git add <path>...` — never `git add -A` / `git add .`. Leave unrelated edits, stray untracked files, and pre-existing changes alone.
3. If the working tree mixes several unrelated changes, stage only the group relevant to the most recent task and tell the user what you left out.
4. Review the staged diff once more, then commit with a concise message that follows this repo's existing commit style (check `git log` for the convention).

Do not push. Do not stage credentials, raw data, or generated artifacts. If $ARGUMENTS is provided, use it as guidance for the commit message or scope.
