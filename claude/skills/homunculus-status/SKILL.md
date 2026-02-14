---
name: homunculus-status
description: Show homunculus system status, instinct confidence levels, and counts. Use when user wants to check system health or see learned patterns.
allowed-tools: Bash Read
metadata:
  user-invocable: "true"
---

# Homunculus Status

Shows system health, file counts, and all learned instincts
with confidence scores.

## Usage

```text
/homunculus-status
/homunculus-status --domain code-style
```

## Implementation

### Full status

```bash
~/.claude/skills/homunculus-status/scripts/status
```

### Filter instincts by domain

```bash
~/.claude/skills/homunculus-status/scripts/status code-style
```

### Show single instinct

```bash
cat ~/.claude/homunculus/instincts/personal/[NAME].md
```

## Output Format

Present the script output as two sections:

### System overview

Show the counts and directory health as-is from the script.

### Instincts table

Group the instinct lines by domain:

```text
## CODE-STYLE (3)

| Confidence | Name | Trigger |
|------------|------|---------|
| 0.7 | prefer-functional | when writing new functions |
| 0.6 | use-path-aliases | when importing modules |

## TESTING (2)

| Confidence | Name | Trigger |
|------------|------|---------|
| 0.8 [promoted] | test-first | when adding new functionality |
```
