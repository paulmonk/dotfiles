---
name: homunculus-instinct-status
description: Show all learned instincts with their confidence levels. Use when user wants to see what patterns have been learned or check instinct confidence scores.
allowed-tools: Bash Read
metadata:
  user-invocable: "true"
---

# Instinct Status

Shows all learned instincts with their confidence scores, grouped by domain.

## Usage

```
/homunculus-instinct-status
/homunculus-instinct-status --domain code-style
```

## Implementation

### List all instincts

```bash
~/.claude/skills/homunculus-instinct-status/scripts/list
```

### Filter by domain

```bash
~/.claude/skills/homunculus-instinct-status/scripts/list code-style
```

### Show single instinct

```bash
cat ~/.claude/homunculus/instincts/personal/[NAME].md
```

### Pending observations

```bash
wc -l < ~/.claude/homunculus/observations.jsonl 2>/dev/null || echo "0"
```

## Output Format

Present the script output as a table grouped by domain:

```
## CODE-STYLE (3)

| Confidence | Name | Trigger |
|------------|------|---------|
| 0.7 | prefer-functional | when writing new functions |
| 0.6 | use-path-aliases | when importing modules |

## TESTING (2)

| Confidence | Name | Trigger |
|------------|------|---------|
| 0.8 | test-first | when adding new functionality |
```
