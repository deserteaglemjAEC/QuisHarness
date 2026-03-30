# Directory Guide

This guide shows the optimal `~/.claude/` directory layout and explains what each component does.

## Default vs Optimized

### Default (out of the box)

```
~/.claude/
├── CLAUDE.md          ← Often empty or overstuffed
├── settings.json      ← Minimal config
└── (that's it)
```

Most users never go beyond this. Claude Code works, but it's not optimized.

### Optimized (with QuisHarness)

```
~/.claude/
├── CLAUDE.md                  ← Compact (< 200 lines), focused on behavior rules
├── settings.json              ← Hooks configured, plugins enabled, env vars set
├── keybindings.json           ← Custom keyboard shortcuts
│
├── rules/
│   └── common/                ← Global rules (apply to all projects)
│       ├── coding-standards.md
│       ├── coding-style.md
│       ├── git.md
│       ├── security.md
│       ├── testing.md
│       ├── patterns.md
│       ├── performance.md
│       ├── hooks.md
│       └── agents.md
│
├── hooks/                     ← Scripts that run at specific events
│   ├── memory-context.py      ← SessionStart: inject project context
│   ├── skill-activation.sh    ← UserPromptSubmit: route to skills
│   └── prompt-improver.py     ← UserPromptSubmit: classify prompts
│
├── scripts/                   ← Eval and utility scripts
│   ├── eval-claude-directory.sh
│   ├── eval-skill-activation.sh
│   ├── eval-composite.sh
│   └── setup-check.sh
│
├── skills/                    ← Custom skills (10-30 ideal)
│   ├── my-skill/
│   │   ├── SKILL.md           ← Skill definition with description
│   │   └── resources/         ← Optional reference documents
│   └── another-skill/
│       └── SKILL.md
│
├── output-styles/             ← Response formatting presets
│   └── brief.md
│
├── agent-memory/              ← Persistent memory across sessions
│
└── warnings/                  ← Warning state tracking
```

## Component Reference

### CLAUDE.md (< 200 lines)

Your global instruction file. Claude Code reads this at the start of every session. Keep it focused on **behavioral rules** — move detailed instructions to `rules/` files.

**What goes here:** Security rules, tool usage priorities, planning discipline, session continuity protocol.

**What doesn't:** Project-specific instructions (use project `.claude/CLAUDE.md`), detailed coding standards (use `rules/`), plugin configuration.

### rules/common/ (< 200 lines each)

Global rules applied across all projects. Each file covers one topic. Use `globs` in frontmatter to limit which files trigger the rule:

```yaml
---
globs: "**/*.{ts,js}"
description: TypeScript/JavaScript coding conventions
---
```

### hooks/ (< 200ms each)

Scripts that fire at specific events. Must be fast — they block Claude Code's response.

### skills/ (10-30 skills, < 500 lines each)

Custom skills with activation descriptions. The description field determines when a skill fires, not the file name. See `skills/examples/` for patterns.

### scripts/

Utility and evaluation scripts. Not loaded into Claude Code's context — these are tools you run manually.

### output-styles/

Markdown files that define how Claude formats responses. Select in the Claude Code UI.

### agent-memory/

Directory for persistent memory files. Referenced from CLAUDE.md or hooks to maintain context across sessions.

## Size Guidelines

| Component | Max Lines | Reason |
|-----------|-----------|--------|
| CLAUDE.md | 200 | Read every session — bloat wastes context |
| Each rule file | 200 | Focused rules load faster |
| Each SKILL.md | 500 | Large skills crowd out other context |
| Each hook script | 100 | Hooks must be fast and focused |
| Total files in root | 15 | Clutter indicates poor organization |
