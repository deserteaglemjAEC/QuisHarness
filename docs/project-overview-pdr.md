# Project Overview — QuisHarness

## What It Is

QuisHarness is an opinionated `~/.claude/` framework for Claude Code. It packages the directory structure, rules, hooks, eval scripts, and skill patterns that emerged from systematic optimization research into a single installable toolkit.

## Problem Statement

Most Claude Code users never optimize beyond the default setup. The result:

- **Bloated CLAUDE.md** — instructions competing for attention budget
- **No eval system** — no way to measure if a setup is actually good
- **Plugin chaos** — overlapping plugins wasting context window
- **Ad-hoc hooks** — no patterns for common automation tasks
- **Trial and error** — each user rediscovers the same lessons

## Solution

QuisHarness provides:

1. **Tested defaults** — 9 rule files, hook templates, skill examples, output styles
2. **Eval scripts** — 3 scoring scripts that measure directory structure, skill quality, and overall setup health
3. **Install wizard** — `install.sh` backs up existing config, copies the framework, runs eval
4. **Plugin evaluation framework** — 5-criteria methodology for evaluating any plugin
5. **Documentation** — mental model, hook patterns, directory guide, eval guide

## Target Users

- Claude Code users who want a structured, measurable setup
- Developers evaluating or building Claude Code plugins
- Teams standardizing their Claude Code configuration

## Project Type

CLI framework — shell scripts (Bash), Python hooks, Markdown documentation. No package manager, no build step, no runtime dependencies beyond Python 3 standard library.

## Key Decisions

| Decision | Rationale |
|----------|-----------|
| No package.json | Not a Node package — installs via `git clone` + `bash install.sh` |
| MIT license | Maximum adoption — no friction for any user |
| Hooks are templates, not auto-installed | Hooks need customization per user — forcing defaults would break setups |
| settings.json is never overwritten | Most destructive possible action — users merge manually |
| Eval scores, not opinions | Framework teaches measurement, not "use plugin X" |

## Repository

- **Remote:** `git@github.com:deserteaglemjAEC/QuisHarness.git`
- **License:** MIT
- **Current version:** v1.0.0
