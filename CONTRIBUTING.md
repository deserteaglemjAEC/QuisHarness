# Contributing to QuisHarness

Thanks for your interest in improving QuisHarness! This guide covers how to contribute.

## Quick Start

1. Fork the repo
2. Create a feature branch: `git checkout -b feat/your-feature`
3. Make your changes
4. Run evals before submitting: `bash scripts/eval-claude-directory.sh`
5. Submit a PR

## What You Can Contribute

### New Rule Files
- Add to `rules/common/` as a `.md` file
- Keep under 200 lines
- Focus on one topic per file
- Must be language/framework agnostic (or clearly labeled)

### Hook Patterns
- Add examples to `hooks/examples/`
- Include heavy comments explaining the pattern
- Do NOT include personal data, API keys, or project-specific logic
- Test that the hook runs without errors (or mark as `.example` if it's documentation-only)

### Eval Assertions
- Add to existing eval scripts in `scripts/`
- Each assertion should test ONE thing
- Include a clear PASS/FAIL message
- Update `docs/eval-guide.md` with the new assertion

### Documentation
- Improve existing docs in `docs/`
- Fix broken links
- Add diagrams or examples

## Code Quality

### Shell Scripts
- Run `shellcheck` on all `.sh` files before submitting
- Use `set -e` at the top of scripts
- Quote all variables: `"$VAR"` not `$VAR`
- Avoid Bash 4+ features (associative arrays) for macOS compatibility

### Python
- Keep to standard library only (no pip dependencies)
- Python 3.8+ compatible
- Include docstrings for functions

### Markdown
- No personal data, client names, or API keys
- Use relative links for cross-references
- Keep files under 800 lines

## Commit Messages

Follow conventional commits:
```
feat: add new eval assertion for hook latency
fix: correct line count in directory eval
docs: update hook patterns with PostToolUse example
chore: update gitignore
```

## Before Submitting

- [ ] Run `bash scripts/eval-claude-directory.sh` — no regressions
- [ ] Run `grep -ri "HOLSTC\|Undrdog\|Betterbrand\|kinetide" .` — must return 0 results
- [ ] No files exceed 800 lines
- [ ] All relative links in docs/ resolve to real files
