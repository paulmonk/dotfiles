---
name: homunculus-evolve
description: >-
  Promote mature instincts to permanent convictions. Use when
  instincts have high confidence and proven longevity.
allowed-tools: Bash Read Write Edit
metadata:
  user-invocable: "true"
---

# Promote Instincts to Convictions

Scans instincts for promotion candidates (mature, high-confidence
patterns) and promotes them to permanent convictions.

## Usage

```text
/homunculus-evolve                 # Preview promotion candidates
/homunculus-evolve --promote       # Execute promotion
```

## Implementation

### Find promotion candidates

An instinct qualifies for promotion when ALL criteria are met:

```bash
now=$(date +%s)

for f in ~/.claude/homunculus/instincts/personal/*.md; do
  [ -f "$f" ] || continue

  # Skip already-promoted instincts.
  grep -q "^promoted: true" "$f" && continue

  confidence=$(sed -n 's/^confidence: *//p' "$f" | head -1)
  created=$(sed -n 's/^created: *//p' "$f" | head -1)
  last_seen=$(sed -n 's/^last_seen: *//p' "$f" | head -1)

  # Confidence >= 0.75
  awk "BEGIN{exit(!($confidence >= 0.75))}" || continue

  # Created >= 14 days ago (survived 2+ decay cycles)
  created_ts=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$created" +%s 2>/dev/null || echo 0)
  (( now - created_ts >= 14 * 86400 )) || continue

  # Last seen within 7 days (still actively relevant)
  last_seen_ts=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$last_seen" +%s 2>/dev/null || echo 0)
  (( now - last_seen_ts <= 7 * 86400 )) || continue

  echo "$f"
done
```

### Preview mode (default)

Read each candidate instinct and display:

- Filename, trigger, action, confidence, age, last seen
- The conviction rule that would be added
- Count of total candidates

If no candidates found, report that and check for staleness
warnings (see below).

### Promote (--promote flag)

For each approved candidate:

1. Read the instinct's trigger and action
2. Append to `~/.claude/homunculus/convictions.md`:

```markdown
- **[short name from trigger]**: [action as a concise imperative sentence].
```

If the file does not exist, create it with the header:

```markdown
# Convictions

Instincts promoted to permanent rules after sustained high confidence.
These are injected at session start and do not decay.

```

3. Add promotion metadata to the instinct frontmatter:

```bash
sed -i '' '/^---$/,/^---$/{
  /^last_seen:/a\
promoted: true\
promoted_to: ~/.claude/homunculus/convictions.md
}' "$instinct_file"
```

4. Update identity.json timestamp:

```bash
jq '.last_promotion = "'"$(date -u +%Y-%m-%dT%H:%M:%SZ)"'"' \
  ~/.claude/homunculus/identity.json > tmp.json && mv tmp.json ~/.claude/homunculus/identity.json
```

### Staleness check

After processing promotions, scan for promoted instincts that have decayed:

```bash
for f in ~/.claude/homunculus/instincts/personal/*.md; do
  [ -f "$f" ] || continue
  grep -q "^promoted: true" "$f" || continue
  confidence=$(sed -n 's/^confidence: *//p' "$f" | head -1)
  if awk "BEGIN{exit(!($confidence < 0.40))}"; then
    echo "WARNING: Promoted instinct $(basename "$f") has decayed to $confidence."
    echo "  The conviction may be stale. Consider removing it from convictions.md."
  fi
done
```

Report any stale promoted instincts to the user.
