# Hook Patterns

Common hook architectures with skeleton code for each hook type.

## SessionStart: Context Injection

**When it fires:** Session begins, resumes after being idle, context compacts, or conversation clears.

**Pattern:** Inject project-specific context, load memory state, set up environment.

### Bash Example

```bash
#!/bin/bash
# session-context.sh — Inject project context on session start

PROJECT=$(basename "$(pwd)")
echo "=== PROJECT: $PROJECT ==="
echo "Branch: $(git branch --show-current 2>/dev/null || echo 'not a git repo')"
echo "Last commit: $(git log --oneline -1 2>/dev/null || echo 'none')"

# Load project-specific notes if they exist
NOTES="$HOME/.claude/agent-memory/$PROJECT.md"
if [ -f "$NOTES" ]; then
  echo ""
  echo "=== PROJECT NOTES ==="
  cat "$NOTES"
fi
```

### Python Example

```python
#!/usr/bin/env python3
"""Project-scoped context injection."""
import os

PROJECT_MAP = {
    "my-saas": "saas",
    "client-site": "client",
}

def get_slug():
    cwd = os.getcwd()
    for pattern, slug in PROJECT_MAP.items():
        if pattern in cwd:
            return slug
    return os.path.basename(cwd).lower().replace(" ", "-")

print(f"Current project: {get_slug()}")
```

### Configuration

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume|compact",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/session-context.sh"
          }
        ]
      }
    ]
  }
}
```

---

## PreToolUse: Validation and Augmentation

**When it fires:** Before any tool (Read, Write, Edit, Bash, etc.) executes.

**Pattern:** Validate parameters, block dangerous operations, augment inputs.

### Bash Example: Block Dangerous Bash Commands

```bash
#!/bin/bash
# check-bash.sh — Block dangerous bash commands
# Reads JSON from stdin, checks the command field

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('command',''))" 2>/dev/null)

# Block rm -rf on home directory
if echo "$COMMAND" | grep -qE 'rm\s+-rf\s+[~/]'; then
  echo '{"decision": "block", "reason": "Blocked: rm -rf on home directory"}'
  exit 0
fi

# Allow everything else
echo '{"decision": "allow"}'
```

### Configuration

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/check-bash.sh"
          }
        ]
      }
    ]
  }
}
```

---

## PostToolUse: Auto-Actions After Tools

**When it fires:** After a tool completes successfully.

**Pattern:** Auto-format code, log tool usage, run checks.

### Bash Example: Auto-Format After Write

```bash
#!/bin/bash
# auto-format.sh — Run formatter after file writes

INPUT=$(cat)
FILE=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('file_path',''))" 2>/dev/null)

case "$FILE" in
  *.ts|*.tsx|*.js|*.jsx)
    npx prettier --write "$FILE" 2>/dev/null
    ;;
  *.py)
    python3 -m black "$FILE" 2>/dev/null
    ;;
esac
```

### Configuration

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/auto-format.sh"
          }
        ]
      }
    ]
  }
}
```

---

## UserPromptSubmit: Prompt Processing

**When it fires:** When the user sends a message, before Claude processes it.

**Pattern:** Classify prompts, route context, activate skills, add warnings.

### Python Example: Prompt Classification

```python
#!/usr/bin/env python3
"""Classify user prompts and inject context."""
import json
import sys
import re

input_data = json.load(sys.stdin)
prompt = input_data.get("prompt", "").lower()

# Classify
if re.search(r"\b(build|create|implement|add)\b", prompt):
    ctx = "TASK DETECTED: Plan before implementing."
elif re.search(r"\b(what|how|why|explain)\b", prompt):
    ctx = "QUESTION DETECTED: Answer concisely."
else:
    ctx = ""

if ctx:
    json.dump({"additionalContext": ctx}, sys.stdout)
else:
    json.dump({}, sys.stdout)
```

### Configuration

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "python3 ~/.claude/hooks/prompt-classifier.py"
          }
        ]
      }
    ]
  }
}
```

---

## Performance Guidelines

| Metric | Target | Why |
|--------|--------|-----|
| Individual hook | < 200ms | Hooks block the response pipeline |
| Total per event | < 500ms | Multiple hooks compound |
| stdout output | < 2KB | Large output wastes context window |
| Dependencies | stdlib only | No pip install — hooks run in bare environments |

### Profiling

```bash
# Time a hook
time python3 ~/.claude/hooks/your-hook.py < /dev/null

# Time all SessionStart hooks
time bash -c 'for f in ~/.claude/hooks/*.py; do python3 "$f" 2>/dev/null; done'
```

### Common Performance Mistakes

1. **Network calls in hooks** — Never fetch URLs. Use cached/local data only.
2. **Heavy file scanning** — Don't `find` the entire repo. Use targeted checks.
3. **Python imports** — Import only what you need. `import os` is fast; `import pandas` is not.
4. **Shell subprocesses** — Each `$(...)` spawns a process. Minimize in tight loops.
