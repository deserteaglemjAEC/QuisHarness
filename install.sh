#!/bin/bash
# install.sh — QuisHarness Setup Wizard
# Installs an optimized ~/.claude/ directory structure
# Usage: bash install.sh [--yes] [--dry-run] [--help]

set -e

CLAUDE_DIR="$HOME/.claude"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DATE=$(date +%Y%m%d-%H%M%S)
DRY_RUN=false
AUTO_YES=false

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Parse arguments
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

for arg in "$@"; do
  case "$arg" in
    --yes) AUTO_YES=true ;;
    --dry-run) DRY_RUN=true ;;
    --help|-h)
      echo "QuisHarness Installer"
      echo ""
      echo "Usage: bash install.sh [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --yes       Non-interactive mode (skip confirmations)"
      echo "  --dry-run   Show what would be installed without making changes"
      echo "  --help      Show this help message"
      echo ""
      echo "What it does:"
      echo "  1. Backs up existing CLAUDE.md and keybindings.json"
      echo "  2. Copies templates (CLAUDE.md, keybindings) to ~/.claude/"
      echo "  3. Copies rules to ~/.claude/rules/"
      echo "  4. Copies eval scripts to ~/.claude/scripts/"
      echo "  5. Copies output styles to ~/.claude/output-styles/"
      echo "  6. Creates missing directories (agent-memory, skills, warnings)"
      echo "  7. Runs directory eval and shows your score"
      echo ""
      echo "What it does NOT do:"
      echo "  - Overwrite settings.json (review templates/settings-example.json manually)"
      echo "  - Install hooks (customize hooks/ templates and install manually)"
      echo "  - Install plugins (use 'claude plugin install <name>')"
      exit 0
      ;;
  esac
done

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Helpers
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

confirm() {
  if [ "$AUTO_YES" = true ]; then return 0; fi
  printf "%s [y/N] " "$1"
  read -r answer
  case "$answer" in
    [yY]*) return 0 ;;
    *) return 1 ;;
  esac
}

action() {
  if [ "$DRY_RUN" = true ]; then
    echo "  [DRY RUN] $1"
  else
    echo "  $1"
  fi
}

copy_file() {
  local src="$1" dest="$2"
  if [ "$DRY_RUN" = true ]; then
    action "Copy $src -> $dest"
  else
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    action "Copied $(basename "$src") -> $dest"
  fi
}

copy_dir() {
  local src="$1" dest="$2"
  if [ "$DRY_RUN" = true ]; then
    action "Copy $src/ -> $dest/"
  else
    mkdir -p "$dest"
    cp -r "$src"/* "$dest"/ 2>/dev/null || true
    action "Copied $src/ -> $dest/"
  fi
}

backup_file() {
  local file="$1"
  if [ -f "$file" ]; then
    local backup="${file}.bak.${DATE}"
    if [ "$DRY_RUN" = true ]; then
      action "Backup $file -> $backup"
    else
      cp "$file" "$backup"
      action "Backed up $(basename "$file") -> $(basename "$backup")"
    fi
  fi
}

make_dir() {
  local dir="$1"
  if [ ! -d "$dir" ]; then
    if [ "$DRY_RUN" = true ]; then
      action "Create directory $dir"
    else
      mkdir -p "$dir"
      action "Created $dir"
    fi
  fi
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Banner
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  QuisHarness Installer"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ "$DRY_RUN" = true ]; then
  echo "  MODE: Dry run (no changes will be made)"
  echo ""
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Prerequisites
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "--- Prerequisites ---"

# Bash version
BASH_MAJOR="${BASH_VERSION%%.*}"
if [ "$BASH_MAJOR" -lt 4 ] && [ "$(uname -s)" = "Darwin" ]; then
  echo "  WARNING: Bash $BASH_VERSION detected. Some eval scripts work best with Bash 4+."
  echo "  Install with: brew install bash"
else
  echo "  Bash $BASH_VERSION — OK"
fi

# Claude Code CLI
if command -v claude &> /dev/null; then
  echo "  Claude Code CLI — installed"
else
  echo "  Claude Code CLI — not found (install from https://claude.ai/code)"
fi

# ~/.claude/ directory
if [ -d "$CLAUDE_DIR" ]; then
  echo "  ~/.claude/ — exists"
else
  echo "  ~/.claude/ — does not exist"
  if confirm "Create ~/.claude/ now?"; then
    make_dir "$CLAUDE_DIR"
  else
    echo "Cannot continue without ~/.claude/. Exiting."
    exit 1
  fi
fi

echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 1: Backup existing files
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "--- Step 1: Backup ---"
backup_file "$CLAUDE_DIR/CLAUDE.md"
backup_file "$CLAUDE_DIR/keybindings.json"
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 2: Copy templates
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "--- Step 2: Templates ---"
if confirm "Copy CLAUDE.md and keybindings.json to ~/.claude/?"; then
  copy_file "$SCRIPT_DIR/templates/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
  copy_file "$SCRIPT_DIR/templates/keybindings.json" "$CLAUDE_DIR/keybindings.json"
else
  echo "  Skipped templates"
fi
echo "  NOTE: settings-example.json NOT copied — review and merge manually."
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 3: Copy rules
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "--- Step 3: Rules ---"
if confirm "Copy rules/ to ~/.claude/rules/?"; then
  copy_dir "$SCRIPT_DIR/rules" "$CLAUDE_DIR/rules"
else
  echo "  Skipped rules"
fi
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 4: Copy scripts
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "--- Step 4: Eval Scripts ---"
if confirm "Copy eval scripts to ~/.claude/scripts/?"; then
  copy_dir "$SCRIPT_DIR/scripts" "$CLAUDE_DIR/scripts"
  if [ "$DRY_RUN" = false ]; then
    chmod +x "$CLAUDE_DIR/scripts/"*.sh 2>/dev/null
  fi
else
  echo "  Skipped scripts"
fi
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 5: Copy output styles
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "--- Step 5: Output Styles ---"
if confirm "Copy output styles to ~/.claude/output-styles/?"; then
  copy_dir "$SCRIPT_DIR/output-styles" "$CLAUDE_DIR/output-styles"
else
  echo "  Skipped output styles"
fi
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 6: Create missing directories
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "--- Step 6: Create Directories ---"
make_dir "$CLAUDE_DIR/agent-memory"
make_dir "$CLAUDE_DIR/skills"
make_dir "$CLAUDE_DIR/hooks"
make_dir "$CLAUDE_DIR/warnings"
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Step 7: Run eval
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if [ "$DRY_RUN" = false ] && [ -f "$CLAUDE_DIR/scripts/eval-claude-directory.sh" ]; then
  echo "--- Step 7: Eval ---"
  bash "$CLAUDE_DIR/scripts/eval-claude-directory.sh"
  echo ""
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Next steps
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Installation complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next steps:"
echo ""
echo "  1. Review and merge settings:"
echo "     cat templates/settings-example.json"
echo "     # Merge into ~/.claude/settings.json"
echo ""
echo "  2. Set up hooks:"
echo "     # Customize hooks/memory-context.py with your projects"
echo "     cp hooks/memory-context.py ~/.claude/hooks/"
echo "     # See hooks/README.md for configuration"
echo ""
echo "  3. Install plugins:"
echo "     claude plugin install <name>"
echo "     # See docs/plugin-evaluation.md for how to choose"
echo ""
echo "  4. Run the full eval:"
echo "     bash ~/.claude/scripts/eval-composite.sh"
echo ""
