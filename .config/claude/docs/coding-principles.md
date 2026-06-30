# Coding Principles

Language-agnostic principles that apply to every coding task.

- Write code comments and messages in English.
- Prefer small, reviewable changes.
- Stop and ask whenever instructions, specifications, or data semantics are unclear.
- Explain assumptions before non-trivial analytical or design decisions.
- Follow standard coding conventions (e.g., PEP 8 for Python projects).
- If `.pre-commit-config.yaml` exists at the repository root, make sure the edited code passes pre-commit.
- Unless told otherwise, **ignore backward compatibility** and keep the code as simple as possible.
- Prioritize maintainability; avoid verbose or complex code.

## Avoid over-engineering

Only make changes that are directly requested or clearly necessary. Keep solutions simple and focused:

- **Scope:** Don't add features, refactor code, or make "improvements" beyond what was asked. A bug fix doesn't need surrounding code cleaned up. A simple feature doesn't need extra configurability.
- **Documentation:** Don't add docstrings, comments, or type annotations to code you didn't change. Only add comments where the logic isn't self-evident.
- **Defensive coding:** Don't add error handling, fallbacks, or validation for scenarios that can't happen. Trust internal code and framework guarantees. Only validate at system boundaries (user input, external APIs).
- **Abstractions:** Don't create helpers, utilities, or abstractions for one-time operations. Don't design for hypothetical future requirements. The right amount of complexity is the minimum needed for the current task.
