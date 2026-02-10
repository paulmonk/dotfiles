---
name: homunculus-feedback
description: Correct or reinforce a learned instinct. Use when an instinct is wrong, too weak, or should be boosted.
allowed-tools: Bash Read Edit
metadata:
  user-invocable: "true"
---

# Instinct Feedback

Adjusts confidence on a learned instinct based on user feedback.

## Usage

```text
/homunculus-feedback <instinct-name> wrong    # Reduce to minimum (0.20)
/homunculus-feedback <instinct-name> weak     # Reduce confidence by 0.15
/homunculus-feedback <instinct-name> strong   # Boost confidence by 0.10
```

The `<instinct-name>` is the filename without `.md`
(e.g., `code-style-hook-file-patterns`).

## Implementation

### Find the instinct

```bash
INSTINCT_DIR=~/.claude/homunculus/instincts/personal
INSTINCT_FILE="${INSTINCT_DIR}/${INSTINCT_NAME}.md"

if [[ ! -f "${INSTINCT_FILE}" ]]; then
  echo "Instinct not found: ${INSTINCT_NAME}"
  echo "Available instincts:"
  ls "${INSTINCT_DIR}" | sed 's/.md$//'
  exit 1
fi
```

### Apply feedback

Read the current confidence from the instinct file, then
update based on the action:

- **wrong**: Set confidence to `0.20` (minimum floor,
  same as decay minimum)
- **weak**: Reduce confidence by `0.15`, minimum `0.20`
- **strong**: Increase confidence by `0.10`, maximum
  `0.90`, and update `last_seen` to now

Use `sed -i ''` to update the YAML frontmatter in-place:

```bash
# Update confidence
sed -i '' "s/^confidence:.*/confidence: ${NEW_CONFIDENCE}/" "${INSTINCT_FILE}"

# Update last_seen (only for strong feedback)
sed -i '' "s/^last_seen:.*/last_seen: $(date -u +%Y-%m-%dT%H:%M:%SZ)/" "${INSTINCT_FILE}"
```

### Report

After updating, show the instinct's current state:

```bash
cat "${INSTINCT_FILE}"
```

## Workflow

1. Parse the instinct name and action from the user's command
2. Validate the instinct file exists
3. Read current confidence value
4. Calculate new confidence based on action
5. Update the file in-place
6. Show the updated instinct to confirm
