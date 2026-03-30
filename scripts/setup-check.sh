#!/bin/bash
# setup-check.sh — Pre-install diagnostic for QuisHarness
# Run this BEFORE install.sh to see your current setup state
# Usage: bash scripts/setup-check.sh

echo "=== QuisHarness Pre-Install Check ==="
echo ""

# 1. OS
echo "--- SYSTEM ---"
OS=$(uname -s)
echo "OS: $OS"

# 2. Bash version
BASH_V="${BASH_VERSION%%[^0-9.]*}"
BASH_MAJOR="${BASH_V%%.*}"
echo "Bash: $BASH_V"
if [ "$BASH_MAJOR" -lt 4 ] && [ "$OS" = "Darwin" ]; then
  echo "  WARNING: macOS ships Bash 3.2. Some features work best with Bash 4+."
  echo "  Install with: brew install bash"
fi

# 3. Claude Code CLI
if command -v claude &> /dev/null; then
  echo "Claude Code CLI: installed"
else
  echo "Claude Code CLI: NOT FOUND"
  echo "  Install from: https://claude.ai/code"
fi

echo ""

# 4. ~/.claude/ status
echo "--- CLAUDE DIRECTORY ---"
CLAUDE_DIR="$HOME/.claude"

if [ -d "$CLAUDE_DIR" ]; then
  echo "~/.claude/ exists"

  # Count key items
  SETTINGS=$([ -f "$CLAUDE_DIR/settings.json" ] && echo "yes" || echo "no")
  CLAUDE_MD=$([ -f "$CLAUDE_DIR/CLAUDE.md" ] && echo "yes" || echo "no")
  SKILL_COUNT=$(find "$CLAUDE_DIR/skills" -maxdepth 1 -type d 2>/dev/null | tail -n +2 | wc -l | tr -d ' ')
  HOOK_COUNT=$(find "$CLAUDE_DIR/hooks" -type f -not -name '*.pyc' 2>/dev/null | wc -l | tr -d ' ')
  RULE_COUNT=$(find -L "$CLAUDE_DIR/rules" -name '*.md' -type f 2>/dev/null | wc -l | tr -d ' ')

  echo "  settings.json: $SETTINGS"
  echo "  CLAUDE.md: $CLAUDE_MD"
  echo "  Skills: $SKILL_COUNT"
  echo "  Hooks: $HOOK_COUNT"
  echo "  Rules: $RULE_COUNT"

  # 5. Run eval if available
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
  EVAL_SCRIPT="$SCRIPT_DIR/eval-claude-directory.sh"
  if [ -f "$EVAL_SCRIPT" ]; then
    echo ""
    echo "--- CURRENT SCORE (before install) ---"
    bash "$EVAL_SCRIPT"
  fi
else
  echo "~/.claude/ does NOT exist"
  echo "  QuisHarness will create it during install."
fi

echo ""
echo "--- RECOMMENDATIONS ---"
if [ ! -d "$CLAUDE_DIR" ]; then
  echo "1. Run 'bash install.sh' to set up your Claude Code directory"
elif [ "$SKILL_COUNT" -lt 10 ]; then
  echo "1. Install community plugins to add skills (claude plugin install <name>)"
fi
echo "Run 'bash install.sh --dry-run' to preview what will be installed."
