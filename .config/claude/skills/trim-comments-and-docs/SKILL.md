---
name: trim-comments-and-docs
description: Prune redundant comments and repository documentation, consolidate knowledge, and reduce always-loaded agent context. Use when asked to simplify or reorganize existing comments, docs, or agent instructions, including Japanese requests such as "冗長なコメントを削減して", "ドキュメントの重複を整理して", or "READMEやCLAUDE.mdをスリム化して".
---

# Trim Comments and Docs

Minimize what readers must read and maintain while preserving information needed to use or change the project correctly. Prefer deletion and consolidation over rephrasing.

## Decide what earns its place

Read the relevant code and documents before editing. For each passage, ask what decision it helps a future reader make.

Delete explanations evident from the code, duplicated facts, and obsolete instructions. Remove task narration and conversational residue; retain the underlying rationale only if it still matters. Do not turn each past incident into a permanent rule.

Keep useful contracts, constraints, and rationale that the intended reader would otherwise lack. Public documentation should let callers use an interface without inspecting its implementation; this does not justify line-by-line explanations inside the code.

Preserve the conditions under which a claim holds. Distinguish current requirements from observations and historical decisions.

Deduplicate meaning, not wording. An overview and its supporting detail may serve different purposes.

## Choose one home

Place retained information according to its audience and when it is needed:

- **Code comments:** Non-obvious reasons or invariants needed to change the adjacent logic safely.
- **User or API documentation:** Contracts, usage, configuration, and operational guidance.
- **Agent entrypoints:** Current conclusions and instructions needed across routine tasks.
- **On-demand documents:** Specialized context, supporting evidence, and history worth retaining.

Keep each fact in one authoritative location. Prefer existing documents; add a link elsewhere only when it helps discovery. For on-demand material, state when to consult it rather than requiring agents to load everything.

Consolidate without creating unnecessary navigation. Keep each explanation coherent; link to supporting detail rather than scattering it across files.

Delete unnecessary content instead of relocating it. A shorter entrypoint is not an improvement if the same clutter survives in new files or unconditional imports.

For example:

- Delete `# Sort records by timestamp` above `records.sort(key=lambda r: r.timestamp)`: it repeats the code.
- Keep `# The provider requires this header even for empty requests` beside the header assignment: it explains an external constraint absent from the code.
- Remove “Migration from v1 required rebuilding the index” from agent instructions once the migration is complete. Move it to an upgrade guide if supported users still need it; otherwise delete it.

## Verify the reduction

Preserve behavior, machine-consumed directives, required notices, and active project constraints. Check retained claims against available evidence without silently resolving uncertainty. Review affected links and run checks appropriate to the changes.

Report the meaningful deletions and relocations briefly in the response. Do not create a cleanup report or additional documentation unless requested.
