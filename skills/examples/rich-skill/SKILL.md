---
name: deep-research
description: >
  5-phase research methodology for building expert-level understanding of any topic.
  Use when the user asks to research a topic deeply, compare options with evidence,
  understand a technology landscape, or produce a research artifact. Also use when the
  user says "research this", "deep dive on", "what do experts say about", "help me
  understand", "compare X vs Y with real data".
  NOT for quick lookups or simple factual questions.
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - WebSearch
  - WebFetch
  - Agent
---

# Deep Research Skill

This example demonstrates the RICH SKILL pattern:
- `allowed-tools` in frontmatter restricts which tools the skill can use
- A `resources/` subdirectory holds reference documents the skill can read
- This structure keeps supporting content organized alongside the skill

## Methodology

### Phase 1: Discover (5 min)
Find WHO is talking — top voices, primary sources, key vocabulary.

### Phase 2: Read Primary Sources (15-30 min)
Read what experts ACTUALLY wrote, not summaries. Prioritize official docs,
top repositories, and high-engagement posts with comments.

### Phase 3: Synthesize (10 min)
Find consensus, contradictions, and gaps across all sources.

### Phase 4: Cross-Examine (5 min)
Stress-test the synthesis. Use a different model or perspective to challenge findings.

### Phase 5: Distill (5 min)
Compress into ONE actionable artifact. Choose format: reference doc, checklist,
template, or decision doc.

## Resources

See `resources/example-ref.md` for a template showing how reference documents
are structured alongside skills.
