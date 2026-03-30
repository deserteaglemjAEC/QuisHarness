# Codebase Summary

## File Inventory

**Total:** 38 files across 9 directories (~3,250 LOC)

| Directory | Files | LOC | Purpose |
|-----------|-------|-----|---------|
| `docs/` | 5 | 681 | Deep-dive documentation |
| `hooks/` | 4 | 210 | Hook templates and examples |
| `rules/common/` | 9 | 363 | Global coding rules |
| `scripts/` | 4 | 667 | Eval and diagnostic scripts |
| `skills/examples/` | 4 | 160 | Skill authoring patterns |
| `templates/` | 3 | 106 | Config templates (CLAUDE.md, settings, keybindings) |
| `output-styles/` | 1 | 13 | Response formatting presets |
| `research/` | 2 | 353 | Research artifacts |
| `ship/` | 1 | — | Ship log |
| Root | 4 | 484 | README, CONTRIBUTING, LICENSE, install.sh |

## Tech Stack

| Technology | Usage | Files |
|------------|-------|-------|
| **Bash 4+** | Install wizard, eval scripts, setup check | `install.sh`, `scripts/*.sh` |
| **Python 3** | Hook templates (stdlib only, no pip) | `hooks/*.py` |
| **Markdown** | Rules, docs, skills, templates | `rules/**/*.md`, `docs/*.md`, `skills/**/*.md` |
| **JSON** | Config templates | `templates/*.json` |

## Entry Points

| Entry Point | What It Does |
|-------------|-------------|
| `install.sh` | Main installer — backup, copy, create dirs, run eval |
| `install.sh --dry-run` | Preview mode — shows what would change |
| `scripts/eval-claude-directory.sh` | Score directory structure (/25) |
| `scripts/eval-skill-activation.sh` | Score skill description quality (/5 per skill) |
| `scripts/eval-composite.sh` | Combined setup score (percentage) |
| `scripts/setup-check.sh` | Diagnostic — verify prerequisites |

## Key Files

### Root

- **`install.sh`** (279 lines) — The install wizard. Handles backup, file copying, directory creation, and post-install eval. Supports `--dry-run` and `--force` flags.
- **`README.md`** (126 lines) — Hero doc with quickstart, component table, FAQ.
- **`CONTRIBUTING.md`** (71 lines) — Contribution guide covering rules, hooks, evals, docs.

### Rules (`rules/common/`)

Nine rule files covering coding standards, Git workflow, security, testing, patterns, performance, hooks, agents, and coding style. Each file is < 200 lines and covers a single topic.

### Hook Templates (`hooks/`)

- **`memory-context.py`** — SessionStart hook that injects project context
- **`examples/prompt-improver.py`** — UserPromptSubmit hook for prompt classification
- **`examples/skill-activation.sh.example`** — UserPromptSubmit hook for skill routing

### Skill Examples (`skills/examples/`)

Three patterns: trigger-based activation, evolved skills with resources, and rich skills with reference documents.

### Templates

- **`CLAUDE.md`** — Optimized global instruction file (< 200 lines)
- **`settings-example.json`** — Settings with hooks configured
- **`keybindings.json`** — Custom keyboard shortcuts

## Dependencies

**None.** QuisHarness has zero external dependencies:

- Bash 4+ (macOS may need `brew install bash`)
- Python 3 standard library (no pip packages)
- Git (for cloning)
- Claude Code CLI (the tool being configured)

## Build & Install

No build step. Installation is:

```bash
git clone https://github.com/deserteaglemjAEC/QuisHarness.git
cd QuisHarness
bash install.sh
```
