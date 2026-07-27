# Coding Principles

Language-agnostic principles that apply to every coding task.

- Write code comments, docstrings, log and error messages, and commit messages in English. Follow project requirements for user-facing text.
- Prefer small, reviewable changes.
- Inspect the project documentation, code, tests, and configuration before asking. Ask only when unresolved ambiguity would materially affect behavior, data semantics, scope, or destructive or external actions.
- Explain assumptions before non-trivial analytical or design decisions.
- If `.pre-commit-config.yaml` exists, run the hooks relevant to the changed files. Follow project instructions when a broader run is required.

## Backward Compatibility

- By default, ignore backward compatibility and prefer the cleanest, simplest current design. Treat research and prototype code as non-mature unless the repository shows otherwise.
- Preserve compatibility only when the task or project requires it, or the code is demonstrably highly mature and stable. Before a breaking change, weigh repository age and commit volume, codebase size and quality, release and versioning practices, tests and documentation, and evidence of public APIs, persistent formats, or downstream users. If the evidence conflicts and the impact is material, ask before deciding.

## Tool caches

Use each tool's default cache location, including when running as a coding agent. Never redirect a cache into the working tree as a precaution: it discards an existing warm cache, re-downloads everything from scratch, pollutes the working tree, and often cannot be cleaned up afterwards because deleting it needs a permission the agent does not have.

Redirect a cache only after a command has actually failed because the home directory is unwritable, and only for the tool that failed:

- `npm`: `npm_config_cache=./.npm_cache`
- `pre-commit`: `PRE_COMMIT_HOME=./.pre-commit-cache`
- `uv`: `UV_CACHE_DIR=./.uv_cache`

When a redirect is unavoidable, keep the directory out of every commit, and tell the user in the response that it exists and how to remove it.

## Freshness-sensitive facts

Treat fast-changing technical facts as uncertain. Before relying on current versions, APIs, CLI flags, compatibility matrices, model support, pricing, limits, or known bugs, verify them from primary sources when the answer may affect implementation or advice. If verification is not possible, state the uncertainty and avoid presenting memory as fact.

## Avoid over-engineering

Only make changes that are directly requested or clearly necessary. Keep solutions simple and focused:

- **Scope:** Don't add features, refactor code, or make "improvements" beyond what was asked. A bug fix doesn't need surrounding code cleaned up. A simple feature doesn't need extra configurability.
- **Documentation:** Don't add docstrings, comments, or type annotations to code you didn't change. See `Comments` below.
- **Defensive coding:** Don't add error handling, fallbacks, or validation for scenarios that can't happen. Trust internal code and framework guarantees. Only validate at system boundaries (user input, external APIs).
- **Abstractions:** Don't create helpers, utilities, or abstractions for one-time operations. Don't design for hypothetical future requirements. The right amount of complexity is the minimum needed for the current task.

## Comments

Code must be self-documenting. Comments are a last resort for what naming and structure cannot express, so keep them minimal.

- Write a comment only for non-obvious behavior or constraints that remain true independently of any edit: why a surprising approach was necessary, an external contract or bug being worked around, a non-obvious invariant, or a link to a spec or issue.
- Never narrate the change. Comments and docstrings must not describe the edit, the previous implementation, the reason for the change, or the user's request. Delete such comments when editing code that already contains them. Prohibited examples:
  - `# changed from list to set for performance`
  - `# NEW: added retry handling`
  - `# removed the old validation here`
  - `# now uses the v2 endpoint`
  - `# keeping this for backward compatibility with the previous version`
- Change summaries belong in the response to the user, the commit message, or the pull request description — never in the code. A reader checking out the file months later has no use for them; `git log` and `git blame` already answer "what changed and why".
- A comment that would go stale the moment the code changes again does not belong in the code.

## Markdown authoring

Write agent-facing Markdown (instruction files, skills, docs) without hard line wrapping. Break lines only at real structural boundaries — paragraphs, list items, headings. Mid-sentence line breaks inserted to satisfy a column limit add no meaning and only make the text harder to read and edit.
