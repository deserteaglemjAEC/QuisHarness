# Hook Templates

Hooks are shell scripts or Python programs that Claude Code runs at specific points during a session. They let you inject context, validate inputs, and automate workflows.

## Hook Types

| Type | When It Fires | Common Uses |
|------|--------------|-------------|
| **SessionStart** | Session begins, resumes, or context compacts | Inject project context, load memory, set environment |
| **PreToolUse** | Before a tool executes | Validate parameters, augment inputs, security checks |
| **PostToolUse** | After a tool completes | Auto-format, log actions, run checks |
| **UserPromptSubmit** | When the user sends a message | Classify prompts, route context, activate skills |

## Configuring Hooks

Hooks are configured in `~/.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume",
        "hooks": [
          {
            "type": "command",
            "command": "python3 ~/.claude/hooks/memory-context.py"
          }
        ]
      }
    ]
  }
}
```

### Matchers

Matchers filter when a hook fires:
- **SessionStart**: `startup`, `resume`, `clear`, `compact`
- **PreToolUse/PostToolUse**: tool name (e.g., `Read`, `Edit`, `Bash`)
- **UserPromptSubmit**: always fires (no matcher needed)

## What's Included

| File | Type | Purpose |
|------|------|---------|
| `memory-context.py` | SessionStart | Project-scoped context injection (CWD detection pattern) |
| `examples/skill-activation.sh.example` | Documentation | PATH wrapper pattern for Node.js hooks |
| `examples/prompt-improver.py` | UserPromptSubmit | Prompt classification skeleton |

## Key Principles

1. **Hooks must be fast** — target < 200ms per hook. Slow hooks delay every interaction.
2. **Use standard library only** — no pip dependencies. Hooks run in bare environments.
3. **Return JSON for UserPromptSubmit** — `{"additionalContext": "your context here"}`
4. **Print to stdout for SessionStart** — output becomes context for the session.
5. **Set `PYTHONDONTWRITEBYTECODE=1`** in settings.json env to prevent `__pycache__`.

## Learn More

See [docs/hook-patterns.md](../docs/hook-patterns.md) for detailed hook architecture patterns with skeleton code for each hook type.
