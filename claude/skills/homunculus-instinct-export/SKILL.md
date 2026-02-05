---
name: homunculus-instinct-export
description: Export instincts for sharing with others. Use when user wants to share learned patterns or back up their instincts to a file.
allowed-tools: Bash
metadata:
  user-invocable: "true"
---

# Instinct Export

Exports instincts to a tarball for sharing.

## Usage

```
/homunculus-instinct-export
/homunculus-instinct-export --min-confidence 0.7
/homunculus-instinct-export --output ~/my-instincts.tar.gz
```

## Implementation

### Export all (confidence >= 0.5)

```bash
~/.claude/skills/homunculus-instinct-export/scripts/export
```

### Export with confidence filter

```bash
~/.claude/skills/homunculus-instinct-export/scripts/export --min-confidence 0.7
```

### Export to specific path

```bash
~/.claude/skills/homunculus-instinct-export/scripts/export --output ~/my-instincts.tar.gz
```

## Output

Tell user:

- Number of instincts exported
- Path to tarball
- How to import: `/homunculus-instinct-import path/to/instincts.tar.gz`
