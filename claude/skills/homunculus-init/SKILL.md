---
name: homunculus-init
description: Initialise the homunculus continuous learning system. Use when setting up a new machine or verifying the system is configured correctly.
allowed-tools: Bash Read
metadata:
  user-invocable: "true"
---

# Homunculus Init

Sets up the directory structure and verifies configuration for the
continuous learning system.

## Usage

```text
/homunculus-init
```

## Implementation

```bash
~/.claude/skills/homunculus-init/scripts/init
```

After initialisation, run `/homunculus-status` to verify.

## What It Creates

```text
~/.claude/homunculus/
├── conversations/
├── convictions/
├── episodes/
├── identity.json
├── instincts/
│   └── personal/
├── logs/
│   └── observer.log
├── observations/
│   └── {session_id}.jsonl
├── observations.archive/
├── observer.lock
└── sessions/
```

## Example Output

```text
Created directory structure
Created identity.json
Hook configured: homunculus-observe
Verified qmd collections
```
