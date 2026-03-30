# Example Reference Document

This file demonstrates the `resources/` convention for skills.

## Purpose

Skills can include a `resources/` subdirectory for:
- Reference templates (artifact formats, report structures)
- Prompt libraries (cross-examination prompts, discovery queries)
- Lookup tables (source quality rankings, evaluation criteria)
- Configuration files (scoring rubrics, threshold values)

## How Skills Reference Resources

In the skill's SKILL.md, use relative paths:

```markdown
See [source-hierarchy.md](resources/source-hierarchy.md) for rankings.
```

Claude Code resolves these relative to the skill directory.

## Guidelines

- Keep each resource file focused on ONE reference topic
- Use markdown for readability
- Don't duplicate content that belongs in the skill's main SKILL.md
- Resources are loaded on-demand, not automatically — the skill must reference them
