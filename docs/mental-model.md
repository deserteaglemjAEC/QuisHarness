# How Claude Code Actually Works

Understanding Claude Code's internals helps you optimize your setup. This document explains the mental model behind how Claude Code assembles context, activates skills, and runs hooks.

## The Context Assembly Pipeline

Every time Claude Code starts a session or processes a prompt, it assembles context from multiple sources in this order:

```
1. System prompt (built-in, you can't change this)
2. CLAUDE.md files (global ~/.claude/CLAUDE.md + project .claude/CLAUDE.md)
3. Rules (global ~/.claude/rules/ + project .claude/rules/)
4. Plugin context (injected by enabled plugins via hooks)
5. Skill descriptions (matched against the current prompt)
6. Hook output (SessionStart, UserPromptSubmit, etc.)
7. Memory files (if referenced in CLAUDE.md)
```

Each layer adds to the context window. This means **everything you configure competes for attention** — there's a finite budget.

## The Attention Budget

Claude Code has a context window (typically 200K tokens). Your configuration consumes part of it:

| Component | Typical Size | Impact |
|-----------|-------------|--------|
| CLAUDE.md | 2-8K tokens | Read every session |
| Rules (all files) | 3-10K tokens | Loaded based on globs |
| Skill descriptions | 1-3K per active skill | Matched per prompt |
| Hook output | 0.5-2K per hook | Injected per event |
| Plugin context | 2-20K per plugin | Varies widely |

**The insight:** Fewer, better-written components outperform many mediocre ones. A 200-line CLAUDE.md with 10 focused skills beats a 1000-line CLAUDE.md with 50 overlapping skills.

## How Skill Activation Works

Skills are NOT activated by file path or directory name. They're activated by **description matching**:

1. User sends a prompt
2. Claude Code compares the prompt against every skill's `description` field
3. Skills with matching keywords/phrases get loaded into context
4. The skill's full SKILL.md content becomes available

This means:
- A skill with a vague description activates too often (wastes attention budget)
- A skill with no trigger phrases never activates (useless)
- The sweet spot: 50-500 character descriptions with "Use when" + "Triggers on" phrases and 3+ unique keywords

See `scripts/eval-skill-activation.sh` to score your skills' activation quality.

## Hook Execution Model

Hooks run **synchronously** — Claude Code waits for each hook to complete before continuing. This has critical implications:

```
SessionStart hooks → must complete before session is usable
UserPromptSubmit hooks → must complete before Claude sees the prompt
PreToolUse hooks → must complete before the tool runs
```

**Target: < 200ms per hook, < 500ms total per event.** Slow hooks make every interaction feel sluggish.

Hooks communicate via:
- **stdout** (SessionStart): printed text becomes session context
- **JSON on stdout** (UserPromptSubmit): `{"additionalContext": "..."}` gets injected
- **Exit code** (PreToolUse): non-zero can block the tool

## The "Waiter, Not a Library" Model

Think of Claude Code as a waiter, not a library:

- **Library model** (wrong): You search for what you need, pull it off the shelf, read it yourself
- **Waiter model** (right): You tell the waiter what you want, they bring the right dishes from the kitchen

Your job is to **describe what you have** (skill descriptions, CLAUDE.md instructions) so Claude Code can **serve the right context** when needed. You don't manually load skills — Claude Code matches them to the conversation.

This is why skill descriptions matter more than skill content. The description is the menu item; the content is the dish.

## Optimization Principles

1. **CLAUDE.md < 200 lines** — Move detailed instructions to rules/ files
2. **Rules use globs** — `globs: "**/*.ts"` means the rule only loads for TypeScript files
3. **10-25 skills** — Fewer than 10 limits capability; more than 25 causes activation noise
4. **Hooks under 200ms** — Profile with `time python3 your-hook.py`
5. **One topic per rule file** — Keeps context loading surgical
6. **Deduplicate across plugins** — Two plugins covering the same domain waste context

## Measuring Your Setup

QuisHarness includes three eval scripts that score your setup:

| Script | What It Measures | Score |
|--------|-----------------|-------|
| `eval-claude-directory.sh` | Directory structure, hygiene | /25 |
| `eval-skill-activation.sh` | Skill description quality | /5 per skill |
| `eval-composite.sh` | Everything combined | Percentage |

Run them regularly as you customize your setup. A score above 80% on the composite eval indicates a well-optimized configuration.
