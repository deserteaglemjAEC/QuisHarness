# Research Artifact: GitHub Repo Optimization for QuisHarness

**Date:** 2026-03-29
**Phase:** Complete (Phases 1-5)
**Sources:** 14 (8 articles + 4 comparable repos + 2 reference guides)

---

## Executive Summary

QuisHarness has **strong content foundations** (README, CONTRIBUTING, LICENSE, docs, install wizard, eval scripts) but is **missing all the GitHub-specific infrastructure** that drives discoverability and professionalism. The repo currently has zero visual elements, zero badges, no `.github/` directory, no CI, no changelog, and no social preview image.

The Claude Code ecosystem has exploded to 9,094+ repos. The top performers (awesome-claude-code at 34k stars, claude-code-best-practice at 24.5k stars) all share: custom hero images, editorial voice, comparison tables, star history charts, and persona-based navigation. QuisHarness's differentiation — **it's the only framework-type repo with an install wizard, eval system, and opinionated structure** — is currently invisible because the README doesn't surface it visually.

---

## Part 1: What Top Repos Do (Cross-Source Consensus)

### README Structure (8 sources agree)

| Section | Priority | QuisHarness Status |
|---------|----------|-------------------|
| Logo + one-liner (10 words max) | CRITICAL | Has title, no logo |
| 3-5 badges (license, version, stars) | CRITICAL | MISSING |
| Demo GIF/screenshot (first viewport) | CRITICAL | MISSING |
| Benefit-focused feature bullets (4-7) | HIGH | Has table, not benefit-framed |
| Quick Start (sub-2-min, max 5 steps) | CRITICAL | EXISTS (good) |
| TOC with anchor links | HIGH | MISSING |
| "Why?" section (reader's perspective) | HIGH | MISSING |
| Contributing link | MEDIUM | EXISTS |
| License badge/link | MEDIUM | EXISTS (text only) |
| Star history chart | MEDIUM | MISSING |

### Growth Tactics (ranked by ROI)

1. **Hacker News post** — 1,200 stars in 24 hours (ScrapeGraphAI case study)
2. **Reddit communities** — r/ClaudeAI, r/LocalLLaMA, r/webdev — highest ROI for JS/CLI projects
3. **Personal network seeding** — ~60% conversion rate when asking directly (first 100 stars)
4. **Technical blog posts** — 500 stars/day when solving real community problems
5. **Twitter/X threads** — 800 stars/week focused on real problems
6. **awesome-list submissions** — awesome-claude-code (34k stars), awesome-claude-skills (10k stars)
7. **Dev.to / Cooperpress newsletters** — sustained traffic over time
8. **24-hour issue response time** — non-negotiable for trust building

### Repository Hygiene Checklist

| Item | Status | Impact |
|------|--------|--------|
| LICENSE (MIT) | DONE | Permissive = less friction |
| CONTRIBUTING.md | DONE | Signals maturity |
| .github/ISSUE_TEMPLATE/ | MISSING | Standardized bug/feature reports |
| .github/PULL_REQUEST_TEMPLATE.md | MISSING | PR quality gate |
| .github/workflows/ (CI) | MISSING | Signals active maintenance |
| SECURITY.md | MISSING | Trust signal |
| CODEOWNERS | MISSING | Low priority |
| CHANGELOG.md | MISSING | Active maintenance signal |
| Social preview image (1280x640) | MISSING | Link sharing on Twitter/Reddit |
| GitHub About section | PARTIAL | Topics done, no website URL |
| "good first issue" labels | MISSING | Indexed by goodfirstissue.dev |

---

## Part 2: Competitive Analysis (Claude Code Ecosystem)

### Ecosystem Positioning

| Repo | Stars | Type | Differentiation |
|------|-------|------|----------------|
| awesome-claude-code | 34,117 | Curated list | Editorial voice, multi-view, mascot |
| claude-code-best-practice | 24,550 | Best practices | 86 tips, source attribution, comparison tables |
| awesome-claude-skills | 10,066 | Skills list | Focused scope, getting started, clean layout |
| claude-code-ultimate-guide | 2,514 | Deep guide | Persona routing, MCP server, security DB |
| **QuisHarness** | **~0** | **Framework** | **Install wizard, eval system, opinionated structure** |

### QuisHarness's Unique Position

QuisHarness is the **only repo in the ecosystem that is a framework** rather than a guide or list. It:
- Ships an install wizard (`install.sh`) that sets up a complete Claude Code environment
- Includes an eval system (`scripts/run-eval.sh`) to measure setup quality
- Provides opinionated rules, hooks, skills, and templates as defaults
- Is designed to be forked/cloned and customized, not just read

This is a fundamentally different value proposition. The README needs to make this distinction crystal clear in the first 3 lines.

### Patterns to Adopt from Competitors

| Pattern | Source Repo | How to Apply |
|---------|------------|-------------|
| Custom hero image/banner | All 4 repos | Create branded banner with tagline |
| Star history chart | awesome-claude-code, best-practice | Add star-history.com embed |
| Comparison table | best-practice, ultimate-guide | "QuisHarness vs. manual setup" table |
| Collapsible sections | ultimate-guide, awesome-skills | Use `<details>` for FAQ, architecture |
| Badges row | All 4 repos | License, version, stars, install count |
| Demo GIF | best-practice (has GIFs) | Record `install.sh` and eval output |
| Persona-based routing | ultimate-guide | "New to Claude Code?" vs "Power user?" |
| Source attribution | best-practice | Credit influences in README |

### Patterns to Avoid

- **Over-long README** (best-practice, ultimate-guide) — keep QuisHarness README under 200 lines
- **Heavy SVG dependency** (best-practice) — use standard markdown + shields.io
- **Competitive positioning** (ultimate-guide) — don't compare against other repos, frame as complementary
- **Empty sections** (awesome-skills "coming soon") — only add sections with content
- **Badge overload** (best-practice top section) — max 5 badges

---

## Part 3: Gap Analysis — QuisHarness vs. Best Practices

### CRITICAL Gaps (blocks star growth)

1. **No demo GIF/screenshot** — "arguably the most important element" (Source 1). Visitors need to see `install.sh` running and eval output in < 5 seconds.

2. **No badges** — zero social proof signals. Need: license, version, stars count, "works with Claude Code" badge minimum.

3. **No social preview image** — when someone shares the GitHub link on Twitter/Reddit/HN, there's no card image. This is the #1 missed opportunity for viral sharing.

4. **No `.github/` infrastructure** — no issue templates, no CI, no PR template. Signals "hobby project" rather than "maintained framework."

5. **README not benefit-framed** — current "What's Included" table lists components but doesn't answer "why should I care?" Feature bullets need rewriting from capabilities to benefits.

### HIGH Gaps (accelerates growth)

6. **No "Why?" section** — readers need to understand the problem QuisHarness solves before they'll star it. "Most Claude Code setups are ad-hoc copy-paste..." framing.

7. **No TOC** — current README is navigable but lacks jump links for scannability.

8. **No CHANGELOG.md** — active maintenance signal. Even a simple "v1.0.0 — Initial release" entry.

9. **No star history chart** — social proof that compounds (every viewer sees growth trajectory).

10. **No ecosystem submission** — not listed on awesome-claude-code or awesome-claude-skills yet.

### MEDIUM Gaps (professional polish)

11. **No SECURITY.md** — trust signal for a framework that modifies Claude Code config.
12. **No "good first issue" labels** — blocks contributor discoverability.
13. **Before/After section uses ASCII art** — could be a side-by-side comparison table or screenshot instead.

---

## Part 4: Recommended README Structure (v2)

```markdown
<!-- Social preview: 1280x640 branded card -->

<p align="center">
  <img src="assets/hero-banner.png" alt="QuisHarness" width="600">
</p>

<p align="center">
  <strong>The opinionated Claude Code framework — install once, eval always.</strong>
</p>

<p align="center">
  <a href="LICENSE"><img src="shields.io/license-MIT-badge" alt="MIT License"></a>
  <a href="releases"><img src="shields.io/version-v1.0.0-badge" alt="Version"></a>
  <a href="stargazers"><img src="shields.io/stars-badge" alt="Stars"></a>
  <a href="#quick-start"><img src="shields.io/install-30s-badge" alt="Install"></a>
</p>

<!-- Demo GIF: install.sh running → eval output → score -->
<p align="center">
  <img src="assets/demo.gif" alt="QuisHarness install and eval demo" width="600">
</p>

## Why QuisHarness?

Most Claude Code setups are copy-paste from blog posts — no structure, no
evaluation, no way to know if your setup is actually good. QuisHarness gives
you a tested, opinionated foundation with a built-in eval system to prove it.

## What You Get

| Benefit | Details |
|---------|---------|
| 30-second install | One command sets up rules, hooks, skills, and templates |
| Built-in eval system | Score your setup against 15+ assertions |
| Plugin evaluation | Test any community plugin before trusting it |
| Battle-tested defaults | 9 rules, 2 hook patterns, 3 skill examples |
| Safe and reversible | Backups everything before touching your config |

## Quick Start

[existing quick start — verified sub-2-min]

## What's Included

[existing component table — keep as-is]

## Eval Your Setup / How to Evaluate Plugins

[existing sections]

<details><summary>Hook Architecture</summary>
[existing hook table]
</details>

<details><summary>FAQ</summary>
[existing FAQ]
</details>

## Contributing

[link to CONTRIBUTING.md]

## License

MIT

---

<p align="center">
  <a href="star-history-link">
    <img src="star-history-chart" alt="Star History">
  </a>
</p>
```

---

## Part 5: Launch Distribution Plan

### Week 1: Repo Polish (before any promotion)
- [ ] Create hero banner (1280x640 for social preview + 600px for README)
- [ ] Record demo GIF (install.sh → eval → score output)
- [ ] Add badges (license, version, stars)
- [ ] Restructure README per v2 template above
- [ ] Add `.github/` infrastructure (issue templates, PR template, CI)
- [ ] Create CHANGELOG.md
- [ ] Add SECURITY.md
- [ ] Set social preview image on GitHub

### Week 2: Seed Stars (target: 50)
- [ ] Personal network outreach with specific problem statement
- [ ] Submit to awesome-claude-code (issue on their repo)
- [ ] Submit to awesome-claude-skills (PR)
- [ ] Post in Claude Code Discord/community channels

### Week 3: Public Launch (target: 100-200)
- [ ] Reddit post: r/ClaudeAI (primary), r/LocalLLaMA, r/webdev
- [ ] Dev.to article: "How I Evaluate My Claude Code Setup"
- [ ] Twitter/X thread: problem → solution → demo GIF → link
- [ ] Hacker News: Show HN post

### Week 4+: Sustain
- [ ] 24-hour issue response commitment
- [ ] Weekly small updates (new rule, new hook example, eval improvement)
- [ ] Technical blog posts solving community problems
- [ ] Engage in Claude Code communities (70/30 help-to-promote ratio)

---

## Key Metrics to Track

| Metric | Tool | Target (90 days) |
|--------|------|-------------------|
| GitHub stars | star-history.com | 500+ |
| README click-through | GitHub Traffic | 10%+ |
| Clone count | GitHub Traffic | 100+ |
| Issue response time | GitHub | < 24 hours |
| Contributor count | GitHub | 5+ |
| awesome-list inclusion | Manual check | 2+ lists |

---

## Sources

1. dev.to/belal_zahran — README template patterns
2. blog.beautifulmarkdown.com — 10 README examples analysis
3. daytona.io — 4000-stars README guide
4. dev.to/nastyox1 — 9 steps to 100 stars
5. devactivity.com — OSS project foundations
6. linuxfoundation.org — Hosting OS projects on GitHub
7. blog.tooljet.com — 12 ways to get stars (ToolJet case study)
8. scrapegraphai.com — 10 ways to boost stars (ScrapeGraphAI case study)
9. hesreallyhim/awesome-claude-code — 34,117 stars
10. shanraisshan/claude-code-best-practice — 24,550 stars
11. FlorianBruniaux/claude-code-ultimate-guide — 2,514 stars
12. travisvn/awesome-claude-skills — 10,066 stars
13. 10up.github.io — OSS best practices (reference)
14. star-history.com — GitHub stars playbook (reference)
