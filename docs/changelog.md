# Changelog

All notable changes to QuisHarness are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/). This project uses [Conventional Commits](https://www.conventionalcommits.org/).

## [1.1.0] — 2026-03-29

GitHub repo optimization release — discoverability, professionalism, and community infrastructure.

### Added

- **README restructure** — badges (license, version, stars), "Why QuisHarness?" section, benefit-framed "What You Get" table, table of contents, star history chart, collapsible FAQ.
- **Social preview banner** (`assets/quisharness-banner.svg`) — 1280x640 branded SVG for GitHub and link sharing.
- **Issue templates** (`.github/ISSUE_TEMPLATE/`) — bug report and feature request templates.
- **PR template** (`.github/PULL_REQUEST_TEMPLATE.md`) — contribution checklist.
- **CI workflow** (`.github/workflows/ci.yml`) — shell syntax, Python compile, markdown link validation.
- **SECURITY.md** — security policy covering hook/skill/rule trust model.
- **Repo optimization verify script** (`scripts/verify-repo-optimization.sh`) — 13-check mechanical verification.
- **4 new docs** — project overview PDR, codebase summary, system architecture (with Mermaid diagrams), changelog.

## [1.0.0] — 2026-03-29

Initial public release.

### Added

- **Install wizard** (`install.sh`) — backup existing config, copy framework, create directories, run eval. Supports `--dry-run` and `--force` flags.
- **9 rule files** (`rules/common/`) — coding standards, coding style, Git workflow, security, testing, patterns, performance, hooks, agents.
- **3 eval scripts** (`scripts/`) — directory structure scoring (/25), skill activation quality (/5 per skill), composite setup score (percentage).
- **Setup diagnostic** (`scripts/setup-check.sh`) — verify prerequisites and directory health.
- **Hook templates** (`hooks/`) — memory context injection (SessionStart), prompt classification (UserPromptSubmit), skill activation routing.
- **3 skill examples** (`skills/examples/`) — trigger-based, evolved with resources, rich with reference docs.
- **Config templates** (`templates/`) — optimized CLAUDE.md, settings example with hooks, keybindings.
- **Output style** (`output-styles/brief.md`) — concise response formatting preset.
- **5 documentation files** (`docs/`) — mental model, directory guide, hook patterns, eval guide, plugin evaluation framework.
- **README** with quickstart, component table, before/after comparison, FAQ.
- **CONTRIBUTING.md** with code quality standards and pre-submit checklist.
