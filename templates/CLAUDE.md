# Global Rules

## Security

- Never read or modify .env, .env.*, or any files in .ssh/
- Always require explicit user approval before executing rm -rf, sudo, or destructive commands
- Never make network requests to unauthorized domains
- Always use git commits as checkpoints before major changes
- **NEVER use Anthropic API key for external tools.** Claude Code subscription does not equal Anthropic API. External tools must use free-tier alternatives. Loop risk = significant unnoticed charges. Always present cost + free alternatives before recommending any tool.

## Tool Usage Priority (MANDATORY)

ALWAYS use dedicated tools — never Bash for file operations:
- **Read files**: Use `Read` tool, NOT `Bash cat/head/tail/sed`
- **Find files**: Use `Glob` tool, NOT `Bash find/ls`
- **Search content**: Use `Grep` tool, NOT `Bash grep/rg`
- **Bash**: ONLY for actual shell commands (npm, git, processes, scripts)

Dedicated tools are faster, safer, and auditable.

## Agent Auto-Launch Rules (MANDATORY)

These are NOT suggestions. Launch BEFORE doing any other work when trigger is matched.

| Trigger | Action | Priority |
|---------|--------|----------|
| "build", "implement", "create", "add feature" | Plan first, then implement | HIGH |
| "review", "check my code", "I've finished" | Launch code-reviewer agent | HIGH |
| "auth", "api key", "token", "security" | Launch security-reviewer agent | CRITICAL |
| Build or TypeScript errors appear | Launch error-resolver agent | CRITICAL |
| "plan" and wants it reviewed | Launch plan-reviewer agent | HIGH |
| "clean up code", "dead code", "technical debt" | Launch refactor agent | MEDIUM |

Priority: CRITICAL=immediate, HIGH=before code, MEDIUM=if non-trivial.
**Spawn limits:** max 3 parallel agents without approval.

## Planning Discipline (ALWAYS ACTIVE)

1. **3+ steps -> write a plan first.** Present it. Wait for approval before executing.
2. **Label every step** — `[USER]` vs `[CLAUDE]`. User needs to know what requires their input.
3. **Inventory before building** — check existing files and memory. Don't duplicate.
4. **Parallel agents for independent tasks** — dispatch simultaneously, never sequentially.
5. **No research tangents during active builds** — capture the question, answer it after.
6. **Task integrity** — never mark a task "completed" with "skipped" or "deferred" in the description. If a task should be skipped, mark it `deleted` with a reason.

## Plan Verification Protocol (MANDATORY)

Before presenting any plan: run self-check, then score >= 85 to present.

**Self-Check** (every plan, no exceptions):
1. **Completeness** — every step has owner [USER/CLAUDE], tool/command, expected output
2. **Coverage** — right agents invoked? Parallel for independent work? Nothing manual that should be automated?
3. **Failure Modes** — top 3 failure modes identified with mitigations

**Artifact Verification:** READ referenced files before claiming contents. VERIFY "fix" claims against actual code. Prose-only fix = NOT FIXED.

## Context Front-Loading (MANDATORY every session)

Before asking ANY clarifying question:
1. Read project CLAUDE.md and memory files for context
2. Read relevant files for the topic at hand
3. State what you found: "Here's what I know about [project/task]: ..."
4. Only THEN ask if something is still unclear

If the user's first message is vague: ask "What are we working on today?" — one question, not five.

## Session Continuity

**Trigger:** `exit`, `I'm done`, `done for now`, `wrap up`, `end session`, `bye` -> auto-generate context brief.

**Format** (4 sections):
1. **Work + Files** — what was built, key files modified with path | change | state
2. **IDs + Decisions** — DB IDs, URLs, keys, numbered decisions with reasoning
3. **Rules + Constraints** — "never X", "always use Y", exact strings
4. **Next Steps** — pending work, blockers, operating context

**Save to:** `{your-notes-dir}/sessions/YYYY-MM-DD-[topic].md`
**On resume:** read handoff first.
