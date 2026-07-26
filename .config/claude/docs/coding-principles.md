# Coding Principles

Language-agnostic principles that apply to every coding task.

- Write code comments, docstrings, log and error messages, and commit messages in
  English. Follow project requirements for user-facing text.
- Prefer small, reviewable changes.
- Inspect the project documentation, code, tests, and configuration before asking.
  Ask only when unresolved ambiguity would materially affect behavior, data
  semantics, scope, or destructive or external actions.
- Explain assumptions before non-trivial analytical or design decisions.
- If `.pre-commit-config.yaml` exists, run the hooks relevant to the changed
  files. Follow project instructions when a broader run is required.

## Backward Compatibility

- By default, ignore backward compatibility and prefer the cleanest, simplest
  current design. Treat research and prototype code as non-mature unless the
  repository shows otherwise.
- Preserve compatibility only when the task or project requires it, or the code
  is demonstrably highly mature and stable. Before a breaking change, weigh
  repository age and commit volume, codebase size and quality, release and
  versioning practices, tests and documentation, and evidence of public APIs,
  persistent formats, or downstream users. If the evidence conflicts and the
  impact is material, ask before deciding.

## Coding-agent and sandboxed environments

Redirect tool caches into the project before running tools that would otherwise
write to a home-directory cache. Do not commit those cache directories.

- `npm`: prefix commands with `npm_config_cache=./.npm_cache`.
- `pre-commit`: prefix commands with `PRE_COMMIT_HOME=./.pre-commit-cache`.

## Freshness-sensitive facts

Treat fast-changing technical facts as uncertain. Before relying on current versions, APIs, CLI flags, compatibility matrices, model support, pricing, limits, or known bugs, verify them from primary sources when the answer may affect implementation or advice. If verification is not possible, state the uncertainty and avoid presenting memory as fact.

## Avoid over-engineering

Only make changes that are directly requested or clearly necessary. Keep solutions simple and focused:

- **Scope:** Don't add features, refactor code, or make "improvements" beyond what was asked. A bug fix doesn't need surrounding code cleaned up. A simple feature doesn't need extra configurability.
- **Documentation:** Don't add docstrings, comments, or type annotations to code you didn't change. Only add comments where the logic isn't self-evident.
- **Change narration:** Don't use code comments or docstrings to describe the edit itself, the previous implementation, or the user's request. Put change summaries in the response, commit message, or pull request instead. Comments in code should explain only non-obvious behavior or constraints that remain true after the change.
- **Defensive coding:** Don't add error handling, fallbacks, or validation for scenarios that can't happen. Trust internal code and framework guarantees. Only validate at system boundaries (user input, external APIs).
- **Abstractions:** Don't create helpers, utilities, or abstractions for one-time operations. Don't design for hypothetical future requirements. The right amount of complexity is the minimum needed for the current task.
