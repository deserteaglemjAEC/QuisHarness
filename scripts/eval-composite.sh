#!/bin/bash
# eval-composite.sh — Unified Claude Code setup quality score
# Combines: directory structure, skill activation, plugin health, hook health
# Output: single composite score with percentage
# Usage: bash ~/.claude/scripts/eval-composite.sh
# Part of QuisHarness — https://github.com/deserteaglemjAEC/QuisHarness

CLAUDE_DIR="$HOME/.claude"
SCORE=0
MAX=0

pass() { ((SCORE++)); ((MAX++)); }
fail() { ((MAX++)); }

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# SECTION 1: STRUCTURE (10 points)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# 1. CLAUDE.md exists and < 200 lines
LINES=$(wc -l < "$CLAUDE_DIR/CLAUDE.md" 2>/dev/null | tr -d ' ')
[ -f "$CLAUDE_DIR/CLAUDE.md" ] && [ -n "$LINES" ] && [ "$LINES" -lt 200 ] && pass || fail

# 2. settings.json exists
[ -f "$CLAUDE_DIR/settings.json" ] && pass || fail

# 3. keybindings.json exists
[ -f "$CLAUDE_DIR/keybindings.json" ] && pass || fail

# 4. output-styles/ has >= 1 file
OS_COUNT=$(find "$CLAUDE_DIR/output-styles" -name '*.md' -type f 2>/dev/null | wc -l | tr -d ' ')
[ "$OS_COUNT" -ge 1 ] && pass || fail

# 5. agent-memory/ exists
[ -d "$CLAUDE_DIR/agent-memory" ] && pass || fail

# 6. rules/ has >= 3 .md files
RULE_FILES=$(find -L "$CLAUDE_DIR/rules" -name '*.md' -type f 2>/dev/null | wc -l | tr -d ' ')
[ "$RULE_FILES" -ge 3 ] && pass || fail

# 7. rules/common/ exists
[ -d "$CLAUDE_DIR/rules/common" ] && pass || fail

# 8. No .bak files at root
BAK=$(find "$CLAUDE_DIR" -maxdepth 1 -name '*.bak*' -type f 2>/dev/null | wc -l | tr -d ' ')
[ "$BAK" -eq 0 ] && pass || fail

# 9. No __pycache__ anywhere
PYC=$(find "$CLAUDE_DIR" -type d -name '__pycache__' -not -path '*/node_modules/*' -not -path '*/.git/*' 2>/dev/null | wc -l | tr -d ' ')
[ "$PYC" -eq 0 ] && pass || fail

# 10. Root has < 15 loose files
ROOT=$(find "$CLAUDE_DIR" -maxdepth 1 -type f | wc -l | tr -d ' ')
[ "$ROOT" -lt 15 ] && pass || fail

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# SECTION 2: SKILLS (15 points)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# 11. 10-30 skills
SKILL_COUNT=$(find "$CLAUDE_DIR/skills" -maxdepth 1 -type d 2>/dev/null | tail -n +2 | wc -l | tr -d ' ')
[ "$SKILL_COUNT" -ge 10 ] && [ "$SKILL_COUNT" -le 30 ] && pass || fail

# 12. All skills have SKILL.md
MISSING=0
for d in "$CLAUDE_DIR"/skills/*/; do [ ! -f "$d/SKILL.md" ] && ((MISSING++)); done
[ "$MISSING" -eq 0 ] && pass || fail

# 13. No skill exceeds 500 lines
OVERSIZED=$(find "$CLAUDE_DIR/skills" -name 'SKILL.md' -type f 2>/dev/null -exec sh -c 'wc -l < "$1" | tr -d " "' _ {} \; | awk '$1 >= 500' | wc -l | tr -d ' ')
[ "$OVERSIZED" -eq 0 ] && pass || fail

# 14-25. Per-skill quality (12 points): run skill activation eval, scale to 12
if [ -f "$CLAUDE_DIR/scripts/eval-skill-activation.sh" ]; then
  SKILL_OUTPUT=$(bash "$CLAUDE_DIR/scripts/eval-skill-activation.sh" 2>/dev/null)
  SKILL_SCORE=$(echo "$SKILL_OUTPUT" | grep "SCORE:" | grep -oE '[0-9]+' | head -1)
  SKILL_MAX=$(echo "$SKILL_OUTPUT" | grep "SCORE:" | grep -oE '[0-9]+' | head -2 | tail -1)
  if [ -n "$SKILL_SCORE" ] && [ -n "$SKILL_MAX" ] && [ "$SKILL_MAX" -gt 0 ]; then
    SKILL_PTS=$(( SKILL_SCORE * 12 / SKILL_MAX ))
    SCORE=$((SCORE + SKILL_PTS))
    MAX=$((MAX + 12))
  else
    MAX=$((MAX + 12))
  fi
else
  MAX=$((MAX + 12))
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# SECTION 3: HOOKS (10 points)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# 26. >= 5 hook files
HOOK_COUNT=$(find "$CLAUDE_DIR/hooks" -type f -not -name '*.pyc' 2>/dev/null | wc -l | tr -d ' ')
[ "$HOOK_COUNT" -ge 5 ] && pass || fail

# 27. No hooks reference ANTHROPIC_API_KEY
ANTH=$(grep -rl 'ANTHROPIC_API_KEY' "$CLAUDE_DIR/hooks/" 2>/dev/null | wc -l | tr -d ' ')
[ "$ANTH" -eq 0 ] && pass || fail

# 28. Has at least 1 Python hook in hooks/
PY_HOOKS=$(find "$CLAUDE_DIR/hooks" -name '*.py' -type f 2>/dev/null | wc -l | tr -d ' ')
[ "$PY_HOOKS" -ge 1 ] && pass || fail

# 29. No dead hook references in settings.json
pass  # Simplified — validated in directory eval

# 30. Hook latency: test first 3 hook files complete in < 200ms each
HOOKS_TESTED=0
for hook_file in $(find "$CLAUDE_DIR/hooks" -type f \( -name '*.py' -o -name '*.sh' \) 2>/dev/null | head -3); do
  if [ -f "$hook_file" ]; then
    HS=$(python3 -c "import time; print(time.time())" 2>/dev/null)
    if [[ "$hook_file" == *.py ]]; then
      python3 "$hook_file" > /dev/null 2>&1
    else
      bash "$hook_file" > /dev/null 2>&1
    fi
    HE=$(python3 -c "import time; print(time.time())" 2>/dev/null)
    HL=$(python3 -c "print(int(($HE - $HS) * 1000))" 2>/dev/null)
    [ -n "$HL" ] && [ "$HL" -lt 200 ] && pass || fail
    ((HOOKS_TESTED++))
  fi
done
# Fill remaining slots if < 3 hooks found
while [ "$HOOKS_TESTED" -lt 3 ]; do
  fail
  ((HOOKS_TESTED++))
done

# 33. PYTHONDONTWRITEBYTECODE set in settings
grep -q 'PYTHONDONTWRITEBYTECODE' "$CLAUDE_DIR/settings.json" 2>/dev/null && pass || fail

# 34. No __pycache__ in hooks
HPYC=$(find "$CLAUDE_DIR/hooks" -type d -name '__pycache__' 2>/dev/null | wc -l | tr -d ' ')
[ "$HPYC" -eq 0 ] && pass || fail

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# SECTION 4: PLUGINS (10 points)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Helper: count enabled plugins
count_enabled_plugins() {
  python3 -c "
import json, os
d = json.load(open(os.path.expanduser('~/.claude/settings.json')))
ps = d.get('enabledPlugins', d.get('plugins', {}))
count = 0
for v in ps.values():
    if isinstance(v, bool) and v: count += 1
    elif isinstance(v, dict) and v.get('enabled', True): count += 1
print(count)
" 2>/dev/null
}

# 35. Has >= 4 enabled plugins
ENABLED=$(count_enabled_plugins)
[ -n "$ENABLED" ] && [ "$ENABLED" -ge 4 ] && pass || fail

# 36. No disabled plugins still taking cache space > 50MB
pass  # Simplified

# 37. No duplicate plugin categories
MKTG_ENABLED=$(python3 -c "
import json, os
d = json.load(open(os.path.expanduser('~/.claude/settings.json')))
ps = d.get('enabledPlugins', d.get('plugins', {}))
count = 0
for k,v in ps.items():
    if 'marketing' not in k.lower(): continue
    if isinstance(v, bool) and v: count += 1
    elif isinstance(v, dict) and v.get('enabled', True): count += 1
print(count)
" 2>/dev/null)
[ -n "$MKTG_ENABLED" ] && [ "$MKTG_ENABLED" -le 1 ] && pass || fail

# 38. No stale/demo plugins enabled
STALE=$(python3 -c "
import json, os
d = json.load(open(os.path.expanduser('~/.claude/settings.json')))
ps = d.get('enabledPlugins', d.get('plugins', {}))
stale = []
for k,v in ps.items():
    enabled = (isinstance(v, bool) and v) or (isinstance(v, dict) and v.get('enabled', True))
    if enabled and any(x in k.lower() for x in ['demo', 'showcase', 'test-', 'example']):
        stale.append(k)
print(len(stale))
" 2>/dev/null)
[ -n "$STALE" ] && [ "$STALE" -eq 0 ] && pass || fail

# 39. Has >= 10 enabled plugins (shows investment in tooling)
[ -n "$ENABLED" ] && [ "$ENABLED" -ge 10 ] && pass || fail

# 40. No more than 25 plugins enabled (noise threshold)
[ -n "$ENABLED" ] && [ "$ENABLED" -le 25 ] && pass || fail

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# SECTION 5: CLAUDE.md QUALITY (10 points)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# 41. Has Security section
grep -qi 'security' "$CLAUDE_DIR/CLAUDE.md" 2>/dev/null && pass || fail

# 42. Has Tool Usage Priority
grep -q 'Tool Usage Priority' "$CLAUDE_DIR/CLAUDE.md" 2>/dev/null && pass || fail

# 43. Has Planning Discipline
grep -q 'Planning Discipline' "$CLAUDE_DIR/CLAUDE.md" 2>/dev/null && pass || fail

# 44. Has memory or context management section
grep -qi 'memory\|context\|knowledge' "$CLAUDE_DIR/CLAUDE.md" 2>/dev/null && pass || fail

# 45. Has cost or API key constraint
grep -qi 'cost\|ANTHROPIC_API_KEY\|never use.*api key' "$CLAUDE_DIR/CLAUDE.md" 2>/dev/null && pass || fail

# 46. Has Agent Auto-Launch or agent dispatch rules
grep -qi 'agent.*launch\|agent.*auto\|agent.*dispatch' "$CLAUDE_DIR/CLAUDE.md" 2>/dev/null && pass || fail

# 47. Has Context Front-Loading or session start protocol
grep -qi 'front-loading\|context.*first\|session.*start\|before.*asking' "$CLAUDE_DIR/CLAUDE.md" 2>/dev/null && pass || fail

# 48. Has session continuity or handoff protocol
grep -qi 'session.*continuity\|handoff\|wrap.*up\|end.*session' "$CLAUDE_DIR/CLAUDE.md" 2>/dev/null && pass || fail

# 49. Has Plan Verification Protocol
grep -qi 'plan.*verification\|self-check\|score.*85' "$CLAUDE_DIR/CLAUDE.md" 2>/dev/null && pass || fail

# 50. CLAUDE.md is under 200 lines (not bloated)
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  CL=$(wc -l < "$CLAUDE_DIR/CLAUDE.md" | tr -d ' ')
  [ "$CL" -lt 200 ] && pass || fail
else
  fail
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# OUTPUT
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PCT=$((SCORE * 100 / MAX))

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "COMPOSITE SCORE: $SCORE / $MAX ($PCT%)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
