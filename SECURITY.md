# Security Policy

## Scope

QuisHarness installs configuration files to `~/.claude/`. It modifies:

- **CLAUDE.md** — text instructions for Claude Code
- **rules/** — markdown rule files
- **scripts/** — bash and python scripts (eval and diagnostics only)
- **skills/examples/** — markdown skill templates
- **output-styles/** — markdown response formatting
- **keybindings.json** — keyboard shortcut config

It does **not** modify `settings.json` (which controls permissions and hooks).

## Reporting a Vulnerability

If you discover a security issue in QuisHarness:

1. **Do not** open a public issue
2. Email the maintainer directly or use [GitHub Security Advisories](https://github.com/deserteaglemjAEC/QuisHarness/security/advisories/new)
3. Include steps to reproduce and potential impact

## What to Watch For

Since QuisHarness provides hook templates and skill patterns that run within Claude Code:

- **Hook scripts** execute with your user permissions — review any hook before copying to `~/.claude/hooks/`
- **Skill content** is injected into Claude Code's context — malicious skill content could influence AI behavior
- **Rule files** shape Claude Code's behavior — review rules before applying

## Supported Versions

| Version | Supported |
|---------|-----------|
| 1.0.x | Yes |
