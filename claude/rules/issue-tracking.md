# Issue Tracking with Beads

When a project has a `.beads/` directory, use `bd` for all issue
tracking. Run `bd prime` for full workflow context or
`bd hooks install` for auto-injection.

## Core Workflow

- Use `bd create` directly (not the `beads:create` skill) so
  PreToolUse hooks can enforce templates.
- Always include `--acceptance` with checklist items.
- Run `bd lint <id>` after creating to verify the issue passes.
- Apply area labels when creating issues.

## Issue Templates

Templates live in `claude/templates/issues/{type}.md`. Read the
template for the issue type before creating. The `bd-create-guard`
hook enforces `--acceptance` on all types and `Steps to Reproduce`
on bugs.

Fill in the template sections as `--description` and extract the
acceptance criteria into `--acceptance`:

```bash
bd create --title="..." --type=task --priority=2 \
  --description="$(cat <<'EOF'
<sections from claude/templates/issues/task.md>
EOF
)" \
  --acceptance="- [ ] Criterion 1
- [ ] Criterion 2"
```

## Command Reference

### Finding Work

| Command                   | Purpose                                     |
| ------------------------- | ------------------------------------------- |
| `bd ready`                | Find unblocked work ready to start          |
| `bd list --status=open`   | All open issues                             |
| `bd list --status=in_progress` | Active work                            |
| `bd show <id>`            | Detailed issue view with dependencies       |
| `bd stale`                | Find forgotten issues                       |
| `bd find-duplicates`      | Find semantically similar issues            |

### Creating and Updating

| Command                                   | Purpose                       |
| ----------------------------------------- | ----------------------------- |
| `bd create --title="..." --type=task ...` | Create a new issue            |
| `bd update <id> --status=in_progress`     | Claim work                    |
| `bd close <id>`                           | Complete an issue             |
| `bd close <id1> <id2> ...`                | Close multiple issues at once |
| `bd lint <id>`                            | Validate issue template       |
| `bd lint`                                 | Lint all open issues          |

### Dependencies and Blocking

| Command                       | Purpose                                  |
| ----------------------------- | ---------------------------------------- |
| `bd dep add <issue> <dep>`    | Issue depends on dep                     |
| `bd blocked`                  | Show all blocked issues                  |
| `bd defer <id>`               | Ice-box an issue (removes from ready)    |
| `bd undefer <id>`             | Bring deferred issue back                |
| `bd graph --all`              | Visualise dependency DAG                 |

### Querying

| Command                     | Purpose                                   |
| --------------------------- | ----------------------------------------- |
| `bd query "expr"`           | Rich filtering with boolean ops and dates |
| `bd label add <id> <label>` | Add area label                            |

### Persistence and Sync

| Command                       | Purpose                                |
| ----------------------------- | -------------------------------------- |
| `bd sync`                     | Sync with git remote (session end)     |
| `bd sync --status`            | Check sync status without syncing      |
| `bd kv set <key> <value>`     | Store persistent key-value data        |
| `bd kv get <key>`             | Retrieve persistent data               |
| `bd worktree create <name>`   | Create worktree with beads redirect    |

## Labels

Apply area labels when creating issues. Suggested labels vary by
repo; infer from existing issues and project structure.

## Quality Checklist

- After creating: run `bd lint <id>` to verify template compliance.
- Before starting work: confirm the issue has acceptance criteria.
- Before closing: verify all acceptance criteria are met.

Issue types: `task`, `bug`, `feature`, `story`, `epic`, `spike`.
Priority: 0 (critical) to 4 (backlog).
