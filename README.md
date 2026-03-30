# QuisHarness

An optimized `~/.claude/` framework that gets your Claude Code setup from default to elite in 5 minutes. Eval scripts, rule templates, hook architecture, skill patterns, and a setup wizard — no trial and error required.

## What This Is

Most Claude Code users never go beyond the default `~/.claude/` directory. QuisHarness packages the patterns, rules, and eval scripts that emerged from systematic optimization research into an installable framework. It's not a plugin — it's the foundation your plugins sit on.

Read [How Claude Code Actually Works](docs/mental-model.md) for the mental model behind this framework.

## Before / After

```
BEFORE (default)                    AFTER (with QuisHarness)
~/.claude/                          ~/.claude/
├── CLAUDE.md (empty or bloated)    ├── CLAUDE.md (< 200 lines, focused)
├── settings.json                   ├── settings.json (hooks configured)
└── (nothing else)                  ├── keybindings.json
                                    ├── rules/common/ (9 rule files)
                                    ├── hooks/ (context injection, etc.)
                                    ├── scripts/ (eval + diagnostics)
                                    ├── skills/ (your custom skills)
                                    ├── output-styles/
                                    ├── agent-memory/
                                    └── warnings/
```

## Quick Start

```bash
git clone https://github.com/deserteaglemjAEC/QuisHarness.git
cd QuisHarness
bash install.sh
```

The installer backs up your existing files, copies the framework, and shows your eval score. Run `bash install.sh --dry-run` to preview without making changes.

**Post-install:** Review `templates/settings-example.json` and merge into your `~/.claude/settings.json`. Customize `hooks/memory-context.py` with your project directories and copy to `~/.claude/hooks/`.

## What's Included

| Component | Contents | Purpose |
|-----------|----------|---------|
| **templates/** | CLAUDE.md, settings example, keybindings | Optimized starting configuration |
| **rules/common/** | 9 rule files (coding, git, security, testing, etc.) | Global coding standards for every project |
| **scripts/** | 3 eval scripts + setup diagnostic | Score and improve your setup |
| **hooks/** | Memory context template + 2 examples | Hook architecture patterns |
| **skills/examples/** | 3 skill patterns (trigger, evolved, rich) | Best practices for writing skills |
| **output-styles/** | Brief output style | Response formatting preset |
| **docs/** | 5 deep-dive documents | Mental model, hooks, evals, plugins, directory guide |

## Eval Your Setup

QuisHarness includes three evaluation scripts:

```bash
# Directory structure score (25 points)
bash ~/.claude/scripts/eval-claude-directory.sh

# Skill description quality (per-skill scoring)
bash ~/.claude/scripts/eval-skill-activation.sh

# Everything combined (percentage)
bash ~/.claude/scripts/eval-composite.sh
```

A fresh install scores ~17-19/25 on the directory eval. The remaining points come from adding skills (via plugins) and configuring hooks. See [Eval Guide](docs/eval-guide.md) for details on each assertion and expected scores.

## How to Evaluate Plugins

QuisHarness is plugin-agnostic — it teaches you how to evaluate plugins rather than recommending specific ones. The 5 criteria:

1. **Activation Noise** — Does it fire on irrelevant prompts?
2. **Context Cost** — How much context window does it consume?
3. **Overlap Detection** — Does it duplicate another plugin?
4. **Update Frequency** — Is it actively maintained?
5. **Permission Scope** — What tools does it need?

Sweet spot: **10-25 plugins**. Read the full [Plugin Evaluation Framework](docs/plugin-evaluation.md).

## Hook Architecture

Hooks are scripts that run at specific points during a Claude Code session. QuisHarness includes templates for the most common patterns:

| Hook Type | When It Fires | Example Use |
|-----------|--------------|-------------|
| SessionStart | Session begins/resumes | Inject project context |
| PreToolUse | Before a tool runs | Block dangerous commands |
| PostToolUse | After a tool completes | Auto-format code |
| UserPromptSubmit | User sends a message | Classify prompts |

See [Hook Patterns](docs/hook-patterns.md) for skeleton code and configuration examples.

## Prerequisites

- **Claude Code CLI** installed ([claude.ai/code](https://claude.ai/code))
- **Bash** — macOS users may need `brew install bash` for Bash 4+ (macOS ships 3.2)
- **Python 3** — for hook templates (standard library only, no pip)

## FAQ

**Is this a plugin?**
No. QuisHarness is a framework — it installs templates, rules, and scripts to your `~/.claude/` directory. Plugins sit on top of this foundation.

**Does it require SuperMemory?**
No. The `memory-context.py` hook template shows a project-scoping pattern that works with any memory system. SuperMemory is one option; you can adapt it to whatever you use.

**Will it overwrite my settings.json?**
No. The installer deliberately skips `settings.json` to avoid breaking your existing configuration. Review `templates/settings-example.json` and merge manually.

**Why doesn't install.sh copy hooks?**
Hooks need customization for your specific projects and tools. The templates in `hooks/` are starting points — customize them, then copy to `~/.claude/hooks/`.

**How do I customize after installing?**
Edit `~/.claude/CLAUDE.md` to add your project-specific rules. Add rule files to `~/.claude/rules/`. Customize hooks for your workflow. Run the eval scripts to measure your changes.

**What if I already have a configured setup?**
Run `bash install.sh --dry-run` first to see what would change. The installer backs up existing files before overwriting anything.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to add rules, hook patterns, eval assertions, and documentation improvements.

## License

MIT - see [LICENSE](LICENSE)
