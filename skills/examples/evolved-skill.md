---
name: session-handoff
description: >
  Session start and context-resume protocol — read memory files, anchor to the plan,
  recap before planning next steps. Use when resuming work from a previous session,
  starting a new conversation, or picking up where we left off.
  Triggers on: "continue", "where were we", "resume", "pick up from last time",
  "what's the context", "session start".
evolved_from:
  - read-memory-on-start
  - session-recap-with-plan
  - implementation-plan-read-first
confidence: 0.88
evolved: 2026-03-01
---

# Session Handoff

This example demonstrates the EVOLVED SKILL pattern:
- `evolved_from` tracks which simpler skills were merged into this one
- `confidence` indicates how reliable the skill's activation is (0-1)
- `evolved` records when the skill was last refined
- This metadata helps track skill lineage and quality over time

## Session Start Protocol (in order)

1. Read `CLAUDE.md` — project rules and active context
2. Read memory files — persistent cross-session memory
3. Read implementation plan if it exists
4. If resuming: read the session handoff file

Never start executing without this context.

## Resuming a Project

- Provide a brief recap of where things left off
- State the next concrete step from the plan
- Offer a time-boxed plan for the current session (3-5 steps max)
- Anchor to the existing plan — don't free-associate new ideas

## Saving Session State

At the end of significant sessions:
- Write key decisions and progress to memory
- Update the implementation plan with completed steps
- Note any blockers or open questions
