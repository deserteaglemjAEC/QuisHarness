# Performance Optimization

> Last verified: 2026-03. Check for newer model releases before relying on specific model names.

## Model Selection Strategy

**Lightweight model** (e.g., Haiku — 90% of mid-tier capability, 3x cost savings):
- Lightweight agents with frequent invocation
- Pair programming and code generation
- Worker agents in multi-agent systems

**Default coding model** (e.g., Sonnet — best balance of speed and quality):
- Main development work
- Orchestrating multi-agent workflows
- Complex coding tasks

**Reasoning model** (e.g., Opus — deepest reasoning):
- Complex architectural decisions
- Maximum reasoning requirements
- Research and analysis tasks

## Context Window Management

Avoid last 20% of context window for:
- Large-scale refactoring
- Feature implementation spanning multiple files
- Debugging complex interactions

Lower context sensitivity tasks:
- Single-file edits
- Independent utility creation
- Documentation updates
- Simple bug fixes

## Extended Thinking

Extended thinking is DISABLED by default (alwaysThinkingEnabled: false in settings.json).

Toggle with: Option+T (macOS) / Alt+T (Windows/Linux)
Or enable permanently: set alwaysThinkingEnabled: true in ~/.claude/settings.json

When enabled, reserves up to 31,999 tokens for internal reasoning.
Budget cap: export MAX_THINKING_TOKENS=10000
Verbose mode: Ctrl+O to see thinking output

Best for: complex architectural decisions, multi-file refactors, debugging complex interactions.

## Build Troubleshooting

If build fails:
1. Use **build-error-resolver** agent
2. Analyze error messages
3. Fix incrementally
4. Verify after each fix
