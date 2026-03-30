#!/usr/bin/env bash
# Verify script for GitHub repo optimization
# Checks research-identified gaps mechanically
# Metric: number of checks passing (out of 13)

set -euo pipefail
REPO_ROOT="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
SCORE=0
TOTAL=13

# 1. Badges in README (shields.io or img.shields.io)
if grep -q 'shields.io\|img.shields' "$REPO_ROOT/README.md" 2>/dev/null; then
  SCORE=$((SCORE + 1))
fi

# 2. Demo GIF/screenshot in README (img tag or markdown image)
if grep -q '!\[.*\](.*\.\(gif\|png\|jpg\|svg\|webp\))' "$REPO_ROOT/README.md" 2>/dev/null; then
  SCORE=$((SCORE + 1))
fi

# 3. Social preview image exists
if find "$REPO_ROOT/assets" -maxdepth 1 -name '*.png' -o -name '*.jpg' -o -name '*.svg' 2>/dev/null | grep -q .; then
  SCORE=$((SCORE + 1))
fi

# 4. .github/ directory exists
if [ -d "$REPO_ROOT/.github" ]; then
  SCORE=$((SCORE + 1))
fi

# 5. Issue template(s) exist
if find "$REPO_ROOT/.github/ISSUE_TEMPLATE" -maxdepth 1 -name '*.md' -o -name '*.yml' 2>/dev/null | grep -q .; then
  SCORE=$((SCORE + 1))
fi

# 6. PR template exists
if [ -f "$REPO_ROOT/.github/PULL_REQUEST_TEMPLATE.md" ] || [ -f "$REPO_ROOT/.github/pull_request_template.md" ]; then
  SCORE=$((SCORE + 1))
fi

# 7. CI workflow exists
if find "$REPO_ROOT/.github/workflows" -maxdepth 1 -name '*.yml' -o -name '*.yaml' 2>/dev/null | grep -q .; then
  SCORE=$((SCORE + 1))
fi

# 8. CHANGELOG.md exists in docs/
if [ -f "$REPO_ROOT/docs/changelog.md" ] || [ -f "$REPO_ROOT/CHANGELOG.md" ]; then
  SCORE=$((SCORE + 1))
fi

# 9. SECURITY.md exists
if [ -f "$REPO_ROOT/SECURITY.md" ] || [ -f "$REPO_ROOT/.github/SECURITY.md" ]; then
  SCORE=$((SCORE + 1))
fi

# 10. "Why" section in README
if grep -qi '## Why\|## Why QuisHarness' "$REPO_ROOT/README.md" 2>/dev/null; then
  SCORE=$((SCORE + 1))
fi

# 11. TOC / table of contents in README
if grep -q '\- \[.*\](#' "$REPO_ROOT/README.md" 2>/dev/null; then
  SCORE=$((SCORE + 1))
fi

# 12. Benefit-framed features (look for "What You Get" or benefit language)
if grep -qi 'What You Get\|benefit\|you get\|gives you' "$REPO_ROOT/README.md" 2>/dev/null; then
  SCORE=$((SCORE + 1))
fi

# 13. Star history chart in README
if grep -qi 'star-history\|star history' "$REPO_ROOT/README.md" 2>/dev/null; then
  SCORE=$((SCORE + 1))
fi

echo "$SCORE"
