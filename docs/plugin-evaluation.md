# Plugin Evaluation Framework

How to evaluate Claude Code plugins before installing them. This framework helps you avoid common pitfalls: activation noise, context bloat, and plugin overlap.

## The 5 Evaluation Criteria

### 1. Activation Noise

**Question:** Does the plugin fire on irrelevant prompts?

A plugin with overly broad activation patterns triggers on conversations where it's not needed, consuming context and potentially confusing Claude.

**How to check:**
- Read the plugin's skill descriptions (in its SKILL.md files)
- Look for vague descriptions like "helps with coding" (too broad)
- Good descriptions have specific trigger phrases: "Use when creating React components"
- After installing, monitor whether the plugin injects context into unrelated conversations

**Red flag:** Plugin fires on > 30% of your prompts but is only relevant to < 10%.

### 2. Context Cost

**Question:** How much context window does the plugin consume?

Every plugin injects context — skill descriptions, hook output, reference docs. This competes with your actual work for the context window.

**How to check:**
- Count the plugin's SKILL.md files and their total line count
- Check if the plugin has hooks that inject context on every prompt
- Look at the plugin's `resources/` directories for large reference files

**Guidelines:**
- < 5K tokens total: Low impact, fine for most setups
- 5-15K tokens: Moderate — make sure you use it often enough to justify
- 15K+ tokens: Heavy — only install if it's core to your workflow

### 3. Overlap Detection

**Question:** Does this plugin duplicate another plugin's coverage?

Two plugins covering the same domain (e.g., two SEO plugins, two marketing plugins) cause conflicts: duplicate skill activations, contradictory advice, and wasted context.

**How to check:**
- Compare skill descriptions across plugins for the same keywords
- Check if existing rules/skills already cover the domain
- After installing, run `eval-skill-activation.sh` — look for skills with low unique-term scores (criterion #5)

**Rule of thumb:** One plugin per domain. If you need features from two overlapping plugins, choose the one with better activation descriptions and manually create rules for any gaps.

### 4. Update Frequency

**Question:** Is the plugin actively maintained?

Stale plugins may reference outdated APIs, deprecated tools, or incorrect patterns.

**How to check:**
- Check the plugin's Git repository for recent commits
- Look at the issue tracker for responsiveness
- Check if the plugin tracks Claude Code version updates

**Red flag:** No commits in 6+ months, or references to deprecated Claude Code features.

### 5. Permission Scope

**Question:** What tools does the plugin need access to?

Some plugins use hooks that need access to Bash, file system, or network. Understand what you're granting.

**How to check:**
- Read the plugin's `hooks.json` or settings configuration
- Look for `allowed-tools` in SKILL.md frontmatter
- Check if hooks run Bash commands (what commands? are they safe?)

**Principle of least privilege:** Only install plugins that need the tools they request.

## The Sweet Spot: 10-25 Plugins

Based on evaluation data:
- **< 10 plugins:** You're probably missing useful capabilities
- **10-25 plugins:** Sweet spot — enough coverage without noise
- **> 25 plugins:** Activation noise increases, context costs compound, overlap becomes likely

## Evaluation Checklist

Before installing a plugin:

- [ ] Read all SKILL.md descriptions — are they specific or vague?
- [ ] Check for overlap with existing plugins and skills
- [ ] Estimate context cost (total lines across all skill files)
- [ ] Check Git repository activity (last commit date, open issues)
- [ ] Review hook configurations for permission scope
- [ ] After installing: run `eval-skill-activation.sh` to verify no quality regression

## After Installing

1. Run `bash ~/.claude/scripts/eval-composite.sh` to get a new baseline
2. Use Claude Code for a few sessions and note any unexpected skill activations
3. If a plugin fires when it shouldn't, consider disabling it or filing an issue
4. Periodically re-run evals to catch quality drift
