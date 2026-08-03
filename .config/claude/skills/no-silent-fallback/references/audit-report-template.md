# Default-value audit template

Copy this structure, keep the headings, delete the guidance in parentheses. Write it in the language the user is writing in.

---

# Default-value audit: values that should be required

Falling back to a default value hides the caller's omission and makes it impossible to read from the code which values a run actually used. This report classifies every default in the scope below and proposes the fail-loud form for the ones that only fire on a mistake.

**Criteria**

- *Must be required* — production callers always pass the value, so the default is reachable only by mistake; or the same default resolution is duplicated across layers; or the default fabricates data from absence; or it decides what the output means.
- *Legitimate* — the default is the specification, a documented tuning constant, a meaningful absence, display-layer tolerance of partial records, or a labeled degradation.

**Scope read**: (dirs/files actually read, with rough line count — say what was *not* read)
**Ports that must change together**: (hand-maintained mirrors, duplicated validators; state the rule that binds them)

## Priority: high — (theme, e.g. contract values with layered defaults)

### 1. (one-line title naming the value, not the file)

- `path/to/file.py:LL` — `code fragment`
- `path/to/mirror.ts:LL` — `code fragment` (list every site of the same default)

**What silently happens**: (which criterion, and the concrete wrong outcome — not "it is unsafe")
**Caller evidence**: `caller.py:LL` already passes `<value>`; the default is only reachable when the SDK is used directly.
**Fix**: (the fail-loud form, and where the single boundary check belongs)

## Priority: medium — (theme, e.g. fallbacks that swallow data inconsistency)

(same item shape)

## Priority: low — (explicitness wanted, limited real impact)

(same item shape)

## No change needed (intentional defaults)

- `path:LL` — (why: it is the spec / documented two-mode behavior / display-only / a labeled degradation)

## Recommended order

1. (group items that follow from one decision, mirrors together, so they land in one commit)
2. …

## Verification per step

(test command, build command, and the "run it with the value missing and confirm the error" check for each group)
