---
name: homunculus-instinct-import
description: Import instincts from a tarball. Use when user wants to load instincts shared by others or restore from a backup.
allowed-tools: Bash
metadata:
  user-invocable: "true"
---

# Instinct Import

Imports instincts from a tarball into the inherited directory.

## Usage

```
/homunculus-instinct-import path/to/instincts.tar.gz
/homunculus-instinct-import instincts.tar.gz --dry-run
```

## Implementation

### Preview import

```bash
~/.claude/skills/homunculus-instinct-import/scripts/import --dry-run FILE
```

### Import instincts

```bash
~/.claude/skills/homunculus-instinct-import/scripts/import FILE
```

## Import Behaviour

1. **Destination**: Goes to `~/.claude/homunculus/instincts/inherited/` (not personal)
2. **Confidence cap**: All imported instincts capped at 0.5
3. **Separation**: Imported instincts are kept separate from personal ones

## Notes

- You can see where each behaviour came from
- Imported instincts must earn higher confidence through your own usage
