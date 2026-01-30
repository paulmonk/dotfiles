# Issue Tracking with Beads

When a project uses **beads** (`bd`), use it for tracking work across sessions. Run `bd prime` for full workflow context or `bd hooks install` for auto-injection.

| Command                                      | Purpose                                   |
| -------------------------------------------- | ----------------------------------------- |
| `bd ready`                                   | Find unblocked work ready to start        |
| `bd show <id>`                               | View issue details                        |
| `bd create "Title" --type task --priority 2` | Create a new issue                        |
| `bd update <id> --status in_progress`        | Mark work as started                      |
| `bd close <id>`                              | Complete and close an issue               |
| `bd sync`                                    | Sync with git remote (run at session end) |

Issue types: `task`, `bug`, `story`, `epic`, `spike`. Priority: 1 (highest) to 4 (lowest).
