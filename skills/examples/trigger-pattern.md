---
name: code-review-checklist
description: >
  Automated code review checklist — verify tests pass, check for security issues,
  validate error handling, and confirm no hardcoded secrets before marking work complete.
  Use when about to commit code, finishing a feature, or reviewing a PR.
  Triggers on: "review", "done", "ready to commit", "check my code", "PR ready",
  "code review", "before I push".
---

# Code Review Checklist

This example demonstrates the TRIGGER PATTERN for skill descriptions:
- `Use when` phrases tell Claude WHEN to activate this skill
- `Triggers on` phrases list specific keywords/phrases that match
- 3+ trigger keywords ensure reliable activation
- The description is 50-500 characters (sweet spot for activation)

## Rules

### Always run tests before claiming done
Before saying any feature or fix "works," run the actual test suite. Report what
was tested, what the output was, whether it passed.

### Check for security issues
- No hardcoded secrets (API keys, passwords, tokens)
- All user inputs validated
- Error messages don't leak sensitive data

### Verify error handling
- Errors are caught and handled, not silently swallowed
- User-facing errors are friendly; server logs are detailed

### Confirm formatting
If the project has a linter or formatter, run it. Unformatted code is not done.
