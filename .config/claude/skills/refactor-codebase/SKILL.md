---
name: refactor-codebase
description: Refactor an existing codebase or module toward the simplest design that does the job, across files and within them. Use when asked to refactor, simplify, clean up, or restructure code that has accumulated complexity, especially code written incrementally by coding agents, including Japanese requests such as "リファクタリングして", "コードを整理して", "コード全体を見直して", or "シンプルにして". Not for feature work or for cleaning only the current diff.
---

# Refactor Codebase

Simplicity is the goal, not one consideration among many. Agents left alone push code toward complexity: each request adds a branch, a parameter, a helper, or a guard, and nothing is ever removed. Refactoring is the counterforce. Judge every change by whether the result has fewer concepts, fewer code paths, and less code a reader must hold in mind. A change that only moves complexity around, or adds structure in exchange for hypothetical flexibility, is not a refactor.

## Principles

- Prefer deleting to rewriting, and rewriting to adding. Inline before you extract.
- Three similar lines beat a premature abstraction. Extract only when the pieces share a reason to change, not merely a shape.
- One concept, one implementation, one way of doing it across the repository.
- Design for the callers that exist today. Remove options, parameters, and branches no current caller needs.
- Concrete code beats indirection. Every layer must earn its place by hiding real complexity behind a simpler interface.
- Leave the code simpler than you found it in every edit; never trade simplicity for a pattern.

## Look for

Agent-typical decay, highest priority:

- Special-case `if`s and flags bolted on per request where one general rule would cover all cases.
- Reimplementations of an existing helper, the standard library, or an installed dependency.
- The same problem solved differently in different places: error handling, logging, config loading, path handling, I/O.
- Leftovers: unused functions, parameters, branches, compat shims, old implementations kept alongside new ones, debug output, stale TODOs.
- Defensive code for states that cannot occur, swallowed exceptions, silent fallbacks.
- Speculative generality: interfaces or base classes with one implementation, factories, registries, config knobs nobody sets, parameters always passed the same value.

Across files:

- Misplaced code, circular imports, and dependencies pointing the wrong way between layers.
- Shallow modules and pass-through wrappers whose interface is as complex as their body.
- Files or classes that mix unrelated responsibilities, and single concepts split across many tiny modules.
- Multiple libraries serving the same purpose, and unused dependencies.

Within a file:

- Functions and classes at the wrong granularity: too long to read at once, or so small that following the logic means jumping between them.
- Names that are vague, inaccurate, or inconsistent with the names used for the same concept elsewhere.
- Raw dicts, tuples, or strings carrying structured data; types that allow invalid states; `Any`, casts, and type-check suppressions.
- Long parameter lists, boolean parameters that switch behavior, inconsistent return conventions (`None` versus raising).
- Hidden side effects, mutable global state, work done at import time, logic tangled with I/O.
- Deep nesting, repeated computation, magic numbers, duplicated constants.

Comments and docs are covered by `trim-comments-and-docs`, fallbacks by `no-silent-fallback`, and tests by `prune-tests`.

## Process

1. Scope. Take the user's scope if given; otherwise cover the repository, starting from the files that change most often (`git log --format= --name-only | sort | uniq -c | sort -rn`).
2. Read before judging. Read the in-scope code fully, and survey how the repository already handles each recurring concern. Pick the simplest existing convention as the target and converge outliers to it; do not invent a new one when an adequate one exists.
3. Classify each candidate change. Ignore backward compatibility by default, as `coding-principles.md` says: change internal APIs, signatures, and module layout freely, update every caller, and delete compat shims. Confirm first only when a change alters important user-facing behavior, such as CLI options, output formats, persisted data, or public API semantics. A small spec change of that kind that removes a lot of complexity is worth proposing, e.g. unifying slightly different behavior of similar entry points, or dropping a rarely used option. Present all such proposals together, each with the behavior that changes, who could notice, and the complexity removed. Apply only the ones the user approves.
4. Work in small steps and run the affected tests after each group of changes. Update tests to follow intended changes, never to make an unintended behavior change pass silently.
5. Stop when no remaining candidate makes the code meaningfully simpler. Do not churn code for taste.

## Report

Summarize what was removed, merged, and renamed, with net lines changed. List the user-facing proposals and their status. Run the full test suite and, if configured, lint and type checks, and report the results.
