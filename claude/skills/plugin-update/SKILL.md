---
name: plugin-update
description: Clear Claude Code plugin cache to force fresh install on restart
allowed-tools: Bash
---

# Plugin Update

Clear the Claude Code plugin cache and metadata to force all
plugins to reinstall fresh on next startup.

## Usage

```text
/plugin-update
```

## Workflow

### 1. Create Backup Directory

```bash
mkdir -p /tmp/claude/plugins
```

### 2. Move Plugin Metadata

```bash
mv ~/.claude/plugins/installed_plugins.json "/tmp/claude/plugins/installed_plugins-$(date +%s).json"
```

### 3. Move Plugin Cache

```bash
mv ~/.claude/plugins/cache "/tmp/claude/plugins/cache-$(date +%s)"
```

### 4. Notify User

> Plugin cache and metadata cleared. Please restart Claude Code (`:q` then reopen) to reinstall plugins at their latest versions.

## Notes

- Original files are backed up to `/tmp/claude/plugins/` with timestamps
- Safe to run multiple times
- Restart required for changes to take effect
