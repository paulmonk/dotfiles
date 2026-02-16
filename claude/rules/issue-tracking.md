# Issue Tracking with Beads

When a project has a `.beads/` directory, use `bd` for all issue
tracking.

## Session Start

If `.beads/` exists and `bd prime` output was not already
injected (e.g. by the beads plugin), run `bd prime` to load
workflow context. In Claude Code the plugin handles this
automatically. In Codex and OpenCode, run it manually at
session start.

## Plans Require Issues

When entering plan mode, ensure the work is tracked by a beads
issue. If you are already working on an existing issue, link
the plan to it. Otherwise, create an issue before writing the
plan.

Exceptions (no issue needed):

- Pure research or exploration with no code changes.
- The plan is a continuation of an issue already in context.

## Core Workflow

- Always include `--acceptance` with checklist items.
- Run `bd lint <id>` after creating to verify the issue passes.
- Apply area labels when creating issues.

## Issue Templates

Templates live in `~/.config/bd/templates/{type}.md`. Read
the template for the issue type before creating.

Fill in the template sections as `--description` and extract the
acceptance criteria into `--acceptance`:

```bash
bd create --title="..." --type=task --priority=2 \
  --description="<sections from template>" \
  --acceptance="- [ ] Criterion 1
- [ ] Criterion 2"
```

## Command Reference

### Finding Work

| Command                        | Purpose                            |
| ------------------------------ | ---------------------------------- |
| `bd ready`                     | Find unblocked work ready to start |
| `bd list --status=open`        | All open issues                    |
| `bd list --status=in_progress` | Active work                        |
| `bd show <id>`                 | Detailed issue view                |
| `bd stale`                     | Find forgotten issues              |
| `bd find-duplicates`           | Find semantically similar issues   |

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

| Command                    | Purpose                               |
| -------------------------- | ------------------------------------- |
| `bd dep add <issue> <dep>` | Issue depends on dep                  |
| `bd blocked`               | Show all blocked issues               |
| `bd defer <id>`            | Ice-box an issue (removes from ready) |
| `bd undefer <id>`          | Bring deferred issue back             |
| `bd graph --all`           | Visualise dependency DAG              |

### Querying

| Command                     | Purpose                                   |
| --------------------------- | ----------------------------------------- |
| `bd query "expr"`           | Rich filtering with boolean ops and dates |
| `bd label add <id> <label>` | Add area label                            |

## Labels

Apply area labels when creating issues. Suggested labels vary by
repo; infer from existing issues and project structure.

## Quality Checklist

- After creating: run `bd lint <id>` to verify template compliance.
- Before starting work: confirm the issue has acceptance criteria.
- Before closing: verify all acceptance criteria are met.

Issue types: `task`, `bug`, `feature`, `story`, `epic`, `spike`.
Priority: 0 (critical) to 4 (backlog).
