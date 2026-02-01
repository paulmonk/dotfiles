---
name: plugin-update
description: Clear Claude Code plugin cache to force fresh install on restart
allowed-tools: Bash(mkdir /tmp/claude/plugins) Bash(mv ~/.claude/plugins/cache "/tmp/claude/plugins/cache-$(date
+%s)"), Bash(mv ~/.claude/plugins/installed_plugins.json "/tmp/claude/plugins/installed_plugins-$(date +%s).json")
---

# Plugin Update

Clear the Claude Code plugin cache and metadata to force all plugins to reinstall fresh on next startup.

## Usage

```
/plugin-update
```

## Workflow

1. Move the installed plugins metadata to /tmp:

```bash
mkdir /tmp/claude/plugins
mv ~/.claude/plugins/installed_plugins.json "/tmp/claude/plugins/installed_plugins-$(date +%s).json"
```

2. Move the plugin cache directory to /tmp:

```bash
mv ~/.claude/plugins/cache "/tmp/claude/plugins/cache-$(date +%s)"
```

3. Inform the user:

> Plugin cache and metadata cleared. Please restart Claude Code (`:q` then reopen) to reinstall plugins at their latest versions.
