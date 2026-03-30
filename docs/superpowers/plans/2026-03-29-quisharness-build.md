# QuisHarness Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Package an optimized `~/.claude/` setup as a public open-source framework that anyone can install in 5 minutes.

**Architecture:** Static framework — shell scripts, markdown templates, and a copy-based installer. No runtime dependencies, no build step, no package manager. Users clone the repo and run `bash install.sh`.

**Tech Stack:** Bash (install wizard + evals), Python 3 (hook templates), Markdown (docs + templates)

---

## Skill Orchestration (execution order)

| Step | Skill | Tasks Covered | Purpose |
|------|-------|---------------|---------|
| 1 | `superpowers:writing-plans` | — | Produce this structured plan (DONE) |
| 2 | [USER] Review + approve plan | — | Gate before execution |
| 3 | `superpowers:execute-plan` | Tasks 1-6 | Foundation, rules, templates, evals, hooks, skill examples |
| 4 | `engineering:documentation` | Task 7 | Write 5 docs files + hooks/README with developer-docs quality |
| 5 | `superpowers:execute-plan` (continue) | Tasks 8-9 | Install wizard + README.md |
| 6 | `superpowers:verification-before-completion` | Task 10 | Clean install test, personal data scan, link validation |
| 7 | `superpowers:finishing-a-development-branch` | Task 11 | Clean commits, push to GitHub |

**Skills explicitly NOT used (and why):**
- `superpowers:brainstorming` — Already completed (name, scope, 5 decisions locked)
- `superpowers:test-driven-development` — Eval scripts ARE the tests; TDD for markdown + shell is over-engineering
- `anthropic-skills:skill-creator` / `superpowers:writing-skills` — Example skills are templates showing patterns, not functional skills
- `autoresearch:*` — Source materials already exist, no research phase needed
- `marketing:*` / `searchfit-seo:*` — Launch content is a separate session per the handoff
- `impeccable:distill` — README needs to be punchy but this is developer docs, not UI copy

---

## DO NOT COPY List

These source files contain personal data and must NEVER be copied as-is:
- `~/.claude/rules/common/plugin-routing.md` — contains "marquis" references
- `~/.claude/hooks/supermemory-search.py` — contains API key retrieval logic
- `~/.claude/hooks/skill-activation.js` — 429 lines with client names, vault paths, brand-specific skill lists
- `~/.claude/hooks/prompt-improver.py` — personal prompt patterns
- `~/.claude/scripts/pool-loader.py` — personal instance pool
- `~/.claude/scripts/context-router-v2.py` — personal context routing
- Any file in `~/.claude/hooks/` not explicitly listed in the File Map below

---

## File Map

| File | Responsibility | Source |
|------|---------------|--------|
| `.gitignore` | Create new | Standard ignores |
| `LICENSE` | Create new | MIT |
| `CONTRIBUTING.md` | Create new | Standard OSS template |
| `install.sh` | Create new | Setup wizard |
| `README.md` | Create new | Hero doc |
| `templates/CLAUDE.md` | Generalize from `~/.claude/CLAUDE.md` | Strip personal data, add placeholders |
| `templates/settings-example.json` | Create new | Example with comments |
| `templates/keybindings.json` | Copy from `~/.claude/keybindings.json` | No changes needed |
| `rules/common/*.md` (9 files) | Copy from `~/.claude/rules/common/` | Merge git.md + git-workflow.md; skip plugin-routing.md |
| `hooks/README.md` | Create new | Hook architecture docs |
| `hooks/memory-context.py` | Generalize from `~/.claude/hooks/supermemory-context.py` | Strip client names |
| `hooks/examples/skill-activation.sh.example` | Based on `~/.claude/hooks/skill-activation.sh` | Documentation-only (see CRITICAL-2 fix) |
| `hooks/examples/prompt-improver.py` | Create new (NOT copied from source) | Skeleton showing UserPromptSubmit pattern |
| `scripts/eval-claude-directory.sh` | Generalize from `~/.claude/scripts/eval-claude-directory.sh` | Fix assertions #10 and #15 |
| `scripts/eval-skill-activation.sh` | Copy from `~/.claude/scripts/eval-skill-activation.sh` | No changes needed |
| `scripts/eval-composite.sh` | Generalize from `~/.claude/scripts/eval-composite.sh` | Heavy generalization (see Task 4) |
| `scripts/setup-check.sh` | Create new | Pre-install diagnostic |
| `skills/examples/trigger-pattern.md` | Create new | Based on quality-gates pattern |
| `skills/examples/evolved-skill.md` | Create new | Based on session-continuity pattern |
| `skills/examples/rich-skill/SKILL.md` | Create new | Based on research-workflow pattern |
| `skills/examples/rich-skill/resources/example-ref.md` | Create new | Shows resources/ convention |
| `output-styles/brief.md` | Copy from `~/.claude/output-styles/brief.md` | No changes needed |
| `docs/mental-model.md` | Create new | How Claude Code actually works |
| `docs/directory-guide.md` | Create new | ASCII layout diagrams |
| `docs/hook-patterns.md` | Create new | Hook architecture patterns |
| `docs/eval-guide.md` | Create new | How to use/extend evals |
| `docs/plugin-evaluation.md` | Create new | Plugin evaluation framework |

---

## Task 1: Repo Foundation

**Files:**
- Create: `.gitignore`
- Create: `LICENSE`
- Create: `CONTRIBUTING.md`

- [ ] **Step 1: Create .gitignore**

```
node_modules/
.env
.env.*
.DS_Store
__pycache__/
*.pyc
.claude/
*.bak
```

- [ ] **Step 2: Create LICENSE (MIT)**

Standard MIT license with `2026 Marquis Wilson (@deserteaglemj)`.

- [ ] **Step 3: Create CONTRIBUTING.md**

Standard open-source contribution guide: fork, branch, PR workflow. Include: how to run evals before submitting, how to add new rule files, how to propose new hook patterns. Mention `shellcheck` for shell script contributions.

- [ ] **Step 4: Commit foundation**

```bash
git add .gitignore LICENSE CONTRIBUTING.md
git commit -m "chore: repo foundation — license, gitignore, contributing guide"
```

---

## Task 2: Rules (Direct Copy)

**Files:**
- Create: `rules/common/coding-standards.md`
- Create: `rules/common/coding-style.md`
- Create: `rules/common/git.md` (merged from git.md + git-workflow.md)
- Create: `rules/common/security.md`
- Create: `rules/common/testing.md`
- Create: `rules/common/patterns.md`
- Create: `rules/common/performance.md` (generalize model versions)
- Create: `rules/common/hooks.md`
- Create: `rules/common/agents.md`

- [ ] **Step 1: Copy 8 rule files directly**

Copy these as-is from `~/.claude/rules/common/`: coding-standards.md, coding-style.md, security.md, testing.md, patterns.md, hooks.md, agents.md. No personal data in any of them (verified during exploration).

**DO NOT copy:** `plugin-routing.md` (contains "marquis" references).

- [ ] **Step 2: Generalize performance.md**

Copy from source, then replace specific model version references (Haiku 4.5, Sonnet 4.5, Opus 4.5) with relative terms: "lightweight model", "default coding model", "reasoning model". Add a "Last verified: 2026-03" date note so users know to check for newer models.

- [ ] **Step 3: Merge git.md + git-workflow.md into single git.md**

Source files overlap (both cover commit format, branching). Merge into one `rules/common/git.md` with sections: Commit Format, Rules, Branching, Pull Request Workflow, Feature Implementation Workflow.

- [ ] **Step 4: Verify no personal data leaked**

```bash
grep -ri "HOLSTC\|Undrdog\|Betterbrand\|kinetide\|marquis\|TSP\|tsp-" rules/
```

Expected: 0 results.

- [ ] **Step 5: Commit rules**

```bash
git add rules/
git commit -m "feat: add common rules — coding standards, git, security, testing, patterns"
```

---

## Task 3: Templates (CLAUDE.md, settings, keybindings)

**NOTE:** Templates come BEFORE eval scripts because eval assertions must match the template content.

**Files:**
- Create: `templates/CLAUDE.md`
- Create: `templates/settings-example.json`
- Create: `templates/keybindings.json` (copy)

- [ ] **Step 1: Create templates/CLAUDE.md**

Generalized version of `~/.claude/CLAUDE.md`. Keep these sections with placeholders:
- **Security** — generalize (keep ANTHROPIC_API_KEY warning, remove SuperMemory-specific rules)
- **Tool Usage Priority** — copy as-is (universal)
- **Agent Auto-Launch Rules** — keep table structure, replace specific skill names with `{your-skill}` placeholders
- **Planning Discipline** — copy as-is (universal)
- **Context Front-Loading** — generalize (remove MEMORY.md specifics, keep the principle)
- **Session Continuity** — generalize (replace vault paths with `{your-notes-dir}`)

**REMOVE entirely:**
- File System Map (personal paths)
- SuperMemory section (optional enhancement)
- Plugin Preference table (plugin-agnostic per decision)
- Plugin & Skill Management section
- Any client/project names
- Cost-Benefit Analysis Protocol (too specific to author's workflow)

Keep under 200 lines (matching the eval assertion).

**Record which section headers exist** — eval-composite.sh assertions must match these headers.

- [ ] **Step 2: Create templates/settings-example.json**

```json
{
  "$schema": "https://www.schemastore.org/claude-code-settings.json",
  "enabledPlugins": {},
  "hooks": {
    "SessionStart": [],
    "PreToolUse": [],
    "PostToolUse": [],
    "UserPromptSubmit": []
  },
  "env": {
    "PYTHONDONTWRITEBYTECODE": "1"
  }
}
```

Add comments above each section explaining purpose. Note in README that this is NOT auto-installed (users merge manually).

- [ ] **Step 3: Copy keybindings.json**

Copy from `~/.claude/keybindings.json` as-is (generic, no personal data).

- [ ] **Step 4: Verify no personal data**

```bash
grep -ri "HOLSTC\|Undrdog\|Betterbrand\|kinetide\|marquis\|vault\|iCloud\|obsidian\|TSP\|tsp-\|deserteaglemj" templates/
```

Expected: 0 results.

- [ ] **Step 5: Commit templates**

```bash
git add templates/
git commit -m "feat: add templates — CLAUDE.md, settings example, keybindings"
```

---

## Task 4: Eval Scripts

**NOTE:** Runs AFTER Task 3 so eval assertions can be aligned with the CLAUDE.md template.

**Files:**
- Create: `scripts/eval-claude-directory.sh` (generalize)
- Create: `scripts/eval-skill-activation.sh` (copy)
- Create: `scripts/eval-composite.sh` (heavy generalization)
- Create: `scripts/setup-check.sh` (new)

- [ ] **Step 1: Generalize eval-claude-directory.sh**

Copy from `~/.claude/scripts/eval-claude-directory.sh` then fix:
- **Lines 80-85 (Assertion #10):** Replace `research-workflow` hardcoded check with generic "at least 1 skill has an eval/ or resources/ subdirectory"
- **Lines 111-113 (Assertion #15):** Replace `supermemory*` file check with generic "has at least 1 SessionStart hook file (.sh or .py) in hooks/"

- [ ] **Step 2: Copy eval-skill-activation.sh as-is**

169 lines. No personal data. Copy from `~/.claude/scripts/eval-skill-activation.sh`.

- [ ] **Step 3: Generalize eval-composite.sh (comprehensive)**

Copy from `~/.claude/scripts/eval-composite.sh` then fix ALL of these:
- **Lines 101-103 (#28):** Replace `supermemory*` check with generic "has at least 1 Python hook in hooks/"
- **Lines 110-115 (#30):** Replace `supermemory-context.py` latency test with test against any `.py` hook file
- **Lines 117-118 (#31):** Replace `get_project_slug` grep in `supermemory-context.py` with generic "has project-scoping logic in any hook"
- **Lines 128-140 (#34-40):** Replace hardcoded filenames (`supermemory-context.py`, `load-reflections.sh`, `pool-loader.py`) with dynamic discovery of first 3 hook files
- **Lines 143-156 (#41):** Replace `supermemory-search.py` and other specific filenames with dynamic hook discovery
- **Lines 238-241 (#46-49):** Replace specific plugin key checks with generic "has >= 4 enabled plugins"
- **Line 251 (#51):** Replace `grep -q 'File System Map'` with `grep -qi 'security\|tool usage'` (sections that exist in the generalized template)
- **Line 258 (#54):** Replace `grep -q 'SuperMemory'` with `grep -qi 'memory\|context\|knowledge'`
- **Line 272 (#58):** Replace `grep -q 'project-{slug}'` with `grep -qi 'session\|continuity\|handoff'`

- [ ] **Step 4: Create setup-check.sh (new)**

Pre-install diagnostic script:
1. Check OS (macOS/Linux)
2. Check Bash version (warn if < 4 on macOS, suggest `brew install bash`)
3. Check if `~/.claude/` exists
4. Check if Claude Code CLI is installed (`which claude`)
5. If `~/.claude/` exists, run `eval-claude-directory.sh` and show "Before" score
6. Print recommendations

- [ ] **Step 5: Make all scripts executable and verify**

```bash
chmod +x scripts/*.sh
bash scripts/eval-claude-directory.sh  # Should run without errors
```

- [ ] **Step 6: Verify no personal data in scripts**

```bash
grep -ri "HOLSTC\|Undrdog\|Betterbrand\|kinetide\|supermemory\|research-workflow\|pool-loader\|context-router" scripts/
```

Expected: 0 results.

- [ ] **Step 7: Commit eval scripts**

```bash
git add scripts/
git commit -m "feat: add eval scripts — directory, skill activation, composite, setup check"
```

---

## Task 5: Hook Templates

**Files:**
- Create: `hooks/README.md`
- Create: `hooks/memory-context.py`
- Create: `hooks/examples/skill-activation.sh.example` (documentation-only)
- Create: `hooks/examples/prompt-improver.py`

- [ ] **Step 1: Create memory-context.py (templated from supermemory-context.py)**

Copy `~/.claude/hooks/supermemory-context.py` then:
- Rename to `memory-context.py`
- Replace `PROJECT_MAP` contents with placeholder examples:
  ```python
  PROJECT_MAP = {
      "my-saas-app": "saas",
      "client-website": "client-site",
      "personal-blog": "blog",
  }
  ```
- Strip ALL references to HOLSTC, Undrdog, Betterbrand, kinetide
- Add comments explaining how to customize for your own projects
- Keep the `get_project_slug()` pattern intact — that's the value
- Remove the `check_reflect_due()` function (SuperMemory-specific)
- Replace SuperMemory MCP tool names in `build_reminder()` with generic `{your_memory_tool}` placeholders

- [ ] **Step 2: Create skill-activation.sh.example (documentation-only)**

Based on `~/.claude/hooks/skill-activation.sh` but renamed to `.example` extension. Add header comment block explaining:
- This is a PATTERN showing how to wrap a Node.js hook with PATH augmentation
- The referenced `skill-activation.js` is NOT included (it is project-specific)
- Users should write their own JS/Python skill activation logic
- The key pattern: `export PATH` for non-interactive shells + delegate to the real script

**Do NOT ship it as runnable** — it would error with `MODULE_NOT_FOUND`.

- [ ] **Step 3: Create prompt-improver.py skeleton**

Create from scratch (NOT copied from source file). Shows the UserPromptSubmit hook pattern:
- Reads stdin (JSON with user prompt)
- Classifies prompt as CONVERSATIONAL vs TASK
- Returns additionalContext with classification
- Heavy comments explaining the pattern, NOT a full implementation
- No personal conventions or project-specific logic

- [ ] **Step 4: Create hooks/README.md**

Explains: what hooks are, the 4 hook types (SessionStart, PreToolUse, PostToolUse, UserPromptSubmit), how settings.json configures them, the matchers system, when to use each type, link to docs/hook-patterns.md for deeper patterns.

- [ ] **Step 5: Verify no personal data**

```bash
grep -ri "HOLSTC\|Undrdog\|Betterbrand\|kinetide\|marquis\|TSP\|tsp-\|deserteaglemj\|vault\|obsidian" hooks/
```

Expected: 0 results. Also verify "supermemory" only appears in comments explaining template origin:

```bash
grep -ri "supermemory" hooks/ | grep -v "^.*#.*supermemory\|^.*comment\|^.*based on"
```

Expected: 0 results (all supermemory mentions are in comments only).

- [ ] **Step 6: Commit hooks**

```bash
git add hooks/
git commit -m "feat: add hook templates — memory context, skill activation example, prompt improver"
```

---

## Task 6: Skill Examples + Output Styles

**Files:**
- Create: `skills/examples/trigger-pattern.md`
- Create: `skills/examples/evolved-skill.md`
- Create: `skills/examples/rich-skill/SKILL.md`
- Create: `skills/examples/rich-skill/resources/example-ref.md`
- Create: `output-styles/brief.md` (copy)

- [ ] **Step 1: Create trigger-pattern.md**

Based on quality-gates SKILL.md structure. Generic example showing:
- YAML frontmatter with name + description
- Description with "Use when" and "Triggers on" phrases
- 3+ trigger keywords
- Body with rules/workflow

Topic: a generic "code-review-checklist" skill (universal, not project-specific).

- [ ] **Step 2: Create evolved-skill.md**

Based on session-continuity SKILL.md. Shows:
- `evolved_from` array (list of precursor skills)
- `confidence` score
- `evolved` date
- Body explaining the pattern

Topic: a generic "session-handoff" skill.

- [ ] **Step 3: Create rich-skill/ directory**

Based on research-workflow pattern:
- `SKILL.md` with `allowed-tools` in frontmatter
- `resources/example-ref.md` as a reference document
- Shows the convention of skills having subdirectories for supporting content

Topic: a generic "deep-research" skill.

- [ ] **Step 4: Copy output-styles/brief.md**

Copy from `~/.claude/output-styles/brief.md` as-is (14 lines, no personal data).

- [ ] **Step 5: Commit skill examples and output styles**

```bash
git add skills/ output-styles/
git commit -m "feat: add skill examples and output styles"
```

---

## Task 7: Documentation (use engineering:documentation skill)

**Files:**
- Create: `docs/mental-model.md`
- Create: `docs/directory-guide.md`
- Create: `docs/hook-patterns.md`
- Create: `docs/eval-guide.md`
- Create: `docs/plugin-evaluation.md`

**Skill:** Invoke `engineering:documentation` for this task to ensure developer-docs quality.

- [ ] **Step 1: Create docs/mental-model.md**

"How Claude Code Actually Works" — the research findings from the optimization sessions:
- Claude Code's context assembly pipeline (CLAUDE.md -> rules -> skills -> hooks -> plugins)
- How skill activation works (description matching, not file paths)
- The attention budget concept (why fewer, better skills > many mediocre ones)
- Hook execution model (synchronous, latency-sensitive)
- The "waiter, not a library" mental model

- [ ] **Step 2: Create docs/directory-guide.md**

ASCII diagrams showing:
- Default `~/.claude/` layout (what you get out of the box)
- Optimized layout (what QuisHarness gives you)
- Explanation of each directory's purpose
- File size guidelines (CLAUDE.md < 200 lines, skills < 500 lines, rules < 200 lines)

- [ ] **Step 3: Create docs/hook-patterns.md**

Common hook architectures:
- **SessionStart**: context injection, memory loading, environment detection
- **PreToolUse**: validation, parameter augmentation, security checks
- **PostToolUse**: auto-formatting, logging, verification
- **UserPromptSubmit**: prompt classification, context routing, skill activation
- Each with skeleton code (bash + python) and when-to-use guidance

- [ ] **Step 4: Create docs/eval-guide.md**

How to use and extend the evals:
- Running each eval script
- Interpreting scores (what each assertion checks)
- Adding custom assertions
- Using evals in CI (teaser for v1.1)
- Common failure patterns and fixes
- Expected scores for fresh install (document which assertions naturally fail without skills/plugins)

- [ ] **Step 5: Create docs/plugin-evaluation.md**

Framework for evaluating plugins (plugin-agnostic per design decision):
- Activation noise: does it fire on irrelevant prompts?
- Context cost: how much context window does it consume?
- Overlap detection: does it duplicate another plugin's coverage?
- Update frequency: is it maintained?
- Permission scope: what tools does it need?
- The "10-25 plugins sweet spot" guideline

- [ ] **Step 6: Commit documentation**

```bash
git add docs/
git commit -m "docs: add mental model, directory guide, hook patterns, eval guide, plugin evaluation"
```

---

## Task 8: Install Wizard

**Files:**
- Create: `install.sh`

- [ ] **Step 1: Write install.sh**

Simple copy script:
1. Print banner ("QuisHarness Installer")
2. Check prerequisites: warn if Bash < 4 on macOS (suggest `brew install bash`), check `~/.claude/` exists (warn if not, offer to create)
3. Support flags: `--yes` (non-interactive), `--dry-run` (show what would be copied without doing it)
4. Backup existing files: `CLAUDE.md -> CLAUDE.md.bak.{date}`, `settings.json -> settings.json.bak.{date}`
5. Copy `templates/CLAUDE.md` -> `~/.claude/CLAUDE.md`, `templates/keybindings.json` -> `~/.claude/keybindings.json`
6. **Do NOT copy settings-example.json** — note this in output ("Review templates/settings-example.json and merge manually")
7. **Do NOT copy hooks/** — note this in output ("See hooks/ for hook templates to customize and install")
8. Copy `rules/` -> `~/.claude/rules/`
9. Copy `scripts/` -> `~/.claude/scripts/`
10. Create missing dirs: `agent-memory/`, `output-styles/`, `warnings/`, `skills/`
11. Copy `output-styles/` -> `~/.claude/output-styles/`
12. Run `eval-claude-directory.sh` and show score
13. Print "Next steps":
    - Review and merge `templates/settings-example.json` into your `~/.claude/settings.json`
    - Customize `hooks/memory-context.py` and install to `~/.claude/hooks/`
    - Install community plugins (`claude plugin install <name>`)
    - Run `bash ~/.claude/scripts/eval-composite.sh` for a full score

Each copy step should ask for confirmation (simple y/n) unless `--yes` is passed.

- [ ] **Step 2: Make executable and test**

```bash
chmod +x install.sh
bash install.sh --help  # Should print usage with --yes and --dry-run flags
```

- [ ] **Step 3: Commit install wizard**

```bash
git add install.sh
git commit -m "feat: add install wizard — backup, copy, create dirs, run eval"
```

---

## Task 9: README.md

**Files:**
- Create: `README.md`

- [ ] **Step 1: Write README.md**

Sections (hub-and-spoke — link to docs/ for depth):

1. **Hero**: Project name, one-liner tagline, eval score badge concept
2. **What This Is**: One paragraph + link to `docs/mental-model.md`
3. **Before/After**: ASCII comparison of default vs optimized `~/.claude/`
4. **Quick Start**: `git clone` -> `bash install.sh` (3 lines) + note about post-install steps (settings merge, hook setup)
5. **What's Included**: Table of components (templates, rules, evals, hooks, skill examples, docs)
6. **Eval Your Setup**: How to run each eval, what scores mean
7. **How to Evaluate Plugins**: Overview + link to `docs/plugin-evaluation.md`
8. **Hook Architecture**: Overview + link to `docs/hook-patterns.md`
9. **Prerequisites**: Claude Code CLI installed, Bash (macOS users: `brew install bash` for Bash 4+)
10. **FAQ**: "Is this a plugin?" / "Does it require SuperMemory?" / "Will this overwrite my config?" / "How do I customize?" / "Why doesn't install.sh copy settings.json?"
11. **Contributing**: Link to `CONTRIBUTING.md`
12. **License**: MIT

- [ ] **Step 2: Verify all relative links work**

Check every `[text](docs/...)` and `[text](hooks/...)` link points to a real file.

- [ ] **Step 3: Commit README**

```bash
git add README.md
git commit -m "docs: add README — hero doc, quickstart, component table, FAQ"
```

---

## Task 10: Verification (use superpowers:verification-before-completion)

**Skill:** Invoke `superpowers:verification-before-completion` for this task.

- [ ] **Step 1: Personal data scan (comprehensive)**

```bash
# Client names
grep -ri "HOLSTC\|Undrdog\|Betterbrand\|kinetide" . --include='*.md' --include='*.sh' --include='*.py' --include='*.json'

# Author name outside LICENSE/README/CONTRIBUTING
grep -ri "marquis\|deserteaglemj" . --include='*.md' --include='*.sh' --include='*.py' --include='*.json' | grep -v "LICENSE\|README\|CONTRIBUTING\|\.git/"

# Personal paths
grep -ri "vault\|iCloud\|obsidian\|TSP\|tsp-" . --include='*.md' --include='*.sh' --include='*.py' --include='*.json' | grep -v "\.git/"

# SuperMemory in code (not comments)
grep -ri "supermemory" . --include='*.sh' --include='*.py' | grep -v "^.*#"

# Specific personal scripts that should not be referenced
grep -ri "pool-loader\|context-router\|supermemory-search\|research-workflow" scripts/
```

Expected: 0 results for all scans.

- [ ] **Step 2: File size check**

```bash
find . -name '*.md' -o -name '*.sh' -o -name '*.py' -o -name '*.json' | grep -v .git | xargs wc -l | sort -rn | head -20
```

Expected: No file > 800 lines.

- [ ] **Step 3: Clean install test**

```bash
export TEST_HOME=$(mktemp -d)
mkdir -p "$TEST_HOME/.claude"
HOME="$TEST_HOME" bash install.sh --yes
HOME="$TEST_HOME" bash "$TEST_HOME/.claude/scripts/eval-claude-directory.sh"
```

Expected: Install completes without errors. Eval scores ~17-19/25 (assertions #6, #7, #9, #11 will fail because fresh install has no skills or hooks — this is expected and documented in eval-guide.md).

- [ ] **Step 4: Dry-run test**

```bash
bash install.sh --dry-run
```

Expected: Shows what would be copied/created without modifying anything. Exits cleanly.

- [ ] **Step 5: Link validation**

Check all relative links in README.md and docs/ point to existing files.

- [ ] **Step 6: Script executability**

```bash
ls -la scripts/*.sh install.sh  # All should have +x
```

- [ ] **Step 7: Bash 3.2 compatibility spot-check**

```bash
# Verify no associative arrays (declare -A) which require Bash 4
grep -rn "declare -A" scripts/ install.sh
```

Expected: 0 results. If found, refactor to use indexed arrays or alternative.

---

## Task 11: Git Finalization (use superpowers:finishing-a-development-branch)

**Skill:** Invoke `superpowers:finishing-a-development-branch` for this task.

- [ ] **Step 1: [USER] Create GitHub repo named QuisHarness**

Create at `github.com/deserteaglemjAEC/QuisHarness`.

- [ ] **Step 2: [USER] Set remote**

```bash
git remote add origin git@github.com:deserteaglemjAEC/QuisHarness.git
```

Or rename existing remote if one exists.

- [ ] **Step 3: Verify git log**

```bash
git log --oneline
```

Expected: ~9 clean commits (one per task).

- [ ] **Step 4: [USER] Push to GitHub**

```bash
git push -u origin main
```

---

## Risk Mitigation

| Risk | Mitigation |
|------|-----------|
| Personal data leaks into public repo | Comprehensive grep scan in Task 10 + per-task verification steps + DO NOT COPY list |
| eval scripts break after generalization | Write assertions AFTER templates (Task 3 before Task 4) + clean install test |
| install.sh overwrites user's real config | Backup step + confirmation prompts + --dry-run flag + skip settings.json |
| skill-activation.sh crashes on missing .js | Shipped as .example (documentation-only, not runnable) |
| macOS Bash 3.2 incompatibility | Bash version warning in install.sh + brew suggestion in README |
| eval scores confusingly low on fresh install | Expected failures documented in eval-guide.md |
| Model versions in performance.md become stale | Replaced with relative terms + "last verified" date |
| README too long/boring | Hub-and-spoke design keeps it scannable |
