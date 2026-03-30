#!/bin/bash
# eval-skill-activation.sh — Score skill descriptions for activation quality
# Metric: What % of skills have descriptions that would reliably trigger?
# Usage: bash ~/.claude/scripts/eval-skill-activation.sh
#
# Scoring per skill (0-5):
#   +1 description exists and is non-empty
#   +1 description has "Use when" or "Triggers on" phrases
#   +1 description length 50-500 chars (not too short, not too long)
#   +1 description has at least 3 trigger keywords/phrases
#   +1 description differentiates from other skills (unique terms)
#
# Part of QuisHarness — https://github.com/deserteaglemjAEC/QuisHarness

SKILLS_DIR="$HOME/.claude/skills"
TOTAL_SKILLS=0
TOTAL_SCORE=0
MAX_POSSIBLE=0
WEAK_SKILLS=""

# Extract full description from YAML frontmatter (handles folded scalars)
get_description() {
    local file="$1"
    python3 -c "
import sys
lines = open('$file').readlines()
in_front = False
in_desc = False
desc_lines = []
for line in lines:
    stripped = line.strip()
    if stripped == '---':
        if in_front:
            break
        in_front = True
        continue
    if in_front:
        if line.startswith('description:'):
            rest = line.split(':', 1)[1].strip()
            if rest in ('>', '|', '>-', '|-'):
                in_desc = True
            elif rest.startswith('\"'):
                desc_lines.append(rest.strip('\"'))
            else:
                desc_lines.append(rest)
        elif in_desc:
            if line[0] == ' ' or line[0] == '\t':
                desc_lines.append(stripped)
            else:
                in_desc = False
        # Not description field anymore
print(' '.join(desc_lines))
" 2>/dev/null
}

echo "=== SKILL ACTIVATION QUALITY EVAL ==="
echo ""

# Collect all descriptions for overlap analysis
declare -a ALL_DESCS
declare -a ALL_NAMES
idx=0

for skill_dir in "$SKILLS_DIR"/*/; do
    [ ! -f "$skill_dir/SKILL.md" ] && continue
    name=$(basename "$skill_dir")
    desc=$(get_description "$skill_dir/SKILL.md")
    ALL_DESCS[$idx]="$desc"
    ALL_NAMES[$idx]="$name"
    ((idx++))
done

TOTAL_SKILLS=$idx
MAX_POSSIBLE=$((TOTAL_SKILLS * 5))

echo "Analyzing $TOTAL_SKILLS skills..."
echo ""

for ((i=0; i<idx; i++)); do
    name="${ALL_NAMES[$i]}"
    desc="${ALL_DESCS[$i]}"
    score=0

    # 1. Description exists and is non-empty
    if [ -n "$desc" ] && [ ${#desc} -gt 10 ]; then
        ((score++))
        c1="PASS"
    else
        c1="FAIL (empty or too short)"
    fi

    # 2. Has trigger phrases ("Use when", "Triggers on", "Also use when")
    if echo "$desc" | grep -qiE "use when|triggers? on|also use when"; then
        ((score++))
        c2="PASS"
    else
        c2="FAIL (no trigger phrases)"
    fi

    # 3. Description length 50-500 chars
    desc_len=${#desc}
    if [ "$desc_len" -ge 50 ] && [ "$desc_len" -le 500 ]; then
        ((score++))
        c3="PASS ($desc_len chars)"
    elif [ "$desc_len" -gt 500 ]; then
        c3="WARN ($desc_len chars, verbose)"
        # Still count half credit for verbose but present descriptions
    else
        c3="FAIL ($desc_len chars, too short)"
    fi

    # 4. Has at least 3 quoted trigger terms or comma-separated keywords
    trigger_count=$(echo "$desc" | grep -oiE '"[^"]+"|'\''[^'\'']+'\''' | wc -l | tr -d ' ')
    if [ "$trigger_count" -lt 3 ]; then
        # Count comma-separated phrases after "Triggers on:" or similar
        trigger_count=$(echo "$desc" | grep -oiE '(triggers? on|use when[^.]*mentions?)[^.]*' | tr ',' '\n' | wc -l | tr -d ' ')
    fi
    if [ "$trigger_count" -ge 3 ]; then
        ((score++))
        c4="PASS ($trigger_count triggers)"
    else
        c4="FAIL ($trigger_count triggers, need >= 3)"
    fi

    # 5. Has unique terms not shared with other skills
    # Simple check: does it have at least 2 words not in any other description?
    unique_terms=0
    for word in $(echo "$desc" | tr ' ' '\n' | sort -u | grep -E '^[a-zA-Z]{5,}$' | head -20); do
        found_elsewhere=0
        for ((j=0; j<idx; j++)); do
            [ $j -eq $i ] && continue
            if echo "${ALL_DESCS[$j]}" | grep -qi "$word"; then
                found_elsewhere=1
                break
            fi
        done
        [ "$found_elsewhere" -eq 0 ] && ((unique_terms++))
    done
    if [ "$unique_terms" -ge 2 ]; then
        ((score++))
        c5="PASS ($unique_terms unique terms)"
    else
        c5="FAIL ($unique_terms unique terms)"
    fi

    TOTAL_SCORE=$((TOTAL_SCORE + score))

    # Only show details for non-perfect scores
    if [ "$score" -lt 5 ]; then
        echo "$name: $score/5"
        [ "$c1" != "PASS" ] && echo "  1. $c1"
        [ "$c2" != "PASS" ] && echo "  2. $c2"
        echo "  3. $c3"
        [ "$c4" != "PASS" ] && echo "  4. $c4"
        [ "$c5" != "PASS" ] && echo "  5. $c5"
        WEAK_SKILLS="$WEAK_SKILLS $name"
    fi
done

PERFECT=$((TOTAL_SKILLS - $(echo "$WEAK_SKILLS" | wc -w | tr -d ' ')))
PCT=$((TOTAL_SCORE * 100 / MAX_POSSIBLE))

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SCORE: $TOTAL_SCORE / $MAX_POSSIBLE ($PCT%)"
echo "PERFECT (5/5): $PERFECT / $TOTAL_SKILLS"
echo "NEED WORK:$(echo "$WEAK_SKILLS" | tr ' ' '\n' | sort | tr '\n' ' ')"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
