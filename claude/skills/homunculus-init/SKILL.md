---
name: homunculus-init
description: Initialise the homunculus continuous learning system. Use when setting up a new machine or verifying the system is configured correctly.
allowed-tools: Bash Read
metadata:
  user-invocable: "true"
---

# Homunculus Init

Sets up the directory structure and verifies configuration for the continuous learning system.

## Usage

```
/homunculus-init
/homunculus-init --status
```

## Implementation

### Full initialisation

```bash
~/.claude/skills/homunculus-init/scripts/init
~/.claude/skills/homunculus-init/scripts/status
```

### Status only

```bash
~/.claude/skills/homunculus-init/scripts/status
```

## What It Creates

```
~/.claude/homunculus/
├── identity.json
├── observations/
│   └── {session_id}.jsonl
├── observations.archive/
├── instincts/
│   ├── personal/
│   └── inherited/
├── sessions/
├── episodes/
├── evolved/
│   ├── skills/
│   ├── commands/
│   └── agents/
└── exports/
```

## Example Output

```
Created directory structure
Created identity.json
Hook configured: homunculus-observe

=== Homunculus Status ===

Directories:
  [x] instincts/personal
  [x] instincts/inherited
  [x] evolved/skills
  [x] observations.archive

Sessions: 0

Instincts:
  Personal:  0
  Inherited: 0
```
