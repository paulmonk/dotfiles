# Issue Tracking with Beads

When a project has a `.beads/` directory, use `bd` for all issue
tracking. Core commands are documented in the beads plugin
context; this file covers workflow policy.

## Plans Require Issues

When entering plan mode, ensure the work is tracked by a beads
issue. If you are already working on an existing issue, link
the plan to it. Otherwise, create an issue before writing the
plan.

Exceptions (no issue needed):

- Pure research or exploration with no code changes.
- The plan is a continuation of an issue already in context.

## Creating Issues

- Read the template from `~/.config/bd/templates/{type}.md`
  before creating.
- Always include `--acceptance` with checklist items.
- Apply area labels when creating issues.
- Run `bd lint <id>` after creating to verify compliance.

## Additional Commands

Commands not covered by the beads plugin context:

| Command                     | Purpose                               |
| --------------------------- | ------------------------------------- |
| `bd stale`                  | Find forgotten issues                 |
| `bd find-duplicates`        | Find semantically similar issues      |
| `bd defer <id>`             | Ice-box an issue (removes from ready) |
| `bd undefer <id>`           | Bring deferred issue back             |
| `bd graph --all`            | Visualise dependency DAG              |
| `bd query "expr"`           | Rich filtering with boolean ops       |
| `bd label add <id> <label>` | Add area label                        |
| `bd lint <id>`              | Validate issue template               |
| `bd lint`                   | Lint all open issues                  |

## Quality Checklist

- Before starting work: confirm the issue has acceptance criteria.
- Before closing: verify all acceptance criteria are met.

Issue types: `task`, `bug`, `feature`, `story`, `epic`, `spike`.
Priority: 0 (critical) to 4 (backlog).
