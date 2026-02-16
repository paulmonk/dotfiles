---
name: memory-status
description: Show memory-episodes system status. Use when user wants to check conversation memory health or see recent entries.
allowed-tools: Bash Read
metadata:
  user-invocable: "true"
---

# Memory Status

Shows file counts, breakdown by type, date range, and recent entries.

## Usage

```text
/memory-status
```

## Implementation

```bash
~/.claude/skills/memory-status/scripts/status
```

## Output Format

Present the script output as-is. Highlight any issues (e.g. qmd
collection not indexed).
