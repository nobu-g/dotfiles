---
name: prune-tests
description: Prune low-value tests and consolidate duplicated ones across a test suite while holding coverage. Use when asked to clean up, slim down, deduplicate, or audit an existing test suite, including Japanese requests such as "テストを整理して", "不要なテストを削って", "重複したテストをまとめて", or "テストが多すぎる". Not for writing tests for untested code.
---

# Prune Tests

A test earns its place only by catching a credible regression that no other test catches. Agents tend to add a test for every small change, so suites accumulate tests that re-assert the source, replay a stronger test through a mock, or pin a private call shape. Deleting them barely moves coverage but cuts maintenance cost and suite time.

## Judge each test

Each contract should have one primary test at the strongest boundary that can observe it, usually the public entry point. Another layer deserves its own test only for a distinct risk the primary test cannot reach.

Delete or merge tests that match these patterns unless you can name the contract they alone guard:

- No meaningful assertion, or only "does not raise" on a path that cannot raise.
- Expected values produced by the code under test, self-comparisons, or snapshots of data the test itself defines.
- Greps of source text, imports, or export lists that break on a rename and survive a real behavior change.
- Assertions on private helpers or call shapes (`assert_called_with` on an internal) already covered at a real boundary.
- Mocks that implement the behavior being asserted.
- The same contract exercised again with trivially different inputs, or replayed per caller of a shared helper.
- Negative tests that pass for an unrelated reason, such as a rejection from a different guard.
- Names that promise more than the assertions check; judge by the assertions.
- Tests that exist only to keep a test-only export, flag, or wrapper alive. Delete that production seam too when nothing else uses it.

Merge near-duplicates into one parametrized or table-driven test and share setup through fixtures, rather than deleting cases that cover genuinely different behavior.

## Set a target

An open-ended cleanup stalls after a few obvious deletions because every remaining test looks defensible in isolation. Use the user's target if given; otherwise propose one and proceed, e.g. "remove the least valuable 20% of tests in `<scope>`, keeping line and branch coverage within 2 points of the baseline." The target is a floor on effort, not permission to cut a test that guards a named contract.

Measure coverage with the project's existing tooling before and after. Stop short of the target only when you can state, for each remaining candidate, the contract it guards.

## Report

Run the full affected test suite after changes. Report coverage before and after, the number of tests removed and merged, and the patterns behind them. List any test you kept despite matching a pattern, with the contract it guards.
