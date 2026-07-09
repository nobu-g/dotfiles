---
name: new-python-project
description: Scaffold and structure a new Python data/ML project the way this developer does — standard repo layout, the canonical pyproject.toml/ruff/ty/pre-commit setup, config & CLI architecture (Hydra vs argparse+pydantic), data-modeling and logging choices, and CLAUDE.md/README conventions. Use when starting a new Python project, setting up its toolchain/config, or aligning an existing repo to these conventions. Ships ready-to-use templates. For general Python style (type hints, docstrings, paths, lint/test commands) defer to the docs under ~/.config/claude/docs/.
---

# new-python-project

Project-level conventions for scaffolding a new Python data/ML project. This is about *how the repo is structured and tooled* — layout, config files, architecture decisions. It deliberately does **not** restate general Python style: type hints, docstrings, pathlib/IO, uv/ruff/ty usage, and lint/test commands all live in `~/.config/claude/docs/` (`python-style.md`, `python-project-ops.md`, `path-and-io.md`, `coding-principles.md`) — follow those.

## When to use

- Starting a new Python project from scratch.
- Setting up or fixing toolchain config: `pyproject.toml`, `.pre-commit-config.yaml`, `.envrc`.
- Choosing and wiring a config system / CLI.
- Writing `CLAUDE.md` / `README`.
- Aligning an existing repo to these conventions.

## Standard layout

```
<repo>/
├── src/                    # source — NO src/__init__.py (src is a dir, not a package)
├── configs/                 # Hydra config groups (only if using Hydra)
├── tests/
│   ├── conftest.py         # test-case loader / fixtures
│   └── data/               # snapshot/fixture files
├── data/                   # inputs (gitignored)
├── outputs/                # run artifacts (gitignored)
├── .envrc                  # `layout uv` (direnv)
├── .gitignore              # generated via gitignore.io (+ data/ outputs/)
├── .pre-commit-config.yaml
├── pyproject.toml          # project + ruff + ty config all live here
├── CLAUDE.md               # AGENTS.md may symlink to it
└── README.md               # + README.ja.md for shared/internal projects
```

Imports within `src/` are module-relative (`from metrics.bleu import ...`), or package-qualified when the project nests a named package under `src/` (e.g. `src/my_package/`).

## Templates

Copy from `templates/` and adapt — don't hand-write these:

- `templates/pyproject.toml` — canonical config with the full ruff `select`/`ignore` superset, ty, hatchling, uv. **Start here.** Set `name`/`description`/`dependencies`, then trim the ruff `select` list per project.
- `templates/.pre-commit-config.yaml` — pre-commit-hooks + ruff + ty. Copy it replacing every `rev: PLACEHOLDER` with recent pinned versions, then run `pre-commit autoupdate` to use the latest versions.
- `templates/envrc` — copy to the repo as `.envrc` (`layout uv` + commented API-key/secret placeholders). Only keep API keys and secres that are required in the repo. Make sure `.envrc` is gitignored.

There is no `.gitignore` template — fetch a fresh one from gitignore.io and append the project dirs:

```bash
wget -qO .gitignore "https://www.toptal.com/developers/gitignore/api/python,macos"  # change `python,macos` based on the working project type
```

## Config & CLI: pick the right tier

- **Simple tool / library** (one transform, few options): no CLI, or a thin **`argparse`** `cli.py`.
- **Experiment pipeline** (many swappable components, parameter sweeps): **Hydra** — `configs/` config groups, `@hydra.main(version_base=None, config_path="../configs", config_name="default")`, a `default.yaml` composing `base.yaml` + group defaults.

Don't reach for Hydra unless there are real config groups to compose.

## Data modeling & logging

- **`@dataclass(frozen=True)`** for plain internal data; **pydantic v2** `BaseModel` where validation/serialization matters (config, schemas, API payloads). Both coexist in one repo — pick per use.
- **Logging** via stdlib `logging` (`logger = logging.getLogger(__name__)`). `print` is fine for CLI output (the template ignores T201). `loguru` is not used.
- **Tests** favor a snapshot style: fixture files under `tests/data/` paired by stem and loaded in `conftest.py`. No custom `[tool.pytest]` config — defaults are enough.

## Docs conventions

- **CLAUDE.md** (English): Project Overview → Common Commands → Architecture → (Extension Points / Configuration for larger repos) → Code Style. Command-first and factual. `AGENTS.md` may symlink to it.
- **README.md**: title + one-line subtitle → setup (`uv sync`) → quickstart → configuration. Add **`README.ja.md`** with cross-links (`[English](README.md) | [日本語](README.ja.md)`) for shared/internal projects and keep both in sync.
- Commit messages: short, imperative, lowercase.
