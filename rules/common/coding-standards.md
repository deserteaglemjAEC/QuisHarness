---
globs: "**/*.{ts,js,py,go,rs}"
description: Universal coding conventions applied across all projects
---

# Coding Standards

## Immutability
Always create new objects. Never mutate existing ones. Immutable data prevents hidden side effects.

## File Organization
- Many small files > few large files
- 200-400 lines typical, 800 max
- Organize by feature/domain, not by type

## Error Handling
- Handle errors explicitly at every level
- User-friendly messages in UI, detailed logs on server
- Never silently swallow errors

## Input Validation
- Validate all user input at system boundaries
- Use schema-based validation where available
- Fail fast with clear error messages

## Functions
- Small (<50 lines)
- No deep nesting (>4 levels)
- No hardcoded values (use constants or config)

## Language Note
These defaults target TypeScript/JavaScript conventions. Override with project-level rules for language-specific idioms (e.g., Go uses idiomatic mutation via pointer receivers, Python uses different naming conventions).
