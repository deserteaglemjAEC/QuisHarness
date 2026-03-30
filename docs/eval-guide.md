# Eval Guide

How to use, interpret, and extend the QuisHarness evaluation scripts.

## Quick Start

```bash
# Score your directory structure (25 points)
bash ~/.claude/scripts/eval-claude-directory.sh

# Score your skill descriptions (per-skill quality)
bash ~/.claude/scripts/eval-skill-activation.sh

# Full composite score (everything combined)
bash ~/.claude/scripts/eval-composite.sh

# Pre-install diagnostic
bash scripts/setup-check.sh
```

## eval-claude-directory.sh (25 points)

Scores your `~/.claude/` directory organization across 5 categories.

### Categories

| Category | Points | What It Checks |
|----------|--------|---------------|
| Structure | 5 | CLAUDE.md exists and < 200 lines, settings.json, keybindings, output-styles, agent-memory |
| Skills | 5 | 10-30 skills, all have SKILL.md, none > 500 lines, has resources/, has rich subdirectories |
| Hooks | 5 | >= 5 hooks, no ANTHROPIC_API_KEY refs, no __pycache__, no dead refs, has script hooks |
| Rules | 5 | rules/ exists, >= 3 files, none > 200 lines, common/ exists, CLAUDE.md compact |
| Hygiene | 5 | No .bak files, no __pycache__, debug/ clean, no stale dirs, root < 15 files |

### Rating Scale

| Score | Rating | Meaning |
|-------|--------|---------|
| 25/25 | 10/10 | Perfect — fully optimized |
| 23-24 | 9/10 | Excellent — minor gaps |
| 20-22 | 8/10 | Good — some areas need attention |
| 17-19 | 7/10 | Decent — several improvements available |
| < 17 | < 7 | Needs work — run through the directory guide |

### Fresh Install Expectations

After running `install.sh` on a new setup, expect ~17-19/25. These assertions will naturally fail without additional setup:

- **#6** (10-30 skills): Fresh install has 0 skills. Install plugins to add them.
- **#7** (all skills have SKILL.md): No skills to check.
- **#9** (resources/ directory): No skills yet.
- **#11** (>= 5 hooks): Fresh install has 0-2 hooks. Add hook scripts.

This is expected. The eval shows you WHERE to improve next.

## eval-skill-activation.sh (per-skill quality)

Scores each skill's description for activation reliability.

### Scoring (0-5 per skill)

| Point | Criteria | Why It Matters |
|-------|----------|---------------|
| +1 | Description exists and > 10 chars | Basic requirement |
| +1 | Has "Use when" or "Triggers on" phrases | Explicit activation signals |
| +1 | Description is 50-500 chars | Not too short, not too verbose |
| +1 | Has >= 3 trigger keywords/phrases | Multiple activation paths |
| +1 | Has >= 2 unique terms (not in other skills) | Differentiates from similar skills |

### Interpreting Results

- **5/5**: Perfect — skill activates reliably and doesn't conflict with others
- **3-4/5**: Good — minor improvements possible
- **< 3/5**: Needs rewriting — skill may not activate when expected

The script only shows details for non-perfect scores, making it easy to find what needs work.

## eval-composite.sh (unified score)

Combines everything into a single percentage score.

### Sections

| Section | Points | Covers |
|---------|--------|--------|
| Structure | 10 | Directory organization and hygiene |
| Skills | 15 | Count, quality, SKILL.md presence + activation quality (scaled) |
| Hooks | 10 | Count, security, latency, __pycache__ |
| Plugins | 10 | Count, no duplicates, no stale plugins |
| CLAUDE.md Quality | 10 | Key sections present (security, planning, context, etc.) |

### Target Scores

| Score | Meaning |
|-------|---------|
| 90%+ | Elite — fully optimized setup |
| 80-89% | Strong — well-configured with minor gaps |
| 70-79% | Good — solid foundation, room for improvement |
| < 70% | Needs attention — review the directory guide |

## Adding Custom Assertions

To add your own checks to any eval script:

```bash
# Pattern: increment PASS on success, print result either way
if [ YOUR_CONDITION ]; then
  ((PASS++)); echo "N. PASS — description"
else
  echo "N. FAIL — description (fix: what to do)"
fi
```

Remember to update `TOTAL` at the top of the script to match your new assertion count.

## Running in CI (v1.1)

A future release will include `eval-ci.yml` for GitHub Actions. The pattern:

```yaml
- name: Eval Claude Directory
  run: bash scripts/eval-claude-directory.sh
  # Assert minimum score
```
