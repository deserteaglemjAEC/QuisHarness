#!/bin/bash
# eval-claude-directory.sh — Grade your ~/.claude/ directory organization
# Usage: bash ~/.claude/scripts/eval-claude-directory.sh
# Output: Score out of 25 across 5 categories
#
# Categories: Structure (5), Skills (5), Hooks (5), Rules (5), Hygiene (5)
# Part of QuisHarness — https://github.com/deserteaglemjAEC/QuisHarness

CLAUDE_DIR="$HOME/.claude"
PASS=0
TOTAL=25

echo "=== CLAUDE CODE DIRECTORY EVAL ==="
echo ""

# === STRUCTURE (5) ===
echo "--- STRUCTURE ---"

# 1. CLAUDE.md exists and < 200 lines
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  LINES=$(wc -l < "$CLAUDE_DIR/CLAUDE.md" | tr -d ' ')
  if [ "$LINES" -lt 200 ]; then
    ((PASS++)); echo "1. PASS — CLAUDE.md exists ($LINES lines, < 200)"
  else
    echo "1. FAIL — CLAUDE.md is $LINES lines (should be < 200)"
  fi
else
  echo "1. FAIL — CLAUDE.md does not exist"
fi

# 2. settings.json exists
if [ -f "$CLAUDE_DIR/settings.json" ]; then ((PASS++)); echo "2. PASS — settings.json exists"; else echo "2. FAIL — settings.json missing"; fi

# 3. keybindings.json exists
if [ -f "$CLAUDE_DIR/keybindings.json" ]; then ((PASS++)); echo "3. PASS — keybindings.json exists"; else echo "3. FAIL — keybindings.json missing"; fi

# 4. output-styles/ exists with >= 1 file
OS_COUNT=$(find "$CLAUDE_DIR/output-styles" -name '*.md' -type f 2>/dev/null | wc -l | tr -d ' ')
if [ "$OS_COUNT" -ge 1 ]; then ((PASS++)); echo "4. PASS — output-styles/ has $OS_COUNT files"; else echo "4. FAIL — output-styles/ missing or empty"; fi

# 5. agent-memory/ directory exists
if [ -d "$CLAUDE_DIR/agent-memory" ]; then ((PASS++)); echo "5. PASS — agent-memory/ exists"; else echo "5. FAIL — agent-memory/ missing"; fi

echo ""

# === SKILLS (5) ===
echo "--- SKILLS ---"

# 6. skills/ has 10-30 skill directories
SKILL_COUNT=$(find "$CLAUDE_DIR/skills" -maxdepth 1 -type d 2>/dev/null | tail -n +2 | wc -l | tr -d ' ')
if [ "$SKILL_COUNT" -ge 10 ] && [ "$SKILL_COUNT" -le 30 ]; then
  ((PASS++)); echo "6. PASS — $SKILL_COUNT skills (10-30 sweet spot)"
elif [ "$SKILL_COUNT" -gt 30 ]; then
  echo "6. FAIL — $SKILL_COUNT skills (too many, > 30 causes activation noise)"
else
  echo "6. FAIL — $SKILL_COUNT skills (too few, < 10)"
fi

# 7. Every skill has a SKILL.md file
MISSING_SKILL=0
for d in "$CLAUDE_DIR"/skills/*/; do
  [ ! -f "$d/SKILL.md" ] && ((MISSING_SKILL++))
done
if [ "$MISSING_SKILL" -eq 0 ]; then ((PASS++)); echo "7. PASS — all skills have SKILL.md"; else echo "7. FAIL — $MISSING_SKILL skills missing SKILL.md"; fi

# 8. No skill SKILL.md exceeds 500 lines
OVERSIZED=0
for d in "$CLAUDE_DIR"/skills/*/; do
  if [ -f "$d/SKILL.md" ]; then
    SL=$(wc -l < "$d/SKILL.md" | tr -d ' ')
    [ "$SL" -ge 500 ] && ((OVERSIZED++))
  fi
done
if [ "$OVERSIZED" -eq 0 ]; then ((PASS++)); echo "8. PASS — no skill exceeds 500 lines"; else echo "8. FAIL — $OVERSIZED skills exceed 500 lines"; fi

# 9. At least 1 skill has resources/ directory
RES_COUNT=$(find "$CLAUDE_DIR/skills" -maxdepth 2 -type d -name 'resources' 2>/dev/null | wc -l | tr -d ' ')
if [ "$RES_COUNT" -ge 1 ]; then ((PASS++)); echo "9. PASS — $RES_COUNT skills have resources/"; else echo "9. FAIL — no skills have resources/ directory"; fi

# 10. At least 1 skill has a resources/ or eval/ subdirectory with content
RICH_SKILL=0
for d in "$CLAUDE_DIR"/skills/*/; do
  if [ -d "$d/resources" ] || [ -d "$d/eval" ]; then
    FILE_COUNT=$(find "$d/resources" "$d/eval" -type f 2>/dev/null | wc -l | tr -d ' ')
    [ "$FILE_COUNT" -ge 1 ] && ((RICH_SKILL++))
  fi
done
if [ "$RICH_SKILL" -ge 1 ]; then ((PASS++)); echo "10. PASS — $RICH_SKILL skills have resources/ or eval/ with content"; else echo "10. FAIL — no skills have rich subdirectories (resources/ or eval/)"; fi

echo ""

# === HOOKS (5) ===
echo "--- HOOKS ---"

# 11. hooks/ has >= 5 hook files
HOOK_COUNT=$(find "$CLAUDE_DIR/hooks" -type f -not -name '*.pyc' 2>/dev/null | wc -l | tr -d ' ')
if [ "$HOOK_COUNT" -ge 5 ]; then ((PASS++)); echo "11. PASS — $HOOK_COUNT hook files"; else echo "11. FAIL — only $HOOK_COUNT hooks (need >= 5)"; fi

# 12. No hooks reference ANTHROPIC_API_KEY directly
ANTH_REFS=$(grep -rl 'ANTHROPIC_API_KEY' "$CLAUDE_DIR/hooks/" 2>/dev/null | wc -l | tr -d ' ')
if [ "$ANTH_REFS" -eq 0 ]; then ((PASS++)); echo "12. PASS — no hooks reference ANTHROPIC_API_KEY"; else echo "12. FAIL — $ANTH_REFS hooks reference ANTHROPIC_API_KEY (security risk)"; fi

# 13. No __pycache__ in hooks/
PYCACHE=$(find "$CLAUDE_DIR/hooks" -type d -name '__pycache__' 2>/dev/null | wc -l | tr -d ' ')
if [ "$PYCACHE" -eq 0 ]; then ((PASS++)); echo "13. PASS — no __pycache__ in hooks/"; else echo "13. FAIL — $PYCACHE __pycache__ dirs in hooks/"; fi

# 14. settings.json hooks don't reference deleted directories
DEAD_REFS=$(grep -o '"command".*hooks/[^"]*' "$CLAUDE_DIR/settings.json" 2>/dev/null | while read -r line; do
  DIR=$(echo "$line" | grep -o '/Users/[^"]*/' | head -1)
  [ -n "$DIR" ] && [ ! -d "$DIR" ] && echo "DEAD"
done | wc -l | tr -d ' ')
if [ "$DEAD_REFS" -eq 0 ]; then ((PASS++)); echo "14. PASS — no dead hook references in settings.json"; else echo "14. FAIL — $DEAD_REFS hook references point to deleted dirs"; fi

# 15. Has at least 1 SessionStart hook (.sh or .py) in hooks/
SS_HOOKS=$(find "$CLAUDE_DIR/hooks" \( -name '*.sh' -o -name '*.py' \) -type f 2>/dev/null | wc -l | tr -d ' ')
if [ "$SS_HOOKS" -ge 1 ]; then ((PASS++)); echo "15. PASS — $SS_HOOKS hook scripts found (.sh/.py)"; else echo "15. FAIL — no hook scripts found in hooks/"; fi

echo ""

# === RULES (5) ===
echo "--- RULES ---"

# 16. rules/ directory exists
if [ -d "$CLAUDE_DIR/rules" ]; then ((PASS++)); echo "16. PASS — rules/ exists"; else echo "16. FAIL — rules/ missing"; fi

# 17. rules/ has >= 3 .md files
RULE_FILES=$(find -L "$CLAUDE_DIR/rules" -name '*.md' -type f 2>/dev/null | wc -l | tr -d ' ')
if [ "$RULE_FILES" -ge 3 ]; then ((PASS++)); echo "17. PASS — $RULE_FILES rule files (>= 3 global rules)"; else echo "17. FAIL — only $RULE_FILES rule files (need >= 3 global rules: coding, security, git)"; fi

# 18. No rule file exceeds 200 lines
LONG_RULES=$(find -L "$CLAUDE_DIR/rules" -name '*.md' -type f 2>/dev/null -exec sh -c 'wc -l < "$1" | tr -d " "' _ {} \; | awk '$1 >= 200' | wc -l | tr -d ' ')
if [ "$LONG_RULES" -eq 0 ]; then ((PASS++)); echo "18. PASS — no rule file exceeds 200 lines"; else echo "18. FAIL — $LONG_RULES rule files exceed 200 lines"; fi

# 19. rules/common/ subdirectory exists
if [ -d "$CLAUDE_DIR/rules/common" ]; then ((PASS++)); echo "19. PASS — rules/common/ exists"; else echo "19. FAIL — rules/common/ missing"; fi

# 20. CLAUDE.md < 200 lines (validates it's not bloated with rules content)
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  CMD_LINES=$(wc -l < "$CLAUDE_DIR/CLAUDE.md" | tr -d ' ')
  if [ "$CMD_LINES" -lt 200 ]; then ((PASS++)); echo "20. PASS — CLAUDE.md compact ($CMD_LINES lines, not bloated with rules)"; else echo "20. FAIL — CLAUDE.md is $CMD_LINES lines (move content to rules/)"; fi
else
  echo "20. FAIL — CLAUDE.md missing"
fi

echo ""

# === HYGIENE (5) ===
echo "--- HYGIENE ---"

# 21. No .bak files at root
BAK_COUNT=$(find "$CLAUDE_DIR" -maxdepth 1 -name '*.bak*' -type f 2>/dev/null | wc -l | tr -d ' ')
if [ "$BAK_COUNT" -eq 0 ]; then ((PASS++)); echo "21. PASS — no .bak files at root"; else echo "21. FAIL — $BAK_COUNT .bak files at root"; fi

# 22. No __pycache__ anywhere
ALL_PYCACHE=$(find "$CLAUDE_DIR" -type d -name '__pycache__' -not -path '*/node_modules/*' -not -path '*/.git/*' 2>/dev/null | wc -l | tr -d ' ')
if [ "$ALL_PYCACHE" -eq 0 ]; then ((PASS++)); echo "22. PASS — no __pycache__ anywhere"; else echo "22. FAIL — $ALL_PYCACHE __pycache__ dirs found"; fi

# 23. debug/ has < 100 files
DEBUG_COUNT=$(find "$CLAUDE_DIR/debug" -type f 2>/dev/null | wc -l | tr -d ' ')
if [ "$DEBUG_COUNT" -lt 100 ]; then ((PASS++)); echo "23. PASS — debug/ has $DEBUG_COUNT files (< 100)"; else echo "23. FAIL — debug/ has $DEBUG_COUNT files (>= 100, needs pruning)"; fi

# 24. No empty directories that should have been deleted
EMPTY_DIRS=0
for d in credentials downloads; do
  [ -d "$CLAUDE_DIR/$d" ] && ((EMPTY_DIRS++))
done
if [ "$EMPTY_DIRS" -eq 0 ]; then ((PASS++)); echo "24. PASS — no stale empty directories"; else echo "24. FAIL — $EMPTY_DIRS empty directories still exist"; fi

# 25. Root has < 15 loose files
ROOT_COUNT=$(find "$CLAUDE_DIR" -maxdepth 1 -type f | wc -l | tr -d ' ')
if [ "$ROOT_COUNT" -lt 15 ]; then ((PASS++)); echo "25. PASS — root has $ROOT_COUNT files (< 15)"; else echo "25. FAIL — root has $ROOT_COUNT files (>= 15, too cluttered)"; fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SCORE: $PASS / $TOTAL"
echo "PASS RATE: $(( PASS * 100 / TOTAL ))%"
echo ""
if [ "$PASS" -eq 25 ]; then echo "RATING: 10/10"
elif [ "$PASS" -ge 23 ]; then echo "RATING: 9/10"
elif [ "$PASS" -ge 20 ]; then echo "RATING: 8/10"
elif [ "$PASS" -ge 17 ]; then echo "RATING: 7/10"
else echo "RATING: $(( PASS * 10 / 25 ))/10"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
