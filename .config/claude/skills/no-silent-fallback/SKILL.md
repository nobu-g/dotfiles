---
name: no-silent-fallback
description: Remove silent fallbacks so a missing value fails loudly instead of being substituted — `dict.get(key, default)`, `or`/`??`/`||` defaults, default arguments, optional fields, `${VAR:-x}`, swallowed exceptions, no-op early returns, silent clamping. Use when asked to suppress or remove fallbacks or default values, to make arguments/flags/config keys required, to audit a codebase for silent defaulting (「フォールバックを消して」「デフォルト値をやめたい」「引数を必須にしたい」「守備的な実装をやめたい」), or when deciding whether a new parameter deserves a default at all. Ships a decision test separating defaults that are the specification from defaults that only hide caller bugs, plus an audit-report template.
---

# no-silent-fallback

Defensive defaulting raises the success rate of a single run and lowers the transparency of the whole codebase: the artifact stops recording which values produced it, and a caller's omission surfaces far from its cause — or never. The goal is not *zero defaults*. It is **zero defaults that can only be reached by a mistake**.

For code being written now, the rule already exists in `~/.config/claude/docs/coding-principles.md` (Avoid over-engineering → Defensive coding): don't add fallbacks for scenarios that can't happen. This skill is the other half — how to judge a default that is already there, and how to remove one without merely relocating the crash.

## When to use

- A request to remove fallbacks or default values, or to make parameters, flags, or config keys required.
- An audit: "list every default and say which ones should be required."
- Reviewing a diff that introduces a default, an optional field, or a `??`.
- Choosing the signature of a new function, CLI flag, config key, or schema field.

Don't sweep for fallbacks as a side task inside an unrelated change, and treat a question about them as a request for an answer rather than for the edit (`coding-principles.md` → Act only on explicit instructions).

## Decision test

A default **hides a bug** if any of these hold:

1. **Reachable only by mistake.** Every production call site already passes the value; the default fires only when someone forgets.
2. **Layered or duplicated.** The same value gets a default in more than one layer, or the same default-resolution expression appears in more than one place. Layers that disagree are the acute form: the effective value then depends on which entry point you came through.
3. **It decides what the output means.** Data source, format, mode, page, sandbox, working directory, model. A run whose identity comes from a default no longer records how it was produced.
4. **It fabricates data from absence.** A missing key becomes a synthesized id (`region_id or f"crop-{i:03d}"`), a coordinate (`bbox.get("l", 0.0)`), a size (`0×0`), or a metric (`0 tokens, 0 USD`). Corrupted output that passes validation is strictly worse than a crash.
5. **It is already unreachable.** An upstream check guarantees the value. That is dead code — delete the branch instead of converting it into a raise.

A default is **legitimate** if any of these hold:

- **The default is the specification** — Excel's 8.43 default column width, a protocol's documented default. Its absence in the source is normal, not an error.
- **Tuning constant or threshold** whose value is part of the documented contract (coverage thresholds, padding, sample limits).
- **Absence carries a documented meaning** — an unset model means "use the environment's", an omitted `--output` means in-place.
- **Read-only or display layer** tolerating older or partial records so a UI can still render them.
- **Degradation that is labeled in the output**, so a reader can tell it happened. Unlabeled degradation is a bug hider.
- **Pass-through of whatever exists** — forwarding env vars that may or may not be set.
- **Test seam** (`now: datetime | None = None`) — acceptable; injecting explicitly from the test is better.

Tie-breaker when the case is genuinely unclear: *if this default fires in production, will anyone ever find out?* If not, it hides a bug.

## Removing a fallback means moving the failure earlier

- **Encode it in the signature or schema, not in a runtime guard.** Required argument, required field, `required=True`, `${VAR:?…}`. Type-check or startup time beats runtime; runtime beats never.
- **Fail once, at the boundary that owns the value** (CLI, config loader, external input), then trust it downstream. Deleting the same default from four layers is correct; adding four raises is the same defensiveness with the sign flipped.
- **Never leave a path that yields an invalid value.** `${VAR:-}` or a required-in-spirit `T | None = None` with no check converts a silent default into a distant `NoneType`/empty-string failure. If the value cannot be produced, stop there.
- **Name the missing thing and how to supply it** in the message: `HOST_UID is not set: export it via direnv or run through the Makefile`. A bare "missing required value" is a quieter version of the same problem.
- **Raise, don't `assert`**, for anything a caller can get wrong — assertions vanish under `-O`.
- **Prefer deletion to requirement** when only one value is ever valid: drop the parameter and inline the constant rather than forcing every caller to pass the same thing.

## Making something required is a caller-wide change

In the same change, update every place that will now have to supply the value:

- all call sites, plus tests and fixtures (these break first);
- wrappers, entrypoints, containers (compose env, Dockerfile, Makefile targets);
- the config schema **and** every committed config file — a required key must be present in all of them, which is the point: the config becomes the record of the run;
- example commands in README / CLAUDE.md / docs.

A required parameter with one un-updated caller is not fail-loud, it is a crash you shipped. If the repo keeps hand-maintained parallel ports (a Python↔TypeScript mirror, duplicated validators), change both sides in the same commit — one-sided edits are exactly the drift this work exists to remove.

Removing a default from a published library's public API is a breaking change: weigh it against `coding-principles.md` → Backward Compatibility first. For internal, research, or prototype code, take the clean signature.

## Pattern catalogue

| Construct | Why it hides a bug | Fail-loud form |
| --- | --- | --- |
| `d.get("k", v)` on a contract dict | a producer that skipped `k` looks identical to one that set it to `v` | `d["k"]` — the `KeyError` already names the key |
| `d.get("k") or v` | also swallows a valid `0`, `""`, `[]` | `d["k"]` |
| `region.get("id") or f"item-{i:03d}"` | fabricates identity; mismatch surfaces much later as an unrelated validation failure | `raise ValueError` naming the producer that should have set it |
| `def f(x: T = DEFAULT)` where all callers pass `x` | back door around the layer that owns the value | drop the default (keyword-only if the signature is long) |
| `x: T \| None = None` for a value that must exist | pushes the failure to the first attribute access | `x: T`; keep `\| None` only when absence has a documented meaning |
| pydantic `Field(default=...)` on an identity key | the dumped config no longer shows the effective value | required field + `ConfigDict(extra="forbid")` so typos fail too |
| `getattr(obj, "attr", v)` | hides renames and refactors | plain attribute access |
| `except Exception: pass` / `except …: return None` | erases the diagnosis | catch the one expected exception, or let it propagate |
| `if not path.exists(): return` (no-op) | a guaranteed artifact going missing is a bug, reported as success | raise |
| `zoom = max(dpi, 300) / 72` | silently rewrites the caller's value — the most confusing kind | validate the range and reject, or drop the parameter |
| `argparse(..., default=X)` for a run-defining flag | bypasses config as the single source of truth | `required=True`; if one value is always right, delete the flag |
| `os.environ.get("X", v)` for a deployment value | one host silently runs differently | `os.environ["X"]` |
| `a ?? b`, `a \|\| b` (TS) | same as above; `\|\|` also swallows `0` / `""` | make the field required in the type |
| `field?: T` in an input interface | every consumer grows its own `??` | `field: T` |
| `table[key] ?? []` after `key` was validated | dead fallback, kept alive by habit | index directly |
| `${VAR:-fallback}` (shell, compose) | an unset host value becomes a plausible wrong one | `${VAR:?how to set it}` — the message is the documentation |
| loader defaults for keys that define a run | the copied config no longer records the run | required keys + strict/forbid-extra |

Deleting `:-` alone is not the fix: `${VAR:-}` still yields an empty string. Use `:?`.

## Audit workflow

When the request is "list the places first", produce a report and stop — proposing is not applying.

1. **Read the real entry points first** (CLI, config loader, orchestration, container entrypoint). A default is judged against its actual callers, so you need to know what production always passes before you can call a default unreachable.
2. **Sweep mechanically.** These over-report by design; classification is the work:
   ```bash
   rg -n --type py '\.get\([^)]+,'                          # dict.get with a default
   rg -n --type py '\bor\s+(0|0\.0|""|\[\]|\{\}|False)'      # falsy-swallowing `or`
   rg -n --type py '=\s*(None|0|""|False|\[\]|\{\})\s*[,)]'  # default arguments
   rg -n --type py 'getattr\([^,]+,[^,]+,'                   # getattr with a default
   rg -n --type py 'default=|default_factory='               # argparse / pydantic
   rg -n --type py 'except[^:]*:\s*(pass|return)'            # swallowed exceptions
   rg -n --type py 'environ\.get\(|getenv\('                 # env defaults
   rg -n --type ts '\?\?|\|\|'                               # nullish / falsy fallbacks
   rg -n --type ts '^\s*\w+\?:'                              # optional interface fields
   rg -n --glob '*.{sh,zsh,yml,yaml}' '\$\{[A-Za-z_][A-Za-z0-9_]*:-'
   ```
3. **Classify every hit** with the decision test, and record the **caller evidence** — the `file:line` that already passes the value. That evidence is what turns "a default exists" into "this default is unreachable except by mistake".
4. **Write the report** from `references/audit-report-template.md`: `file:line`, which criterion it trips, the fix, priority. Always include the *no change needed* section with reasons — the negative list is what makes the audit trustworthy and keeps the next sweep from re-flagging the same lines. Write it in the language the user is writing in.
5. **Order by blast radius**, not by count: values that decide what the output means → fabrications from missing data → dead fallbacks → cosmetic. Group items that follow from a single decision so they land in one commit.
6. Hand the report over and let the user choose the scope.

## Fix workflow

1. One decision at a time, with mirrors and duplicated expressions in the same step.
2. After each group, run the project's tests and build (`~/.config/claude/docs/python-project-ops.md` for the commands). Required-argument changes break fixtures before they break production.
3. **Prove the new failure is loud.** Run the thing with the value missing and read the message — `env -u HOST_UID docker compose config` must fail with the intended text; a config missing a newly required key must be rejected. An unverified raise is an assumption.
4. **Report deviations.** If the plan said "require" and you kept the default, say so with the reason (for example: a multi-format acceptance whose defaults cannot corrupt anything) instead of silently skipping the item.

Close by stating what became required, what was deleted as dead code, what was intentionally kept and why, how each new failure was verified, and which callers, configs, or docs had to change as a consequence.
