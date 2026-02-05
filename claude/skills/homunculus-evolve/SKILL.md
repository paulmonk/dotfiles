---
name: homunculus-evolve
description: Cluster related instincts into skills, commands, or agents. Use when user has accumulated enough instincts and wants to create higher-level automations.
allowed-tools: Bash Read Write
metadata:
  user-invocable: "true"
---

# Evolve

Analyses instincts and clusters related ones into higher-level structures.

## Usage

```
/homunculus-evolve                 # Preview what would be created
/homunculus-evolve --execute       # Create the evolved structures
```

## Implementation

### Check for clustering

```bash
# Count instincts per domain
for f in ~/.claude/homunculus/instincts/personal/*.md; do
  [ -f "$f" ] && grep "^domain:" "$f"
done 2>/dev/null | cut -d: -f2 | tr -d ' ' | sort | uniq -c | sort -rn
```

Domains with 5+ instincts are candidates for evolution.

### Read instincts in a domain

```bash
DOMAIN="code-style"
for f in ~/.claude/homunculus/instincts/personal/*.md; do
  [ -f "$f" ] || continue
  if grep -q "^domain: $DOMAIN" "$f"; then
    cat "$f"
    echo "---"
  fi
done
```

### Create evolved skill

Write to `~/.claude/homunculus/evolved/skills/[domain]-patterns.md`:

```markdown
---
name: [domain]-patterns
description: Auto-evolved from [N] instincts in [domain]
---

# [Domain] Patterns

Patterns evolved from observed behaviour.

## Guidelines

- **[trigger 1]**: [action 1]
- **[trigger 2]**: [action 2]

## Source Instincts

- `instinct-1` (confidence: 0.7)
- `instinct-2` (confidence: 0.6)
```

### Update identity

Clear the evolution flag after creating:

```bash
jq --arg d "DOMAIN" '.evolution.ready -= [$d]' \
  ~/.claude/homunculus/identity.json > tmp.json && mv tmp.json ~/.claude/homunculus/identity.json
```

## Evolution Types

| Type | When | Output |
|------|------|--------|
| Skill | Auto-triggered behaviours | `evolved/skills/` |
| Command | User-invoked actions | `evolved/commands/` |
| Agent | Complex multi-step processes | `evolved/agents/` |
